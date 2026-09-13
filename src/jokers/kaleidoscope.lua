SMODS.Joker {
    key = 'kaleidoscope',
    atlas = 'jokers',
    pos = {
        x = 6,
        y = 0
    },
    rarity = 2,
    cost = 6,
    config = { extra = { repetitions = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.scoring_hand then
            local rank = context.other_card:get_id()
            for _, playing_card in ipairs(context.scoring_hand) do
                if playing_card == context.other_card then break end
                if  (rank == playing_card:get_id())
                and (context.other_card:is_suit(playing_card.base.suit) or playing_card:is_suit(context.other_card.base.suit))
                then
                    return {
                        repetitions = card.ability.extra.repetitions
                    }
                end
            end
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { text = localize("k_rank") },
                { text = " & " },
                { text = localize("k_suit") },
                { text = ")" }
            },
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand or not JokerDisplay.in_scoring(playing_card, scoring_hand) then return 0 end
                local rank = playing_card:get_id()
                for _, scoring_card in ipairs(scoring_hand) do
                    if scoring_card == playing_card then break end
                    if  (rank == scoring_card:get_id())
                    and (playing_card:is_suit(scoring_card.base.suit) or scoring_card:is_suit(playing_card.base.suit))
                    then
                        return joker_card.ability.extra.repetitions * JokerDisplay.calculate_joker_triggers(joker_card)
                    end
                end
                return 0
            end
        }
    end,
}