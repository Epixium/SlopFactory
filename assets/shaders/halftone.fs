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
extern PRECISION vec2 halftone;

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

vec2 rotate(vec2 p, number a) {
    return vec2(p.x*cos(a)-p.y*sin(a), p.y*cos(a)+p.x*sin(a));
}

vec2 texture_coords_to_uv(Image texture, vec2 texture_coords) {
    return (texture_coords*image_details)/texture_details.ba - texture_details.xy;
}

// for pixel coords, you just add pixel_offset/image_details to texture coords
// (texture_coords*image_details+pixel_offset)/texture_details.ba


vec2 uv_to_texture_coords(Image texture, vec2 uv_coords) {
    // texcoords to uv: uv = ( ((coords * image size)) - texture pos * texture height ) / texture height
    // coords = (uv + texture pos) * texture height / image size
    return (uv_coords + texture_details.xy)*texture_details.ba / image_details;
}

// (uv_coords + texture_details.xy)

vec4 CMYK(vec4 color)
{
    number k = 1. - max(max(color.r, color.g), color.b);
    number c = (1. - color.r - k) / (1. - k);
    number m = (1. - color.g - k) / (1. - k);
    number y = (1. - color.b - k) / (1. - k);
    
    return vec4(c, m, y, k);
}

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

vec3 dodge(vec3 x, number b)
{
    return x / (1 - b);
}

vec4 get_colors(Image texture, vec2 uv) {

    number a = Texel(texture, uv_to_texture_coords(texture, uv)).a;
    if (a == 0.) { return vec4(0); }

    vec2 c_uv = rotate(uv + vec2(0.0035, -.0053) - 0.5, 0.003) + 0.5;
    vec2 m_uv = rotate(uv + vec2(-.0072, 0.0048) - 0.5, 0.011) + 0.5;
    vec2 y_uv = rotate(uv + vec2(0.0078, -.0032) - 0.5, -.007) + 0.5;
    vec2 k_uv = rotate(uv + vec2(0.0004, 0.0005) - 0.5, 0.000) + 0.5;

    vec4 c_base = Texel(texture, uv_to_texture_coords(texture, c_uv));
    vec4 m_base = Texel(texture, uv_to_texture_coords(texture, m_uv));
    vec4 y_base = Texel(texture, uv_to_texture_coords(texture, y_uv));
    vec4 k_base = Texel(texture, uv_to_texture_coords(texture, k_uv));
    
    number c_k = 1. - max(max(c_base.r, c_base.g), c_base.b);
    number m_k = 1. - max(max(m_base.r, m_base.g), m_base.b);
    number y_k = 1. - max(max(y_base.r, y_base.g), y_base.b);

    number k = 1. - max(max(k_base.r, k_base.g), k_base.b);
    number c = (1. - c_base.r - c_k) / (1. - c_k);
    number m = (1. - m_base.g - m_k) / (1. - m_k);
    number y = (1. - y_base.b - y_k) / (1. - y_k);

    return vec4(c, m, y, k);

}

vec2 to_halftone_coords(vec2 uv, vec2 dot_size, number rotation) {
    return rotate((uv-0.5)*dot_size, 0.58+0.094*halftone.x+0.00238*halftone.y+rotation)+0.5*dot_size;
}

// htc = rotate((uv-0.5)*dot_size, 0.58+0.094*halftone.x)+0.5*dot_size;
// htc - 0.5 * dot_size = rotate((uv-0.5)*dot_size, 0.58+0.094*halftone.x);
// rotate(htc - 0.5 * dot_size, -0.58-0.094*halftone.x) = (uv-0.5)*dot_size
// rotate(htc - 0.5 * dot_size, -0.58-0.094*halftone.x).dot_size+0.5 = uv

vec2 round_to_halftone(vec2 uv, vec2 dot_size, vec2 offset, number rotation) {
    vec2 htc = to_halftone_coords(uv+offset, dot_size, rotation);
    htc = floor(htc);
    return rotate(htc - 0.5 * dot_size, -0.58-0.094*halftone.x-0.00238*halftone.y-rotation)/dot_size + 0.5;
}

vec3 apply_colors(vec3 paper_base, vec4 c, number threshold) {
    // cyan
    if (c.x > threshold) { paper_base.rgb = paper_base.rgb - (vec3(1.) - vec3(0.121,0.895,0.961)); }
    // magenta
    if (c.y > threshold) { paper_base.rgb = paper_base.rgb - (vec3(1.) - vec3(0.924,0.113,0.918)); }
    // yellow
    if (c.z > threshold) { paper_base.rgb = paper_base.rgb - (vec3(1.) - vec3(0.989,0.912,0.115)); }
    // black
    if (c.a > threshold) { paper_base.rgb = paper_base.rgb - (vec3(1.) - vec3(0.333,0.352,0.385)); }

    return paper_base;
}

vec4 one_pass(Image texture, vec2 uv, number d, vec2 slight_offset, number slight_rotation) {

    number a = Texel(texture, uv_to_texture_coords(texture, uv)).a;
    if (a == 0.) { return vec4(0); }

    vec2 dot_size = vec2(d);
    dot_size.y = dot_size.y * texture_details.a / texture_details.b;

    vec2 rounded = round_to_halftone(uv, dot_size, slight_offset, slight_rotation)+vec2(1/texture_details.b,0);
    vec4 c = get_colors(texture, rounded);

    vec2 halftone_uv = to_halftone_coords(uv + slight_offset, dot_size, slight_rotation);
    vec2 pattern_uv = mod(halftone_uv, 1)*2-1;
    number threshold = sqrt(pattern_uv.x * pattern_uv.x + pattern_uv.y * pattern_uv.y); // 1/sqrt(2)

    vec3 paper_base = vec3(1.);
    paper_base = apply_colors(paper_base, c, threshold);

    return vec4(paper_base, a);

}

// This is what actually changes the look of card
vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    // Take pixel color (rgba) from `texture` at `texture_coords`, equivalent of texture2D in GLSL
    vec4 tex = Texel(texture, texture_coords);
    // Position of a pixel within the sprite
    // ( ((coords * image size)) - texture pos * texture height ) / texture height
	vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;
    // dummy so the game doesnt complain
    vec4 col = vec4(one_pass(texture, uv, 31.88, vec2(0.), 0).rgb
            * one_pass(texture, uv, 62.356, vec2(0.), 0).rgb
            * one_pass(texture, uv, 36.5, vec2(0.), 0).rgb
            * one_pass(texture, uv, 48.51, vec2(0.), 0).rgb
            * one_pass(texture, uv, 31., vec2(0.001), 0.002).rgb
            , 1.);

    // desaturate the result slightly to fit the balatro style
    vec4 hsl = HSL(col);
    col = RGB(vec4(hsl.x, hsl.y * 0.8, hsl.z * 0.8 + 0.2, hsl.a));
    tex.rgb = (tex.rgb * 0.2 + 0.8) * col.rgb;

    // generic shimmer copied straight from negative_shine.fs
    number low = min(tex.r, min(tex.g, tex.b));
    number high = max(tex.r, max(tex.g, tex.b));
    number delta = high-low -0.1;

    number fac = 0.8 + 0.9*sin(11.*uv.x+4.32*uv.y + halftone.r*12. + cos(halftone.r*5.3 + uv.y*4.2 - uv.x*4.));
    number fac2 = 0.5 + 0.5*sin(8.*uv.x+2.32*uv.y + halftone.r*5. - cos(halftone.r*2.3 + uv.x*8.2));
    number fac3 = 0.5 + 0.5*sin(10.*uv.x+5.32*uv.y + halftone.r*6.111 + sin(halftone.r*5.3 + uv.y*3.2));
    number fac4 = 0.5 + 0.5*sin(3.*uv.x+2.32*uv.y + halftone.r*8.111 + sin(halftone.r*1.3 + uv.y*11.2));
    number fac5 = sin(0.9*16.*uv.x+5.32*uv.y + halftone.r*12. + cos(halftone.r*5.3 + uv.y*4.2 - uv.x*4.));

    number maxfac = max(max(fac, max(fac2, max(fac3,0.0))) + (fac+fac2+fac3*fac4), 0.);

    tex.rgb = min(tex.rgb * vec3(.86, .892, .885) + maxfac * 0.053, 1.);
    
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
	
	vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 971.4324));
	vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 471.0000));

    float field = (1.+ (
        cos(length(field_part1) / 171.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
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