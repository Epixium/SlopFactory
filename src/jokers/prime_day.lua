SMODS.Joker {
    key = 'prime_day',
    atlas = 'placeholders',
    pos = {
        x = 3,
        y = 0
    },
    rarity = 2,
    cost = 6,
    config = { extra = { odds = 6 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'tag_standard', set = 'Tag' }
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'slfa_prime_day')
        return { vars = { numerator, denominator, localize { type = 'name_text', set = 'Tag', key = 'tag_standard' } } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local id = context.other_card:get_id()
            if (id == 2 or id == 3 or id == 5 or id == 8 or id == 14)
            and SMODS.pseudorandom_probability(card, 'slfa_prime_day', 1, card.ability.extra.odds) then
                return { extra = {
                    message = localize('k_plus_tag'),
                    message_card = card,
                    colour = G.C.GREEN,
                    func = function() -- This is for timing purposes, everything here runs after the message
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                add_tag({ key = 'tag_standard' })
                                play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                                play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                                return true
                            end)
                        }))
                    end
                }}
            end
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.ORANGE },
            reminder_text = {
                { text = "(2,3,5,7)" },
            },
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "odds" },
                    { text = ")" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            calc_function = function(card)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        local id = scoring_card:get_id()
                        if id == 2 or id == 3 or id == 5 or id == 7 then
                            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end
                end
                card.joker_display_values.count = count
                local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'slfa_prime_day')
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            end
        }
    end,
}