SMODS.Back {
    key = 'orange',
    atlas = 'backs',
    pos = {
        x = 1,
        y = 0
    },
    loc_vars = function(self, info_queue, back)
        info_queue[#info_queue+1] = { set = "Other", key = "slfa_reroll_joker", vars = { 100, 0 } }
    end,
    calculate = function(self, back, context)
        if context.round_eval and G.GAME.last_blind and G.GAME.last_blind.boss then
            if G.jokers and G.jokers.cards and #G.jokers.cards > 0 then
                local joker = G.jokers.cards[#G.jokers.cards]
                local message_table = SlopFactory.reroll_joker(joker, {
                    seed = 'orange_deck',
                    rarity_up = 1,
                    rarity_down = 0
                })
                message_table.message_card = joker
                return message_table
            end
        end
    end,
}