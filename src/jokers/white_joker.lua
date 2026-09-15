SMODS.Joker {
    key = 'white_joker',
    atlas = 'placeholders',
    pos = {
        x = 4,
        y = 0
    },
    rarity = 3,
    cost = 8,
    config = { extra = { Xmult_per = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_per, localize('Hearts', 'suits_plural'), localize('Diamonds', 'suits_plural') } }
    end,
    calculate = function(self, card, context)
        if (context.before or (context.pre_discard and not context.hook)) and not context.blueprint then
            local debuffed_any = false
            for _, held_card in ipairs(G.hand.cards) do
                -- i don't like doing it this way but uh
                local is_discard = false
                if context.pre_discard then
                    for _, hand_card in ipairs(context.full_hand) do
                        if held_card == hand_card then
                            is_discard = true
                            break
                        end
                    end
                end
                if not is_discard then
                    if held_card:is_suit('Hearts') or held_card:is_suit('Diamonds') then
                        held_card.ability.tag_slfa_white_joker = true
                        debuffed_any = true
                    end
                end
            end
            SlopFactory.update_debuffed()
            if debuffed_any then
                return {
                    message = localize('k_debuffed_ex'),
                    colour = G.C.RED
                }
            end
        end
        if context.joker_main then
            local count = 0
            for _, playing_card in ipairs(context.scoring_hand) do
                if playing_card:is_suit('Hearts') or playing_card:is_suit('Diamonds') then
                    count = count + 1
                end
            end
            return {
                xmult = 1 + card.ability.extra.Xmult_per * count
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
                    }
                }
            },
            calc_function = function(card)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in ipairs(scoring_hand) do
                        if scoring_card:is_suit('Hearts') or scoring_card:is_suit('Diamonds') then
                            count = count + 1
                        end
                    end
                end
                card.joker_display_values.Xmult = 1 + card.ability.extra.Xmult_per * count
            end
        }
    end,
}

local debuff_card_ref = Blind.debuff_card
function Blind.debuff_card(self, card, from_blind)
    local ret = debuff_card_ref(self, card, from_blind)
    if next(SMODS.find_card('j_slfa_white_joker')) then
        if card.playing_card and card.ability.tag_slfa_white_joker then
            card:set_debuff(true)
            if card.debuff then card.debuffed_by_blind = true end
        end
    end

    return ret
end

SlopFactory.resetters[#SlopFactory.resetters+1] = function(run_start)
    for _, playing_card in ipairs(G.playing_cards or {}) do
        playing_card.ability.tag_slfa_white_joker = nil
    end
end