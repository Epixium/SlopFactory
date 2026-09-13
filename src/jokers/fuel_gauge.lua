SMODS.Joker {
    key = 'fuel_gauge',
    atlas = 'placeholders',
    pos = {
        x = 2,
        y = 0
    },
    rarity = 1,
    cost = 4,
    config = { extra = { mult = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = (G.GAME.current_round.hands_left + 1) * card.ability.extra.mult
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                card.joker_display_values.mult = (G.GAME.current_round.hands_left * card.ability.extra.mult) or 0
            end
        }
    end,
}