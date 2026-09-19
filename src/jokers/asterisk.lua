local function get_scoring_cards(full_hand)
    local last_wild = nil
    for _, playing_card in ipairs(full_hand) do
        if SMODS.has_enhancement(playing_card, 'm_wild') then
            last_wild = playing_card
        end
    end

    if not last_wild then return nil end

    local other_cards = {}
    for _, playing_card in ipairs(full_hand) do
        if playing_card ~= last_wild then
            other_cards[#other_cards+1] = playing_card
        end
    end

    -- atp we just brute force it
    -- check every rank, evaluate every poker hand
    local best_hand = ''
    local best_hand_cards = {}
    local best_hand_poker_hands = {}
    for _, rank in pairs(SMODS.Ranks) do
        last_wild.force_id = rank.id
        last_wild.force_nominal = rank.nominal + (rank.face_nominal or 0)
        local custom_cards = {}
        for _, playing_card in ipairs(other_cards) do
            custom_cards[#custom_cards+1] = playing_card
        end
        custom_cards[#custom_cards+1] = last_wild

        local poker_hands = evaluate_poker_hand(custom_cards)
        local scoring_hand = {}
        local text = 'NULL'
        for _, v in ipairs(G.handlist) do
            if next(poker_hands[v]) then
                text = v
                scoring_hand = poker_hands[v][1]
                break
            end
        end
        for _, poker_hand in ipairs(G.handlist) do
            if poker_hand == best_hand then break end
            if poker_hand == text then
                best_hand = text
                best_hand_cards = scoring_hand
                best_hand_poker_hands = poker_hands
                break
            end
        end
    end
    last_wild.force_id = nil
    last_wild.force_nominal = nil

    return best_hand, best_hand_cards, best_hand_poker_hands
end

SMODS.Joker {
    key = 'asterisk',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 9,
        y = 2
    },
    rarity = 1,
    cost = 4,
    attributes = { 'enhancements', 'hand_type', 'passive' },
    config = { extra = { scoring_name = '', scoring_cards = {}, poker_hands = {}, last_order = {} } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
    end,
     calculate = function(self, card, context)
        if context.evaluate_poker_hand and context.full_hand then
            card.ability.extra.last_order = context.full_hand
            card.ability.extra.scoring_name,
            card.ability.extra.scoring_cards,
            card.ability.extra.poker_hands = get_scoring_cards(context.full_hand)
            
            if card.ability.extra.scoring_cards then
                return {
                    replace_scoring_name = card.ability.extra.scoring_name,
                    replace_poker_hands = card.ability.extra.poker_hands
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
    update = function(self, card, dt)
        if card.area.config.collection then return false end
        if card.ability.extra.scoring_name and card.ability.extra.last_order
            and #card.ability.extra.last_order == #G.hand.highlighted then
            local last_wilds = {}
            local highlighted_wilds = {}
            for i, playing_card in ipairs(card.ability.extra.last_order) do
                local highlighted_card = G.hand.highlighted[i]
                if SMODS.has_enhancement(playing_card, 'm_wild') then
                    last_wilds[#last_wilds+1] = playing_card
                end
                if SMODS.has_enhancement(highlighted_card, 'm_wild') then
                    highlighted_wilds[#highlighted_wilds+1] = highlighted_card
                end
            end
            for i, playing_card in ipairs(highlighted_wilds) do
                if last_wilds[i] ~= playing_card then
                    --print("wilds reorganized");
                    local rehighlighted = {}
                    for _, hand_card in ipairs(G.hand.cards) do
                        if hand_card.highlighted then
                            rehighlighted[#rehighlighted+1] = hand_card
                        end
                    end
                    G.hand.highlighted = rehighlighted
                    G.hand:parse_highlighted()
                    --update_hand_text_asterisk(card.ability.extra.scoring_name, card.ability.extra.scoring_cards, G.hand.highlighted)
                    break
                end
            end
        end
    end,
    in_pool = function(self, args)
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_wild') then
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