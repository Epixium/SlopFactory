SMODS.Joker {
    key = 'museum',
    perishable_compat = false,
    atlas = 'jokers',
    pos = {
        x = 3,
        y = 5
    },
    rarity = 2,
    cost = 6,
    attributes = { 'chips', 'enhancements', 'scaling' },
    config = { extra = { chips = 0, chips_gain = 10 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips_gain, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if not context.blueprint then
            if context.setting_ability then
                print(context.other_card.ability.set)
                print(context.old .. ", " .. context.new)
            end
            if context.setting_ability and context.other_card.ability.set == "Enhanced" and context.old == "c_base" then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "chips",
                    scalar_value = "chips_gain"
                })
                return nil, true -- jokah retriggah
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