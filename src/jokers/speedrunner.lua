SMODS.Joker {
    key = 'speedrunner',
    atlas = 'jokers',
    pos = {
        x = 4,
        y = 3
    },
    rarity = 3,
    cost = 8,
    attributes = { 'chips', 'skip' },
    config = { extra = { chips = 500 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and not context.blind.boss then
            SMODS.destroy_cards(card, nil, nil, true)
            return {
                message = localize('slfa_speedrunner_huevo')
            }
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
                { ref_table = "card.ability.extra", ref_value = "chips" },
            },
            text_config = { colour = G.C.CHIPS },
        }
    end
}