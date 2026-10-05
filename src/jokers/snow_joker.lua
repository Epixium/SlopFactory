SMODS.Atlas {
    key = 'splash',
    path = 'splash.png',
    px = 71,
    py = 95,
}

SMODS.Joker {
    key = 'snow_joker',
    perishable_compat = false,
    atlas = 'jokers',
    pos = {
        x = 4,
        y = 5
    },
    rarity = 2,
    cost = 6,
    attributes = { 'chips', 'scaling', 'joker', 'generation' },
    config = { extra = { chips_gain = 4, start_hands = 3, hands_left = 3, chips = 0, } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS['j_splash']
        return { vars = { card.ability.extra.chips_gain, card.ability.extra.hands_left, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if not context.blueprint then
            if context.individual and context.cardarea == G.play then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "chips",
                    scalar_value = "chips_gain"
                })
            end
            if context.after then
                card.ability.extra.hands_left = card.ability.extra.hands_left - 1
                if card.ability.extra.hands_left <= 0 then
                    return {
                        message = localize("k_slfa_snow_joker_melted"),
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.2,
                                func = function()
                                    local chips = card.ability.extra.chips
                                    SlopFactory.change_joker_center(card, G.P_CENTERS['j_splash'])
                                    card.ability.extra.chips = chips
                                    card.children.center:set_sprite_pos({x = 1, y = 0})
                                    return true
                                end
                            }))
                        end,
                    }
                end
            end
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
                {
                    ref_table = "card.ability.extra",
                    ref_value = "hands_left",
                },
                { text = "/" },
                {
                    ref_table = "card.ability.extra",
                    ref_value = "start_hands",
                },
                { text = ")" },
            },
            calc_function = function(card)
                if G.STATE ~= G.STATES.HAND_PLAYED then
                    local chips = card.ability.extra.chips
                    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                    if text ~= 'Unknown' then
                        for _, scoring_card in pairs(scoring_hand) do
                            chips = chips +
                                card.ability.extra.chips_gain *
                                JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end
                    card.joker_display_values.chips = chips
                end
            end
        }
    end,
}

SMODS.Joker:take_ownership('splash', {
    atlas = 'splash',
    pos = { x = 0, y = 0 },
    blueprint_compat = true,
    config = { extra = { chips = 0 } },
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.chips > 0 then
            local main_start = {
                {
                    n = G.UIT.R,
                    config = { ref_table = card, align = "m" },
                    nodes = {
                        { n = G.UIT.T, config = {
                            text = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } },
                            colour = G.C.CHIPS,
                            scale = 0.32
                        }},
                        { n = G.UIT.T, config = {
                            text = ' ' .. localize('k_chips'),
                            colour = G.C.UI.TEXT_DARK,
                            scale = 0.32
                        }},
                    }
                }
            }
            return { main_start = main_start }
        end
    end,
    set_sprites = function(self, card, front)
        local normal = not card.ability or type(card.ability.extra) ~= "table" or card.ability.extra.chips == 0
        card.children.center:set_sprite_pos({x = normal and 0 or 1, y = 0})
        card.joker_display_values = { disabled = normal }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
}, true)

JokerDisplay.Definitions['j_splash'] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.CHIPS },
}