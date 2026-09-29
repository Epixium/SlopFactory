SMODS.Joker {
    key = 'cheat_sheet',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 3,
        y = 4
    },
    rarity = 2,
    cost = 6,
    attributes = { 'hand_type', 'passive' },
    calculate = function(self, card, context)
        if context.evaluate_poker_hand and next(context.poker_hands["Straight"]) and not next(context.poker_hands["Flush"]) then
            local ace_check = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 14 then
                    ace_check = true
                    break
                end
            end
            if ace_check then
                local poker_hands = context.poker_hands
                local best_hand = context.scoring_name
                --print(poker_hands)
                poker_hands['Flush'] = { context.scoring_hand }
                poker_hands['Straight Flush'] = { context.scoring_hand }
                best_hand =  G.GAME.hands['Straight Flush'].order < G.GAME.hands[best_hand].order and 'Straight Flush' or best_hand
                
                local replace_name = nil
                if best_hand == 'Straight Flush' then
                    local royal = true
                    for i = 1, #context.scoring_hand do
                        if context.scoring_hand[i]:get_id() < 10 then
                            royal = false
                            break
                        end
                    end
                    if royal then replace_name = 'Royal Flush' end
                end
                
                return {
                    replace_scoring_name = best_hand ~= context.scoring_name and best_hand or nil,
                    replace_poker_hands = poker_hands,
                    replace_display_name = replace_name
                }
            end
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
        }
    end
}