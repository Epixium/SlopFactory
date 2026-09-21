SMODS.Joker {
    key = 'cuisiner',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 3,
        y = 1
    },
    rarity = 2,
    cost = 7,
    attributes = { 'discard', 'economy', 'hand_size' },
    config = { extra = { h_size = 2, dollars = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.h_size } }
    end,
    calc_dollar_bonus = function(self, card)
        return G.GAME.current_round.discards_left > 0 and G.GAME.current_round.discards_left * card.ability.extra.dollars or nil
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.h_size)
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+$" },
                { ref_table = "card.joker_display_values", ref_value = "dollars" },
            },
            text_config = { colour = G.C.GOLD },
            reminder_text = {
                { ref_table = "card.joker_display_values", ref_value = "localized_text" }
            },
            calc_function = function(card)
                card.joker_display_values.dollars = (G.GAME.current_round.discards_left > 0 and G.GAME.current_round.discards_left * card.ability.extra.dollars or 0)
                card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
            end
        }
    end
}