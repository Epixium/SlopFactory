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
            if G.P_CENTERS[key].rarity == rarity then
                valid_keys[#valid_keys+1] = key
            end
        end
        full_pool = valid_keys
    else
        local valid_keys = get_current_pool('Joker', rarities[rarity] or rarity, false)
        for i, key in ipairs(valid_keys) do
            if key == 'UNAVAILABLE' then
                table.remove(valid_keys, i)
            end
        end
        full_pool = valid_keys
    end
    if args.attributes then
        local available_pool = {}
        for _, key in ipairs(full_pool) do
            for _, attribute in args.attributes do
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
            if card.remove_from_deck and type(card.remove_from_deck) == 'function' then
                pcall(card.remove_from_deck, card)
            end
            card:set_ability(center, true)
            card:add_to_deck()

            card:start_materialize()
            card:juice_up(0.5, 0.3)
            play_sound('card1', 1, 0.6)
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    if card.remove_from_deck and type(card.remove_from_deck) == 'function' then
                        pcall(card.remove_from_deck, card)
                    end
                    card:set_ability(center, true)
                    card:add_to_deck()

                    card:start_materialize()
                    card:juice_up(0.5, 0.3)
                    play_sound('card1', 1, 0.6)
                    return true
                end
            }))
        end
    end

    local delta_rarity = (rarity - old_rarity) or nil
    
    local message_table = {
        message = localize((tonumber(delta_rarity) == nil and 'slfa_rewarded_ad_reroll')
            or (delta_rarity > 0 and 'slfa_rewarded_ad_rarity_up')
            or (delta_rarity < 0 and 'slfa_rewarded_ad_rarity_down')
            or 'slfa_rewarded_ad_reroll'),
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