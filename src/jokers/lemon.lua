SMODS.Joker {
    key = 'lemon',
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 4
    },
    rarity = 1,
    cost = 4,
    attributes = { 'food', 'retrigger', 'suit', 'diamonds' },
    config = { extra = { cards_left = 8, repetitions = 2, suit = 'Diamonds' } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cards_left, card.ability.extra.repetitions } }
    end,
    calculate = function(self, card, context)
        if context.repetition and card.ability.extra.cards_left > 0 and
            context.other_card:is_suit(card.ability.extra.suit) and context.cardarea == G.play then
            card.ability.extra.cards_left = card.ability.extra.cards_left - 1
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
        if (context.after or (context.end_of_round and context.main_eval) or context.round_eval) and card.ability.extra.cards_left <= 0 then
            SMODS.destroy_cards(card, nil, nil, true)
            return {
                message = localize('k_eaten_ex'),
                colour = G.C.FILTER
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                {
                    ref_table = "card.joker_display_values",
                    ref_value = "localized_text",
                },
                { text = ")", colour = G.C.UI.TEXT_INACTIVE },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text = localize(card.ability.extra.suit, 'suits_plural')
            end,
            style_function = function(card, text, reminder_text, extra)
                local suit_node = reminder_text and reminder_text.children and reminder_text.children[2]
                if suit_node then suit_node.config.colour = lighten(G.C.SUITS[card.ability.extra.suit], 0.35) end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand then return 0 end
                local counted_cards = 0
                for _, scoring_card in ipairs(scoring_hand or {}) do
                    if scoring_card:is_suit(joker_card.ability.extra.suit) then
                        if playing_card == scoring_card then
                            return joker_card.ability.extra.repetitions * JokerDisplay.calculate_joker_triggers(joker_card)
                        end
                        counted_cards = counted_cards + 1
                        if counted_cards > joker_card.ability.extra.cards_left then
                            return 0
                        end
                    end
                end
                return 0
            end
        }
    end,
}