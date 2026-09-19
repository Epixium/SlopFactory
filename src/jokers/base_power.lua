SMODS.Joker {
    key = 'base_power',
    atlas = 'jokers',
    pos = {
        x = 8,
        y = 1
    },
    rarity = 3,
    cost = 8,
    attributes = { 'chips', 'xmult', 'hand_type' },
    config = { extra = { chips = 100, Xmult = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {
            card.ability.extra.chips, card.ability.extra.Xmult
        } }
    end,
    calculate = function(self, card, context)
        if context.modify_hand then
            if G.GAME.hands[context.scoring_name].level == 1 then
                return {
                    message = localize('k_showmeyourpower_ex'),
                    colour = G.C.BLACK,
                    --sound = 'multhit2',
                    func = function() -- This is for timing purposes, it runs after the message
                        SMODS.Scoring_Parameters.chips:modify(card.ability.extra.chips)
                        SMODS.Scoring_Parameters.mult:modify(SMODS.get_scoring_parameter('mult', false) * card.ability.extra.Xmult)
                        update_hand_text({ sound = 'chips2', modded = false }, { chips = hand_chips, mult = mult })
                    end
                }
            end
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
                { text = " " },
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
                    }
                }
            },
            calc_function = function(card)
                card.joker_display_values.chips = 0
                card.joker_display_values.Xmult = 1
                local scoring_name, _, _ = JokerDisplay.evaluate_hand()
                if scoring_name and scoring_name ~= 'Unknown' and G.GAME.hands[scoring_name] then
                    if G.GAME.hands[scoring_name].level == 1 then
                        card.joker_display_values.chips = card.ability.extra.chips
                        card.joker_display_values.Xmult = card.ability.extra.Xmult
                    end
                end
            end,
        }
    end
}