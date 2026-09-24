CardSleeves.Sleeve {
    key = 'orange',
    atlas = 'sleeves',
    pos = { x = 1, y = 0 },
    unlocked = false,
    unlock_condition = { deck = "b_slfa_orange", stake = "stake_black" },
    loc_vars = function(self)
        local key = self.key
        if self.get_current_deck_key() == 'b_slfa_orange' then
            key = self.key .. "_alt"
        end
        return { key = key }
    end,
    calculate = function(self, sleeve, context)
        if self.get_current_deck_key() ~= 'b_slfa_orange' then
            SMODS.Back.obj_table['b_slfa_orange'].calculate(self, sleeve, context)
        else
            if context.pre_discard then
                sleeve.ability = { active = true }
            end
            if context.drawing_cards and sleeve.ability and sleeve.ability.active then
                sleeve.ability.active = nil
                if G.jokers and G.jokers.cards and #G.jokers.cards > 0 then
                    local joker = G.jokers.cards[#G.jokers.cards]
                    local message_table = SlopFactory.reroll_joker(joker, {
                        seed = 'orange_sleeve',
                        rarity_up = SMODS.Back.obj_table['b_slfa_orange'].config.rarity_up,
                        rarity_down = SMODS.Back.obj_table['b_slfa_orange'].config.rarity_down,
                    })
                    message_table.message_card = joker
                    return message_table
                end
            end
        end
    end
}