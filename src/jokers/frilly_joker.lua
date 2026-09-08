SMODS.Joker {
    key = 'frilly_joker',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 3,
        y = 0
    },
    rarity = 1,
    cost = 4,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
    end,
    calculate = function(self, card, context)
        if context.check_enhancement then
            if context.other_card.config.center.key == 'm_bonus' then
                return {
                    m_mult = true
                }
            elseif context.other_card.config.center.key == 'm_mult' then
                return {
                    m_bonus = true
                }
            end
        end
    end,
    in_pool = function(self, args)
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_bonus') or SMODS.has_enhancement(playing_card, 'm_mult') then
                return true
            end
        end
        return false
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS, retrigger_type = "mult" },
                { text = " +", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT, retrigger_type = "mult" }
            },
            --[[reminder_text = {
                { ref_table = "card.joker_display_values", ref_value = "localized_text" }
            },]]
            calc_function = function(card)
                local chips, mult = 0, 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card.config.center.key == 'm_bonus' then
                            local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                            mult = mult + G.P_CENTERS['m_mult'].config.mult * retriggers
                        elseif scoring_card.config.center.key == 'm_mult' then
                            local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                            chips = chips + G.P_CENTERS['m_bonus'].config.bonus * retriggers
                        end
                    end
                end
                card.joker_display_values.chips = chips
                card.joker_display_values.mult = mult
                --[[card.joker_display_values.localized_text =
                    "(" .. localize{type="name_text", set="Enhanced", key="m_bonus"} .. " = "
                        .. localize{type="name_text", set="Enhanced", key="m_mult"} .. ")"]]
            end
        }
    end
}