-- code based on Cycle from Handsome Devils

SMODS.Joker {
    key = 'rewarded_ad',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 1,
        y = 2
    },
    soul_pos = {
        x = 2,
        y = 2
    },
    rarity = 3,
    cost = 7,
    attributes = { 'reroll_joker', 'joker', 'position', 'lose_economy' },
    config = { extra = { dollars = 3 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = { set = "Other", key = "slfa_reroll_joker", vars = { 25, 15 } }
        return { vars = { card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval then
            local other_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i + 1] end
            end
            local message_table
            if other_joker then
                message_table = SlopFactory.reroll_joker(other_joker, { seed = 'rewarded_ad' })
            end
            return {
                dollars = -card.ability.extra.dollars,
                extra = message_table
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "-$" },
                { ref_table = "card.ability.extra", ref_value = "dollars" },
            },
            text_config = { colour = G.C.GOLD },
        }
    end
}