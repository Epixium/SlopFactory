SMODS.Joker {
    key = 'blitzkrieg',
    atlas = 'jokers',
    pos = {
        x = 9,
        y = 0
    },
    rarity = 1,
    cost = 4,
    attributes = { 'xmult' },
    config = { extra = { Xmult = 2, is_active = true } },
    loc_vars = function(self, info_queue, card)
        return { vars = {
            card.ability.extra.Xmult,
            localize(card.ability.extra.is_active and 'slfa_blitzkrieg_active' or 'slfa_blitzkrieg_inactive')
        } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            if card.ability.extra.is_active then
                local eval = function(card) return card.ability.extra.is_active and not G.RESET_JIGGLES end
                juice_card_until(card, eval, true)
            end
        end
        if context.joker_main and card.ability.extra.is_active then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
        if context.end_of_round and not context.blueprint then
            card.ability.extra.is_active = G.GAME.current_round.hands_played == 1
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
                card.joker_display_values.active_text = localize("jdis_" ..
                    (card.ability.extra.is_active and "active" or "inactive"))
                card.joker_display_values.Xmult = (card.ability.extra.is_active and card.ability.extra.Xmult or 1)
            end,
            style_function = function(card, text, reminder_text, extra)
                if reminder_text and reminder_text.children and reminder_text.children[2] then
                    reminder_text.children[2].config.colour = card.ability.extra.is_active and G.C.GREEN or
                        G.C.UI.TEXT_INACTIVE
                end
            end
        }
    end
}