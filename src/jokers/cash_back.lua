SMODS.Joker {
    key = 'cash_back',
    perishable_compat = false,
    atlas = 'jokers',
    pos = {
        x = 7,
        y = 4
    },
    rarity = 1,
    cost = 5,
    attributes = { 'chips', 'shop', 'scaling' },
    config = { extra = { chips_gain = 4, dollars = 25, chips = 0, } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips_gain, card.ability.extra.dollars, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if not context.blueprint then
            if context.money_altered and context.from_shop and context.amount < 0 and context.initial < card.ability.extra.dollars then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "chips",
                    scalar_value = "chips_gain"
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
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active_text" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.active = to_big(G.GAME.dollars) < to_big(card.ability.extra.dollars)
                card.joker_display_values.active_text = localize("jdis_" ..
                    (card.joker_display_values.active and "active" or "inactive"))
            end,
            style_function = function(card, text, reminder_text, extra)
                if reminder_text and reminder_text.children and reminder_text.children[2] then
                    reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or
                        G.C.UI.TEXT_INACTIVE
                end
            end
        }
    end,
}