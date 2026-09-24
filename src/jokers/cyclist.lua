SMODS.Joker {
    key = 'cyclist',
    perishable_compat = false,
    atlas = 'jokers',
    pos = {
        x = 7,
        y = 0
    },
    rarity = 1,
    cost = 4,
    attributes = { 'chips', 'hand_type', 'scaling', 'reset' },
    config = { extra = { chips_gain = 52, chips = 0, last_hand = 'slfa_none', last_hand_disp = 'slfa_none' } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips_gain, card.ability.extra.chips, localize(card.ability.extra.last_hand_disp, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for _,poker_hand in ipairs(G.handlist) do
                if (card.ability.extra.last_hand == poker_hand) then
                    SMODS.reset_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = 'chips',
                        reset_value = 0,
                    })
                    card.ability.extra.last_hand_disp = 'slfa_none'
                elseif (context.scoring_name == poker_hand) then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = 'chips',
                        scalar_value = 'scaling'
                    })
                    card.ability.extra.last_hand_disp = context.scoring_name
                    return
                end
            end
        end
        if context.after and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    card.ability.extra.last_hand = card.ability.extra.last_hand_disp
                    return true
                end)
            }))
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.CHIPS },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "last_hand", colour = G.C.ORANGE },
                { text = ")" }
            },
            calc_function = function(card)
                local scoring_name, _, _ = JokerDisplay.evaluate_hand()
                if scoring_name and scoring_name ~= 'Unknown'
                    and card.ability.extra.last_hand == card.ability.extra.last_hand_disp then
                    for _,poker_hand in ipairs(G.handlist) do
                        if (card.ability.extra.last_hand == poker_hand) then
                            card.joker_display_values.chips = 0
                            break
                        elseif (scoring_name == poker_hand) then
                            card.joker_display_values.chips = card.ability.extra.chips + card.ability.extra.chips_gain
                            break
                        end
                    end
                else
                    card.joker_display_values.chips = card.ability.extra.chips
                end
                card.joker_display_values.last_hand = localize(card.ability.extra.last_hand_disp, 'poker_hands')
            end,
        }
    end,
}