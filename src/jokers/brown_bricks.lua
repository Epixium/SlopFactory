local function get_scoring_cards(full_hand)
    -- compile cards
    local ranks = {}
    for _, playing_card in ipairs(full_hand) do
        if not SMODS.has_enhancement(playing_card, 'm_stone') then
            if SMODS.has_no_rank(playing_card) then return end -- has to have a rank if it's not stone
            ranks[playing_card:get_id()] = true
        end
    end
    local rank_count = 0
    for _, _ in pairs(ranks) do rank_count = rank_count + 1 end
    -- return false if hand is not a full house
    if rank_count ~= 2 then return nil end

    local scoring_cards = {}
    for _, playing_card in ipairs(full_hand) do
        if SMODS.has_enhancement(playing_card, 'm_stone')
            or ranks[playing_card:get_id()] then
            scoring_cards[#scoring_cards+1] = playing_card
        end
    end

    return scoring_cards
end

SMODS.Joker {
    key = 'brown_bricks',
    blueprint_compat = false,
    atlas = 'placeholders',
    pos = {
        x = 3,
        y = 0
    },
    rarity = 2,
    cost = 6,
    config = { extra = { scoring_cards = {} } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
    end,
    calculate = function(self, card, context)
        if context.evaluate_poker_hand and context.full_hand and #context.full_hand == 5 then
            card.ability.extra.scoring_cards = get_scoring_cards(context.full_hand)
            if card.ability.extra.scoring_cards then
                local poker_hands = context.poker_hands
                poker_hands['Full House'] = {card.ability.extra.scoring_cards}
                return {
                    replace_scoring_name = next(context.poker_hands['Flush']) and 'Flush House' or 'Full House',
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