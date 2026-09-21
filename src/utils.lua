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

function SlopFactory.reroll_joker(card, args)
    args = args or {}
    -- rarity check
    local rarity = args.rarity
    if args.rarity == nil then
        local up_chance, down_chance = args.rarity_up or 0.25, args.rarity_down or 0.15
        local card_rarity = card.config.center.rarity
        local rarity_roll = pseudorandom(pseudoseed('slfa_reroll_rarity' .. (args.seed or '') .. G.GAME.round_resets.ante))
        print(rarity_roll)
        local delta_rarity = (rarity_roll >= 1-up_chance and 1) or (rarity_roll <= down_chance and -1) or 0
        print(delta_rarity)
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
        full_pool = args.pool or get_current_pool('Joker', rarity, false)
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

    -- if i'm stealing from handsome devils might as well leave in the compat
    --local has_cursed = card.ability and card.ability.hnds_cursed
    --local curse_data = has_cursed and card.ability.hnds_curse and copy_table(card.ability.hnds_curse) or nil

    if center then
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

    return card

end