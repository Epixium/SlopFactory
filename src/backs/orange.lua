SMODS.Back {
    key = 'orange',
    atlas = 'backs',
    pos = {
        x = 1,
        y = 0
    },
    config = { rarity_up = .2, rarity_down = .4},
    loc_vars = function(self, info_queue, back)
        info_queue[#info_queue+1] = { set = "Other", key = "slfa_reroll_joker", vars = { self.config.rarity_up * 100, self.config.rarity_down * 100 } }
    end,
    calculate = function(self, back, context)
        if context.round_eval and G.GAME.last_blind then
            if G.jokers and G.jokers.cards and #G.jokers.cards > 0 then
                local joker = G.jokers.cards[#G.jokers.cards]
                local message_table = SlopFactory.reroll_joker(joker, {
                    seed = 'orange_deck',
                    rarity_up = self.config.rarity_up,
                    rarity_down = self.config.rarity_down
                })
                message_table.message_card = joker
                return message_table
            end
        end
    end,
}