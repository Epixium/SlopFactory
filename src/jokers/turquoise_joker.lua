SMODS.Joker {
    key = 'turquoise_joker',
    perishable_compat = false,
    atlas = 'jokers',
    pos = {
        x = 1,
        y = 0
    },
    rarity = 1,
    cost = 4,
    attributes = { 'chips', 'hands', 'scaling' },
    config = { extra = { hand_add = 11, held_sub = 2, chips = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hand_add, card.ability.extra.held_sub, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local prev_chips = card.ability.extra.chips
            -- See note about SMODS Scaling Manipulation on the wiki
            card.ability.extra.chips = math.max(0, card.ability.extra.chips + card.ability.extra.hand_add - card.ability.extra.held_sub * #G.hand.cards)
            if card.ability.extra.chips > prev_chips then
                return {
                    message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips - prev_chips } }
                }
            elseif card.ability.extra.chips < prev_chips then
                return {
                    message = localize { type = 'variable', key = 'a_chips_minus', vars = { prev_chips - card.ability.extra.chips } },
                    colour = G.C.RED
                }
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
                { ref_table = "card.joker_display_values", ref_value = "additive" },
                { ref_table = "card.joker_display_values", ref_value = "chips" },
                { text = ")" }
            },
            calc_function = function(card)
                local playing_hand = next(G.play.cards)
                local count = 0
                for _, playing_card in ipairs(G.hand.cards) do
                if playing_hand or not playing_card.highlighted then
                        count = count + 1
                    end
                end
                local delta_chips = card.ability.extra.hand_add - card.ability.extra.held_sub * count
                card.joker_display_values.additive = delta_chips >= 0 and "+" or ""
                card.joker_display_values.chips = math.max(-card.ability.extra.chips, delta_chips)
            end,
            style_function = function(card, text, reminder_text, extra)
                if reminder_text and reminder_text.children and reminder_text.children[2] and reminder_text.children[3] then
                    local color = card.joker_display_values.chips >= 0 and G.C.CHIPS or G.C.RED
                    reminder_text.children[2].config.colour = color
                    reminder_text.children[3].config.colour = color
                end
            end
        }
    end,
}