SMODS.Joker {
    key = 'defibrillator',
    atlas = 'jokers',
    pos = {
        x = 2,
        y = 3
    },
    rarity = 2,
    cost = 6,
    attributes = { 'hands', 'modify_card', 'position', 'retrigger' },
    config = { extra = { repetitions = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,
    calculate = function(self, card, context)
        if context.evaluate_poker_hand and not context.blueprint and context.full_hand and #context.full_hand == 2 then
            local poker_hands = context.poker_hands
            poker_hands['Pair'] = {{context.full_hand[1], context.full_hand[2]}}
            return {
                replace_scoring_name = G.GAME.hands[context.scoring_name].order > G.GAME.hands['Pair'].order
                    and 'Pair' or nil,
                replace_poker_hands = poker_hands
            }
        end
        if context.modify_scoring_hand and not context.blueprint and #context.full_hand == 2 then
            for _, playing_card in ipairs(context.full_hand) do
                if context.other_card == playing_card then
                    return { add_to_hand = true }
                end
            end
        end
        if context.before and not context.blueprint and G.GAME.current_round.hands_left == 0 and #context.full_hand == 2 then
            SMODS.copy_card(context.full_hand[2], { new_card = context.full_hand[1] })
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.full_hand[1]:juice_up()
                    context.full_hand[2]:juice_up()
                    return true
                end
            }))
            return {
                message = localize('k_copied_ex'),
                colour = G.C.PURPLE
            }
        end
        if context.repetition then
            if G.GAME.current_round.hands_left == 0 and context.full_hand and #context.full_hand == 2 then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand or G.GAME.current_round.hands_left > 0 or not next(G.play.c) or #G.play.cards ~= 2 then return 0 end
                return joker_card.ability.extra.repetitions * JokerDisplay.calculate_joker_triggers(joker_card)
            end
        }
    end
}