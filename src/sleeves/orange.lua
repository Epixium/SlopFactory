CardSleeves.Sleeve {
    key = 'orange',
    atlas = 'sleeves',
    pos = { x = 1, y = 0 },
    unlocked = false,
    unlock_condition = { deck = "b_slfa_orange", stake = "stake_black" },
    loc_vars = function(self)
        local key = self.key
        if self.get_current_deck_key() == "b_slfa_orange" then
            key = self.key .. "_alt"
            --info_queue[#info_queue+1] = { set = "Other", key = "slfa_reroll_joker", vars = { 100, 0 } }
        end
        return { key = key }
    end,
    calculate = function(self, sleeve, context)
        if context.round_eval and G.GAME.last_blind then
            -- if orange deck, only do it on non-boss blinds
            -- otherwise, only do it on boss blinds
            if (self.get_current_deck_key() == 'b_slfa_orange') == (G.GAME.last_blind.boss ~= nil) then return end

            if G.jokers and G.jokers.cards and #G.jokers.cards > 0 then
                local joker = G.jokers.cards[#G.jokers.cards]
                local message_table = SlopFactory.reroll_joker(joker, {
                    seed = 'orange_sleeve',
                    rarity_up = 1,
                    rarity_down = 0
                })
                message_table.message_card = joker
                return message_table
            end
        end
    end
}