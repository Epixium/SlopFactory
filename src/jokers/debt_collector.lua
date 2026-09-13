-- this code is mostly stolen from the Da Capo card in the Paperback mod

local function reset_slfa_debt_collector_suit()
    if G.GAME.slop_factory.debt_collector_done then return end
    G.GAME.slop_factory.debt_collector_suit = { suit = 'Spades' }
    G.GAME.slop_factory.debt_collector_done = true
    local valid_debt_collector_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(playing_card) then
            valid_debt_collector_cards[#valid_debt_collector_cards + 1] = playing_card
        end
    end
    local debt_collector_card = pseudorandom_element(valid_debt_collector_cards,
        'slfa_debt_collector' .. G.GAME.round_resets.ante)
    if debt_collector_card then
        G.GAME.slop_factory.debt_collector_suit = debt_collector_card.base.suit
    end
end

SMODS.Joker {
    key = 'debt_collector',
    atlas = 'placeholders',
    pos = {
        x = 3,
        y = 0
    },
    rarity = 2,
    cost = 7,
    config = { extra = { dollars = 2 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Other', key = 'debuffed_playing_card'}
        local suit = G.GAME.slop_factory and G.GAME.slop_factory.debt_collector_suit or 'Spades'
        return { vars = { card.ability.extra.dollars, localize(suit, 'suits_singular'), colours = { G.C.SUITS[suit] } } }
    end,
    add_to_deck = function(self, card, from_debuff)
        for k, v in ipairs(G.playing_cards) do
            G.GAME.blind:debuff_card(v)
        end
        return {
            vars = {
                card.ability.extra.xmult,
                localize(G.GAME.slop_factory.debt_collector_suit, 'suits_plural'),
                colours = { G.C.SUITS[G.GAME.slop_factory.debt_collector_suit] }
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            for _, other_card in pairs(context.full_hand) do
                if other_card.debuff then
                    count = count + 1
                end
            end
            if count == 0 then return false end
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars * count
            return {
                dollars = card.ability.extra.dollars * count,
                func = function() -- This is for timing purposes, this goes after the dollar modification
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
        end

        if context.before and not context.blueprint then G.GAME.slop_factory.debt_collector_done = false end
        if context.after and not context.blueprint then
            reset_slfa_debt_collector_suit()
            G.E_MANAGER:add_event(Event {
                func = function()
                -- Update the debuff of all playing cards when swapping suits
                for k, v in ipairs(G.playing_cards) do
                    G.GAME.blind:debuff_card(v)
                end

                return true
                end
            })
            return {
                message = localize(G.GAME.slop_factory.debt_collector_suit, 'suits_plural'),
                colour = G.C.SUITS[G.GAME.slop_factory.debt_collector_suit]
            }
        end
        if context.setting_blind then
            G.E_MANAGER:add_event(Event {
                func = function()
                -- Update the debuff of all playing cards when swapping suits
                for k, v in ipairs(G.playing_cards) do
                    G.GAME.blind:debuff_card(v)
                end

                return true
                end
            })
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+$" },
                { ref_table = "card.joker_display_values", ref_value = "dollars" },
            },
            text_config = { colour = G.C.GOLD },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "debt_collector_suit" },
                { text = ")" }
            },
            calc_function = function(card)
                local count = 0
                local text, _, _ = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, other_card in pairs(JokerDisplay.current_hand) do
                        if other_card.debuff then
                            count = count + 1
                        end
                    end
                end
                card.joker_display_values.dollars = count * card.ability.extra.dollars
                card.joker_display_values.debt_collector_suit = localize(G.GAME.slop_factory and G.GAME.slop_factory.debt_collector_suit or 'Spades', 'suits_plural')
            end,
            style_function = function(card, text, reminder_text, extra)
                if reminder_text and reminder_text.children[2] then
                    reminder_text.children[2].config.colour = lighten(G.C.SUITS[G.GAME.slop_factory.debt_collector_suit or 'Spades'], 0.35)
                end
            end
        }
    end
}


local debuff_card_ref = Blind.debuff_card
function Blind.debuff_card(self, card, from_blind)
    local ret = debuff_card_ref(self, card, from_blind)
    if card.area ~= G.jokers then
        if G.GAME.slop_factory.debt_collector_suit == 'None' then
            return ret
        end
        for k, v in ipairs(SMODS.find_card('j_slfa_debt_collector')) do
            if card.playing_card and card:is_suit(G.GAME.slop_factory.debt_collector_suit, true) then
                card:set_debuff(true)
                if card.debuff then card.debuffed_by_blind = true end
            end
        end
    end

    return ret
end

-- This changes variables globally each round
SlopFactory.resetters[#SlopFactory.resetters+1] = function(run_start)
    if run_start then
        reset_slfa_debt_collector_suit()
    end
end