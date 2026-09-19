SMODS.Joker {
    key = 'fools_gold',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 1,
        y = 3
    },
    rarity = 2,
    cost = 8,
    attributes = { 'xmult', 'enhancements', 'passive', 'economy' },
    config = { extra = { Xmult_minus = 0.75 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
        return { vars = { card.ability.extra.Xmult_minus } }
    end,
    calculate = function(self, card, context)
        if context.check_enhancement then
            if context.other_card.config.center.key == 'c_base' then
                return {
                    m_gold = true
                }
            end
        end
        if context.individual and context.cardarea == G.hand and not context.end_of_round
            and SMODS.has_enhancement(context.other_card, 'm_gold') then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                return {
                    x_mult = card.ability.extra.Xmult_minus
                }
            end
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
                    }
                }
            },
            calc_function = function(card)
                local playing_hand = next(G.play.cards)
                local count = 0
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if not (playing_card.facing == 'back') and not playing_card.debuff and SMODS.has_enhancement(playing_card, 'm_gold') then
                            count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                        end
                    end
                end
                card.joker_display_values.x_mult = card.ability.extra.Xmult_minus ^ count
            end
        }
    end
}