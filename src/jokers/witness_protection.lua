SMODS.Joker {
    key = 'witness_protection',
    perishable_compat = false,
    atlas = 'jokers',
    pos = {
        x = 8,
        y = 4
    },
    rarity = 1,
    cost = 4,
    attributes = { 'mult', 'scaling', 'rank', 'ace', 'two', 'three', 'four', 'five' },
    config = { extra = { mult_gain = 2, mult = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local above_five = false
            for _, playing_card in ipairs(context.full_hand) do
                local id = playing_card:get_id()
                if id > 5 and id ~= 14 then
                    above_five = true
                    break
                end
            end
            if not above_five then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_gain"
                })
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.MULT },
        }
    end,
}