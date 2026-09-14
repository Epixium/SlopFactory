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
    config = { extra = { Xmult_gain = 0.1, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
            return {
                message = localize('k_upgrade_ex')
            }
        end
        if context.selling_card and context.card.ability.consumeable and card.ability.extra.Xmult > 1 and not context.blueprint then
            card.ability.extra.Xmult = 1
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
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