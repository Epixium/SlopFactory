SMODS.Joker {
    key = 'the_cooler_joker',
    atlas = 'jokers',
    pos = {
        x = 9,
        y = 4
    },
    rarity = 1,
    cost = 3,
    attributes = { 'mult', 'position', 'joker' },
    config = { extra = { mult = 44 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS['j_joker']
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local other_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i - 1] end
            end
            if other_joker and other_joker.config.center.key == 'j_joker' then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end,
    in_pool = function(self, args)
        for _, joker in ipairs(G.jokers.cards) do
            if joker.config.center.key == 'j_joker' then
                return true
            end
        end
        return false
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                local other_joker = nil
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i - 1] end
                end
                card.joker_display_values.mult = card.ability.extra.mult * (other_joker and other_joker.config.center.key == 'j_joker' and 1 or 0)
            end
        }
    end,
}