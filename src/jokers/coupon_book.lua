SMODS.Joker {
    key = 'coupon_book',
    atlas = 'jokers',
    pos = {
        x = 2,
        y = 0
    },
    rarity = 1,
    cost = 6,
    config = { extra = { dollars = 3 } },
    loc_vars = function(self, info_queue, card)
        local count = 0
        for _ in pairs(G.GAME.used_vouchers) do count = count + 1 end
        return { vars = { card.ability.extra.dollars, card.ability.extra.dollars * count } }
    end,
    calc_dollar_bonus = function(self, card)
        local count = 0
        for _ in pairs(G.GAME.used_vouchers) do count = count + 1 end
        return card.ability.extra.dollars * count
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
                local count = 0
                for _ in pairs(G.GAME.used_vouchers) do count = count + 1 end
                card.joker_display_values.dollars = count * card.ability.extra.dollars
                card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
            end
        }
    end
}