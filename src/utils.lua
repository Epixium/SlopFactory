-- Update the debuffed state of all playing cards.
function SlopFactory.update_debuffed()
    G.E_MANAGER:add_event(Event {
        func = function()
            for k, v in ipairs(G.playing_cards) do
                G.GAME.blind:debuff_card(v)
            end
            return true
        end
    })
end

--[[
elseif self.config.center.name == "Half Joker" then
        self.T.h = H*scale/1.7*scale
        self.T.w = W*scale
    elseif self.config.center.name == "Wee Joker" then 
        self.T.h = H*scale*0.7*scale
        self.T.w = W*scale*0.7*scale
    elseif self.config.center.name == "Photograph" then 
        self.T.h = H*scale/1.2*scale
        self.T.w = W*scale
    elseif self.config.center.name == "Square Joker" then
        H = W 
        self.T.h = H*scale
        self.T.w = W*scale
]]

local basegame_scales = {
    j_half       = { w = 71,       h = 95 / 1.7 },
    j_wee        = { w = 71 * .7,  h = 95 * .7  },
    j_photograph = { w = 71,       h = 95 / 1.2 },
    j_square     = { w = 71,       h = 71       },
}

function SlopFactory.change_joker_center(card, center)

    print(card.config.center.key)
    if card.remove_from_deck and type(card.remove_from_deck) == 'function' then
        print("step 1")
        local fake_card = SMODS.shallow_copy(card)
        print("step 2")
        --if card.ability then fake_card.ability = copy_table(card.ability) end
        fake_card:remove_from_deck()
        print("step 3")
    end
    card.added_to_deck = false
    print("step 4")
    print(center.key)
    local default_center = G.P_CENTERS[card.config.center.key]
    local old_size = {
        w = card.T.w,
        h = card.T.h
    }
    if basegame_scales[card.config.center.key] then
        old_size.w = old_size.w / basegame_scales[card.config.center.key].w * 71
        old_size.h = old_size.h / basegame_scales[card.config.center.key].h * 95
    end
    if default_center.pixel_size then
        print(default_center.pixel_size)
        old_size.w = old_size.w / (default_center.pixel_size.w or 71) * 71
        old_size.h = old_size.h / (default_center.pixel_size.h or 95) * 95
    end
    if default_center.display_size then
        print(default_center.display_size)
        old_size.w = old_size.w / (default_center.display_size.w or 71) * 71
        old_size.h = old_size.h / (default_center.display_size.h or 95) * 95
    end
    card:set_ability(center, true)
    card.T.w = old_size.w
    card.T.h = old_size.h
    if basegame_scales[center.key] then
        card.T.w = card.T.w * basegame_scales[center.key].w / 71
        card.T.h = card.T.h * basegame_scales[center.key].h / 95
    end
    if center.pixel_size then
        card.T.w = card.T.w * (center.pixel_size.w or 71) / 71
        card.T.h = card.T.h * (center.pixel_size.h or 95) / 95
    end
    if center.display_size then
        card.T.w = card.T.w * (center.display_size.w or 71) / 71
        card.T.h = card.T.h * (center.display_size.h or 95) / 95
    end
    print("step 5")
    card:add_to_deck(nil, true)
    print("step 6")

    card:start_materialize()
    card:juice_up(0.5, 0.3)
    play_sound('card1', 1, 0.6)

end

local rarities = {"Common", "Uncommon", "Rare", "Legendary"}
-- stolen from handsome devils
function SlopFactory.reroll_joker(card, args)
    args = args or {}
    -- rarity check
    local old_rarity = card.config.center.rarity
    local rarity = args.rarity
    if args.rarity == nil then
        local up_chance, down_chance = args.rarity_up or 0.25, args.rarity_down or 0.15
        local card_rarity = card.config.center.rarity
        local rarity_roll = pseudorandom(pseudoseed('slfa_reroll_rarity' .. (args.seed or '') .. G.GAME.round_resets.ante))
        local delta_rarity = (rarity_roll >= 1-up_chance and 1) or (rarity_roll <= down_chance and -1) or 0
        rarity = (1 <= card_rarity and card_rarity <= 3 and math.max(1, math.min(3, card_rarity + delta_rarity))) or card_rarity
    end
    -- set up the pool with which to roll from
    local full_pool
    if args.pool then
        local valid_keys = {}
        for _, key in ipairs(args.pool) do
            if G.P_CENTERS[key].rarity == rarity and key ~= 'UNAVAILABLE' then
                valid_keys[#valid_keys+1] = key
            end
        end
        full_pool = valid_keys
    else
        local all_keys = get_current_pool('Joker', rarities[rarity] or rarity, false)
        local valid_keys = {}
        for _, key in ipairs(all_keys) do
            if key ~= 'UNAVAILABLE' then
                valid_keys[#valid_keys+1] = key
            end
        end
        full_pool = valid_keys
    end
    if args.attributes then
        local available_pool = {}
        for _, key in ipairs(full_pool) do
            for _, attribute in ipairs(args.attributes) do
                if SMODS.has_attribute(G.P_CENTERS[key], attribute) then
                    available_pool[#available_pool+1] = key
                end
            end
        end
        full_pool = available_pool
    end
    if args.filter then
        local available_pool = {}
        for _, key in ipairs(full_pool) do
            if args.filter(key) then
                available_pool[#available_pool+1] = key
            end
        end
        full_pool = available_pool
    end

    local center = nil
    if next(full_pool) then
        local chosen_key = pseudorandom_element(full_pool, pseudoseed('slfa_reroll_joker' .. (args.seed or '') .. G.GAME.round_resets.ante))
        center = G.P_CENTERS[chosen_key]
    end

    if center then
        if args.no_delay then
            SlopFactory.change_joker_center(card, center)
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    SlopFactory.change_joker_center(card, center)
                    return true
                end
            }))
        end
    end

    local delta_rarity = (rarity - old_rarity) or nil
    
    local message_table = {
        message = localize((tonumber(delta_rarity) == nil and 'k_slfa_reroll_joker')
            or (delta_rarity > 0 and 'k_slfa_reroll_joker_up')
            or (delta_rarity < 0 and 'k_slfa_reroll_joker_down')
            or 'k_slfa_reroll_joker'),
        colour = SMODS.Rarities[rarities[rarity] or rarity].badge_colour,
    }

    return message_table

end

function SlopFactory.load_src(folder_name)
    local src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/" .. folder_name)
    for _, file in ipairs(src) do
        assert(SMODS.load_file("src/" .. folder_name .. "/" .. file))()
    end
end