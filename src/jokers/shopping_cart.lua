SMODS.Joker {
    key = 'shopping_cart',
    perishable_compat = false,
    atlas = 'jokers',
    pos = {
        x = 1,
        y = 1
    },
    rarity = 1,
    cost = 5,
    attributes = { 'mult', 'shop', 'scaling' },
    config = { extra = { mult = 0, is_active = true } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if not context.blueprint then
            if context.starting_shop then
                card.ability.extra.is_active = true
                local eval = function() return card.ability.extra.is_active and not G.RESET_JIGGLES end
                juice_card_until(card, eval, true)
            end
            if context.ending_shop then
                card.ability.extra.is_active = false
            end
            if context.money_altered and context.amount < 0 and card.ability.extra.is_active then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    operation = function(ref_table, ref_value, initial, change)
                        ref_table[ref_value] = initial + -context.amount * change
                    end,
                })
                card.ability.extra.is_active = false
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.MULT },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active_text" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.active_text = localize("jdis_" ..
                    (card.ability.extra.is_active and "active" or "inactive"))
            end,
            style_function = function(card, text, reminder_text, extra)
                if reminder_text and reminder_text.children and reminder_text.children[2] then
                    reminder_text.children[2].config.colour = card.ability.extra.is_active and G.C.GREEN or
                        G.C.UI.TEXT_INACTIVE
                end
            end
        }
    end,
}