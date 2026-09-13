SMODS.Joker {
    key = 'ace_in_the_hole',
    perishable_compat = false,
    atlas = 'jokers',
    pos = {
        x = 5,
        y = 0
    },
    rarity = 2,
    cost = 6,
    config = { extra = { Xmult_gain = 0.5, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.destroy_card and not context.blueprint then
            for _, playing_card in ipairs(context.scoring_hand) do
                if playing_card == context.destroy_card and context.destroy_card:get_id() == 14 then
                    return {
                        remove = true
                    }
                end
            end
        end
        if context.remove_playing_cards and not context.blueprint then
            local aces = 0
            for _, removed_card in ipairs(context.removed) do
                if removed_card:get_id() == 14 then aces = aces + 1 end
            end
            if aces > 0 then
                card.ability.extra.Xmult = card.ability.extra.Xmult + aces * card.ability.extra.Xmult_gain
                return { message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } } }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" }
                    }
                }
            }
        }
    end,
}