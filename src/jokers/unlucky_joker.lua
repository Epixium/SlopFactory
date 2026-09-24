SMODS.Joker {
    key = 'unlucky_joker',
    perishable_compat = false,
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 1
    },
    rarity = 2,
    cost = 6,
    attributes = { 'chips', 'chance', 'scaling' },
    config = { extra = { chips_gain = 4, chips_loss = 13, chips = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips_gain, card.ability.extra.chips_loss, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.pseudorandom_result and not context.blueprint then
            if context.result then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = 'chips',
                    scalar_value = 'chips_loss',
                    operation = function(ref_table, ref_value, initial, change)
                        ref_table[ref_value] = math.max(initial - change, 0)
                    end,
                    scaling_message = {
                        message = localize('k_downgrade_ex'),
                        colour = G.C.RED
                    }
                })
            else
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = 'chips',
                    scalar_value = 'chips_gain',
                })
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.CHIPS },
        }
    end,
}