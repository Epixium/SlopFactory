SMODS.Joker {
    key = 'picky_joker',
    atlas = 'jokers',
    pos = {
        x = 4,
        y = 0
    },
    rarity = 1,
    cost = 5,
    attributes = { 'mult', 'chance', 'enhancements', 'discard' },
    config = { extra = { mult = 11, odds = 2 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'slfa_picky_joker')
        return { vars = { card.ability.extra.mult, numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.press_play and G.hand.cards and #G.hand.cards > 0 then
            if SMODS.pseudorandom_probability(card, 'slfa_picky_joker', 1, card.ability.extra.odds) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local old_limit = G.hand.config.highlighted_limit
                        G.hand.config.highlighted_limit = 1e10
                        local any_selected = nil
                        for _, playing_card in ipairs(G.hand.cards) do
                            if not next(SMODS.get_enhancements(playing_card)) then
                                G.hand:add_to_highlighted(playing_card, true)
                                any_selected = true
                            end
                        end
                        if any_selected then
                            play_sound('card1', 1)
                            G.FUNCS.discard_cards_from_highlighted(nil, true)
                        end
                        G.hand.config.highlighted_limit = old_limit
                        return true
                    end
                }))
                delay(0.7)
                return {
                    message = localize('k_discarded_ex'),
                    colour = G.C.RED,
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.MULT },
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "odds" },
                    { text = ")" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            calc_function = function(card)
                local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'slfa_picky_joker')
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            end
        }
    end,
}