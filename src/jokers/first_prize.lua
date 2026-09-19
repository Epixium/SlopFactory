SMODS.Joker {
    key = 'first_prize',
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 3
    },
    rarity = 2,
    cost = 6,
    attributes = { 'rank', 'retrigger' },
    config = { extra = { repetitions = 2, rank = nil, id = nil } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions, card.ability.extra.rank and localize(card.ability.extra.rank, 'ranks') or localize('k_none') } }
    end,
    calculate = function(self, card, context)
        if not context.blueprint then
            if context.hand_drawn and not card.ability.extra.rank then
                card.ability.extra.rank = context.hand_drawn[1].base.value
                card.ability.extra.id = context.hand_drawn[1].base.id
                return {
                    message = localize(card.ability.extra.rank, 'ranks')
                }
            end
            if context.end_of_round then
                card.ability.extra.rank = nil
                card.ability.extra.id = nil
            end
        end
        if context.repetition then
            if card.ability.extra.rank and context.other_card:get_id() == card.ability.extra.id then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "rank_text" },
                { text = ")" }
            },
            calc_function = function(card)
                card.joker_display_values.rank_text = 
                    card.ability.extra.rank and localize(card.ability.extra.rank, 'ranks')
                    or localize('k_none')
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand then return 0 end
                return (joker_card.ability.extra.rank and joker_card.ability.extra.id == playing_card:get_id())
                    and joker_card.ability.extra.repetitions * JokerDisplay.calculate_joker_triggers(joker_card)
                    or 0
            end
        }
    end,
}