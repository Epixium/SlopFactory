SMODS.Joker {
    key = 'sad_joker',
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 2
    },
    rarity = 3,
    cost = 9,
    config = { extra = { score_cap = 2000 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.score_cap } }
    end,
    calculate = function(self, card, context)
        if context.after and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if SMODS.last_hand_score <= card.ability.extra.score_cap then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Planet',
                            key_append = 'slfa_sad_joker' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_planet'),
                }
            end
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
        }
    end
}