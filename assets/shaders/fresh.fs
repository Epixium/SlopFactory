#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define PRECISION highp
#else
    #define PRECISION mediump
#endif

// !! change this variable name to your Shader's name
// YOU MUST USE THIS VARIABLE IN THE vec4 effect AT LEAST ONCE

// Values of this variable:
// self.ARGS.send_to_shader[1] = math.min(self.VT.r*3, 1) + (math.sin(G.TIMERS.REAL/28) + 1) + (self.juice and self.juice.r*20 or 0) + self.tilt_var.amt
// self.ARGS.send_to_shader[2] = G.TIMERS.REAL
extern PRECISION vec2 fresh;

extern PRECISION number dissolve;
extern PRECISION number time;
// [Note] sprite_pos_x _y is not a pixel position!
//        To get pixel position, you need to multiply  
//        it by sprite_width _height (look flipped.fs)
// (sprite_pos_x, sprite_pos_y, sprite_width, sprite_height) [not normalized]
extern PRECISION vec4 texture_details;
// (width, height) for atlas texture [not normalized]
extern PRECISION vec2 image_details;
extern bool shadow;
extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;

// [Required] 
// Apply dissolve effect (when card is being "burnt", e.g. when consumable is used)
vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv);

number hue(number s, number t, number h)
{
	number hs = mod(h, 1.)*6.;
	if (hs < 1.) return (t-s) * hs + s;
	if (hs < 3.) return t;
	if (hs < 4.) return (t-s) * (4.-hs) + s;
	return s;
}

vec4 RGB(vec4 c)
{
	if (c.y < 0.0001)
		return vec4(vec3(c.z), c.a);

	number t = (c.z < .5) ? c.y*c.z + c.z : -c.y*c.z + (c.y+c.z);
	number s = 2.0 * c.z - t;
	return vec4(hue(s,t,c.x + 1./3.), hue(s,t,c.x), hue(s,t,c.x - 1./3.), c.w);
}

vec4 HSL(vec4 c)
{
	number low = min(c.r, min(c.g, c.b));
	number high = max(c.r, max(c.g, c.b));
	number delta = high - low;
	number sum = high+low;

	vec4 hsl = vec4(.0, .0, .5 * sum, c.a);
	if (delta == .0)
		return hsl;

	hsl.y = (hsl.z < .5) ? delta / sum : delta / (2.0 - sum);

	if (high == c.r)
		hsl.x = (c.g - c.b) / delta;
	else if (high == c.g)
		hsl.x = (c.b - c.r) / delta + 2.0;
	else
		hsl.x = (c.r - c.g) / delta + 4.0;

	hsl.x = mod(hsl.x / 6., 1.);
	return hsl;
}

vec4 offset_tex(Image texture, vec2 texture_coords, number offset) {
    vec4 tex = Texel(texture, texture_coords+vec2(offset/image_details.x,0));
    if (tex.a == 0) { tex = vec4(1, 1, 1, 0); }
    return tex;
}

vec3 burn(vec3 x, vec3 b)
{
    return 1 - (1 - x) / b;
}

vec3 dodge(vec3 x, vec3 b)
{
    return x / (1 - b);
}

// This is what actually changes the look of card
vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    // Take pixel color (rgba) from `texture` at `texture_coords`, equivalent of texture2D in GLSL
    vec4 tex = Texel(texture, texture_coords);
    // Position of a pixel within the sprite
	vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;
    
    // For all vectors (vec2, vec3, vec4), .rgb is equivalent of .xyz, so uv.y == uv.g
    // .a is last parameter for vec4 (usually the alpha channel - transparency)

    //vec4 hsl = HSL(tex);
    //if (hsl.y > 0.1) {
    //    vec4 rgb = vec4(1);
    //    if (hsl.x < 0.1) { // should be magenta
    //        rgb = RGB(vec4(0.85 * .9 + (hsl.x-1+.85) * .1, hsl.y * 1.5, hsl.z + 0.1, hsl.a));
    //    } else if (hsl.x > 0.6) {
    //        rgb = RGB(vec4(0.85 * .9 + (hsl.x - .85) * .1, hsl.y * 1.5, hsl.z + 0.1, hsl.a));
    //    } else if (hsl.x < 0.4) { // should be yellow
    //        rgb = RGB(vec4(0.20 * .9 + (hsl.x - .20) * .1, hsl.y * 1.0, hsl.z,       hsl.a));
    //    } else { // should be cyan
    //        rgb = RGB(vec4(0.50 * .9 + (hsl.x - .50) * .1, hsl.y * 1.1, hsl.z,       hsl.a));
    //    }
    //    tex = tex * 0.5 + rgb * 0.5;
    //}
    //vec4 hsl = HSL(tex);
    //tex = RGB(vec4(hsl.x, hsl.y * 0.8, hsl.z * 0.95, hsl.a));
    tex.rgb = tex.rgb * (1 - fresh.x * 0.01);
    // color bleeding into lighter colors
    vec4 ltex  = (offset_tex(texture, texture_coords, -2)*4 
                + offset_tex(texture, texture_coords, -3)*2
                + offset_tex(texture, texture_coords, -4)
                )/7;
    vec4 rtex  = (offset_tex(texture, texture_coords, 2)*4 
                + offset_tex(texture, texture_coords, 3)*2
                + offset_tex(texture, texture_coords, 4)
                )/7;
    tex.rgb = tex.rgb * min((tex.rgb + ltex.rgb*.5 + rtex.rgb*.5)/tex.rgb/2, 1);
    // pink it a lil bit
    tex.rgb = tex.rgb * vec3(.96, .91, 1);
    // burn it a lil bit
    tex.rgb = tex.rgb * 0.6 + burn(tex.rgb, vec3(0.95, 0.81, 0.88)) * 0.4;
    // apply color bleeding
    vec3 mix = tex.gbr + tex.brg;
    tex.rgb += mix * mix * 0.02;
    // desaturate to fit with balatro more
    vec4 hsl = HSL(tex);
    hsl.y = hsl.y * 0.82;
    tex = RGB(hsl);

    // isolate into individual lights
    number column = mod(uv.x * texture_details.z * 0.5 + fresh.x * 2.35 + fresh.y * 0.18, 1.0);
    if (column < 0.3333) {
        tex.rgb = tex.rgb * vec3(1.25, 0.81, 0.805);
    } else if (column < 0.6667) {
        tex.rgb = tex.rgb * vec3(0.81, 1.25, 0.82);
    } else {
        tex.rgb = tex.rgb * vec3(0.82, 0.805, 1.25);
    }
    number row = mod(uv.y * 3 * texture_details.a * 0.5 + fresh.y * 2.35 + fresh.x * 0.18, 1.0);
    if (row > 0.9) {
        tex.rgb = tex.rgb * 0.95;
    }
    tex.rgb = dodge(tex.rgb, vec3(0.1));

    // required
    return dissolve_mask(tex*colour, texture_coords, uv);
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01; //Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

	float t = time * 10.0 + 2003.;
	vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
	
	vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : .0);
}

// for transforming the card while your mouse is on it
extern PRECISION vec2 mouse_screen_pos;
extern PRECISION float hovering;
extern PRECISION float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif