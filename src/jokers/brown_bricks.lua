local function get_scoring_cards(full_hand, poker_hands)
    -- compile cards
    local ranks = {}
    local stones = 0
    for _, playing_card in ipairs(full_hand) do
        if not SMODS.has_enhancement(playing_card, 'm_stone') then
            if SMODS.has_no_rank(playing_card) then return end -- has to have a rank if it's not stone
            ranks[playing_card:get_id()] = true
        else
            stones = stones + 1
        end
    end

    if stones == 0 then return nil end

    local rank_count = 0
    for _, _ in pairs(ranks) do rank_count = rank_count + 1 end

    -- forced stuff

    if next(poker_hands['Two Pair']) and stones >= 1
    or next(poker_hands['Three of a Kind']) and rank_count >= 2 and stones >= 1
    or next(poker_hands['Pair']) and rank_count >= 2 and stones >= 2
    or next(poker_hands['High Card']) and rank_count == 2 and stones >= 3
    then
        return full_hand
    end
    
    -- return false if hand is not a full house
    if rank_count ~= 2 then return end

    local scoring_cards = {}
    for _, playing_card in ipairs(full_hand) do
        if SMODS.has_enhancement(playing_card, 'm_stone')
            or ranks[playing_card:get_id()] then
            scoring_cards[#scoring_cards+1] = playing_card
        end
    end

    return scoring_cards
end

local function get_extra_poker_hands(scoring_full_house, poker_hands)
    -- the most barebones structure you can have is 2 different ranks and a bunch of stones
    -- so the total hands to account for are 3oak, 2pair and pair (should always have a hc)
    local ranks = {}
    local stones = {}
    for _, playing_card in ipairs(scoring_full_house) do
        if not SMODS.has_enhancement(playing_card, 'm_stone') then
            local id = playing_card:get_id()
            if ranks[id] then ranks[id][#ranks[id]+1] = playing_card
            else ranks[id] = {playing_card} end
        else
            stones[#stones+1] = playing_card
        end
    end

    local best_rank = -99999
    local not_best_rank = -99999
    for rank, _ in pairs(ranks) do
        not_best_rank = math.max(not_best_rank, best_rank)
        best_rank = math.max(best_rank, rank)
    end
    if not next(poker_hands['Pair']) then -- no pair, no two pair, no threeoak
        poker_hands['Pair'] = {{ranks[best_rank][1], stones[1]}}
        poker_hands['Two Pair'] = {{ranks[best_rank][1], stones[1], ranks[not_best_rank][1], stones[2]}}
        poker_hands['Three of a Kind'] = {{ranks[best_rank][1], stones[1], stones[3]}}
    else
        if not next(poker_hands['Two Pair']) then
            local big_rank = #ranks[best_rank] > #ranks[not_best_rank] and best_rank or not_best_rank
            local small_rank = #ranks[best_rank] > #ranks[not_best_rank] and not_best_rank or best_rank
            poker_hands['Two Pair'] = {{ranks[big_rank][1], ranks[big_rank][2], ranks[small_rank][1], stones[1]}}
        end
        if not next(poker_hands['Three of a Kind']) then
            poker_hands['Three of a Kind'] = {{ranks[best_rank][1], ranks[best_rank][2], stones[1]}}
        end
    end

    return poker_hands
end

SMODS.Joker {
    key = 'brown_bricks',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 4,
        y = 2
    },
    soul_pos = {
        x = 5,
        y = 2
    },
    rarity = 2,
    cost = 6,
    attributes = { 'enhancements', 'hand_type', 'passive' },
    config = { extra = { scoring_cards = {} } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
    end,
    calculate = function(self, card, context)
        if context.evaluate_poker_hand and context.full_hand and #context.full_hand == 5 then
            card.ability.extra.scoring_cards =
                get_scoring_cards(context.full_hand, context.poker_hands)
            if card.ability.extra.scoring_cards then
                local poker_hands = context.poker_hands
                local best_hand = context.scoring_name
                --print(poker_hands)
                poker_hands['Full House'] = {card.ability.extra.scoring_cards}
                
                poker_hands = get_extra_poker_hands(card.ability.extra.scoring_cards, poker_hands)
                
                best_hand =  G.GAME.hands['Full House'].order < G.GAME.hands[best_hand].order and 'Full House' or best_hand
                if next(context.poker_hands['Flush']) then
                    poker_hands['Flush House'] = {card.ability.extra.scoring_cards}
                    best_hand = G.GAME.hands['Flush House'].order <  G.GAME.hands[best_hand].order and 'Flush House' or best_hand
                end
                return {
                    replace_scoring_name = best_hand ~= context.scoring_name and best_hand or nil,
                    replace_poker_hands = poker_hands
                }
            end
        end
        if context.modify_scoring_hand and card.ability.extra.scoring_cards then
            for _, playing_card in ipairs(card.ability.extra.scoring_cards) do
                if context.other_card == playing_card then
                    return { add_to_hand = true }
                end
            end
        end
    end,
    in_pool = function(self, args)
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_stone') then
                return true
            end
        end
        return false
    end,
    joker_display_def = function(JokerDisplay)
        return {
        }
    end
}