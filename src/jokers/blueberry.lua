SMODS.Joker {
    key = 'blueberry',
    atlas = 'jokers',
    pos = {
        x = 1,
        y = 4
    },
    rarity = 1,
    cost = 4,
    attributes = { 'food', 'retrigger', 'suit', 'clubs' },
    config = { extra = { cards_left = 16, repetitions = 1, suit = 'Clubs' } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cards_left, card.ability.extra.repetitions } }
    end,
    calculate = function(self, card, context)
        if context.repetition and card.ability.extra.cards_left > 0 and
            context.other_card:is_suit(card.ability.extra.suit) and
            context.cardarea == G.hand then
            for _, effect in ipairs(context.card_effects) do
                for _, subeffect in pairs(effect) do
                    if next(subeffect) or #subeffect > 0 then
                        card.ability.extra.cards_left = card.ability.extra.cards_left - 1
                        return {
                            repetitions = card.ability.extra.repetitions
                        }
                    end
                end
            end
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
                -- i'd love to implement this accurately, but afaik jokerdisplay cannot check if a held card has effects
                if not held_in_hand then return 0 end
                if playing_card:is_suit(joker_card.ability.extra.suit) then
                    return joker_card.ability.extra.repetitions * JokerDisplay.calculate_joker_triggers(joker_card)
                end
                return 0
            end
        }
    end,
}