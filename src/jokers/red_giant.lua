SMODS.Joker {
    key = 'red_giant',
    perishable_compat = false,
    atlas = 'jokers',
    pos = {
        x = 9,
        y = 1
    },
    rarity = 3,
    cost = 8,
    attributes = { 'space', 'xmult', 'consumable', 'on_sell', 'scaling', 'reset' },
    config = { extra = { Xmult_gain = 0.1, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = 'Xmult',
                scalar_value = 'Xmult_gain'
            })
        end
        if context.selling_card and context.card.ability.consumeable and card.ability.extra.Xmult > 1 and not context.blueprint then
            SMODS.reset_card(card, {
                ref_table = card.ability.extra,
                ref_value = 'Xmult',
                reset_value = 1,
            })
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" }
                    }
                }
            }
        }
    end,
}