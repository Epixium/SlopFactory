SMODS.Joker {
    key = 'fuel_gauge',
    atlas = 'jokers',
    pos = {
        x = 8,
        y = 0
    },
    rarity = 2,
    cost = 6,
    attributes = { 'hands', 'xmult' },
    config = { extra = { Xmult_base = 3, Xmult_loss = 0.5, Xmult = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_base, card.ability.extra.Xmult_loss, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            -- See note about SMODS Scaling Manipulation on the wiki
            local old_Xmult = card.ability.extra.Xmult
            local delta_Xmult = math.max(card.ability.extra.Xmult - card.ability.extra.Xmult_loss, 0) -card.ability.extra.Xmult
            if delta_Xmult ~= 0 then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = 'Xmult',
                    scalar_value = 'Xmult_loss',
                    operation = '-',
                    scaling_message = {
                        message = localize { type = 'variable', key = 'a_xmult_minus', vars = { card.ability.extra.Xmult_loss } },
                        colour = G.C.RED
                    }
                })
            end
        end
        if context.selling_card and context.card.ability.set == 'Joker' and card.ability.extra.Xmult < card.ability.extra.Xmult_base and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult_base
            SMODS.reset_card(card, {
                ref_table = card.ability.extra,
                ref_value = 'Xmult',
                reset_value = card.ability.extra.Xmult_base,
                message_key = 'slfa_fuel_gauge_refuel'
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