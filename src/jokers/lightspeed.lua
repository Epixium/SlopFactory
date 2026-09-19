SMODS.Joker {
    key = 'lightspeed',
    atlas = 'jokers',
    pos = {
        x = 2,
        y = 1
    },
    rarity = 2,
    cost = 6,
    attributes = { 'xmult', 'hands', 'discard' },
    config = { extra = { Xmult = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {
            card.ability.extra.Xmult
        } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.joker_main then
            if G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 then
                return {
                    xmult = card.ability.extra.Xmult
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
                        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
                    }
                }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active_text" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.is_active = G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0
                card.joker_display_values.active_text = localize("jdis_" ..
                    (card.joker_display_values.is_active and "active" or "inactive"))
                card.joker_display_values.Xmult = (card.joker_display_values.is_active and card.ability.extra.Xmult or 1)
            end,
            style_function = function(card, text, reminder_text, extra)
                if reminder_text and reminder_text.children and reminder_text.children[2] then
                    reminder_text.children[2].config.colour = card.joker_display_values.is_active and G.C.GREEN or
                        G.C.UI.TEXT_INACTIVE
                end
            end
        }
    end
}