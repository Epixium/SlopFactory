SMODS.Joker {
    key = 'fuel_gauge',
    atlas = 'jokers',
    pos = {
        x = 8,
        y = 0
    },
    rarity = 2,
    cost = 6,
    attributes = { 'hands', 'mult' },
    config = { extra = { Xmult_base = 3, Xmult_loss = 0.5, Xmult = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_base, card.ability.extra.Xmult_loss, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            -- See note about SMODS Scaling Manipulation on the wiki
            local old_Xmult = card.ability.extra.Xmult
            card.ability.extra.Xmult = math.max(card.ability.extra.Xmult - card.ability.extra.Xmult_loss, 0)
            if card.ability.extra.Xmult ~= old_Xmult then
                return {
                    message = localize { type = 'variable', key = 'a_xmult_minus', vars = { card.ability.extra.Xmult_loss } },
                    colour = G.C.MULT
                }
            end
        end
        if context.selling_card and context.card.ability.set == 'Joker' and card.ability.extra.Xmult < card.ability.extra.Xmult_base and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult_base
            return {
                message = localize('slfa_fuel_gauge_refuel'),
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