SMODS.Joker {
    key = 'strawberry',
    atlas = 'jokers',
    pos = {
        x = 9,
        y = 3
    },
    rarity = 1,
    cost = 4,
    attributes = { 'food', 'mult', 'suit', 'hearts', 'hand_level' },
    config = { extra = { cards_left = 4, mult = 1, suit = 'Hearts' } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cards_left, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and card.ability.extra.cards_left > 0 and
            context.other_card:is_suit(card.ability.extra.suit) then
            SMODS.upgrade_poker_hands({
                hands = context.scoring_name,
                parameters = {'mult'},
                func = function(base, hand, parameter, level_up)
                        return base + card.ability.extra.mult
                end,
                level_up = 0,
                from = card,
                speed = 8,
            })
            if not context.blueprint then
                card.ability.extra.cards_left = card.ability.extra.cards_left - 1
            end
        end
        if context.after and not context.blueprint and card.ability.extra.cards_left <= 0 then
            SMODS.destroy_cards(card, nil, nil, true)
            return {
                message = localize('k_eaten_ex'),
                colour = G.C.FILTER
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            reminder_text = {
                { text = "(" },
                {
                    ref_table = "card.joker_display_values",
                    ref_value = "localized_text",
                },
                { text = ")", colour = G.C.UI.TEXT_INACTIVE },
            },
            calc_function = function(card)
                if G.STATE ~= G.STATES.HAND_PLAYED then
                    local mult = 0
                    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                    if text ~= 'Unknown' then
                        for _, scoring_card in pairs(scoring_hand) do
                            if scoring_card:is_suit(card.ability.extra.suit) then
                                mult = mult +
                                    card.ability.extra.mult *
                                    JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                            end
                        end
                    end
                    mult = math.min(mult, card.ability.extra.cards_left * card.ability.extra.mult)
                    card.joker_display_values.mult = mult
                    card.joker_display_values.localized_text = localize(card.ability.extra.suit, 'suits_plural')
                end
            end,
            style_function = function(card, text, reminder_text, extra)
                local suit_node = reminder_text and reminder_text.children and reminder_text.children[2]
                if suit_node then suit_node.config.colour = lighten(G.C.SUITS[card.ability.extra.suit], 0.35) end
            end
        }
    end,
}