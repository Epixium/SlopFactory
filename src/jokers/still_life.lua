SMODS.Joker {
    key = 'still_life',
    atlas = 'jokers',
    pos = {
        x = 3,
        y = 3
    },
    rarity = 2,
    cost = 6,
    attributes = { 'face', 'debuff', 'chance', 'hand_size' },
    config = { extra = { odds = 3, h_size = 0, h_size_per = 1 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Other', key = 'debuffed_playing_card'}
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'slfa_astrologer')
        return { vars = { numerator, denominator, card.ability.extra.h_size_per, card.ability.extra.h_size } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            for _, other_card in pairs(context.full_hand) do
                if other_card:is_face(true) then
                    count = count + 1
                end
            end
            if count == 0 then return false end
            
            local old_h_size = card.ability.extra.h_size
            for i = 0, count do
                if SMODS.pseudorandom_probability(card, 'slfa_still_life', 1, card.ability.extra.odds) then
                    card.ability.extra.h_size = card.ability.extra.h_size + 1
                end
            end

            if card.ability.extra.h_size == old_h_size then return false end
            return {
                message = localize { type = 'variable', key = 'a_handsize', vars = { card.ability.extra.h_size - old_h_size } },
                func = function() -- This is for timing purposes, this goes after the dollar modification
                    if context.blueprint then return end
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.hand:change_size(card.ability.extra.h_size - old_h_size)
                            return true
                        end
                    }))
                end
            }
        end
        if context.setting_blind and not context.blueprint then
            SlopFactory.update_debuffed()
        end
        if context.end_of_round and card.ability.extra.h_size ~= 0 and not context.blueprint then
            G.hand:change_size(-card.ability.extra.h_size)
            card.ability.extra.h_size = 0
            return {
                message = localize('k_reset'),
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "count" },
            },
            text_config = { colour = G.C.ORANGE },
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "odds" },
                    { text = ")" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            calc_function = function(card)
                local count = 0
                local text, _, _ = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, other_card in pairs(JokerDisplay.current_hand) do
                        if other_card:is_face(true) then
                            count = count + 1
                        end
                    end
                end
                card.joker_display_values.count = count
                local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'slfa_prime_day')
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
             end,
        }
    end
}


local debuff_card_ref = Blind.debuff_card
function Blind.debuff_card(self, card, from_blind)
    local ret = debuff_card_ref(self, card, from_blind)
    if card.area ~= G.jokers then
        if next(SMODS.find_card('j_slfa_still_life')) then
            if card.playing_card and card:is_face(true) then
                card:set_debuff(true)
                if card.debuff then card.debuffed_by_blind = true end
            end
        end
    end

    return ret
end