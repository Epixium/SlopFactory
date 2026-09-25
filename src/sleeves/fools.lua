CardSleeves.Sleeve {
    key = 'fools',
    atlas = 'sleeves',
    pos = { x = 2, y = 0 },
    unlocked = false,
    unlock_condition = { deck = "b_slfa_fools", stake = "stake_black" },
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() == "b_slfa_fools" then
            key = self.key .. "_alt"
            self.config = { joker_slot = 2, consumable_slot = -1 }
            vars = { self.config.joker_slot, self.config.consumable_slot }
        else
            key = self.key
            self.config = { joker_slot = 3, hand_size = -3, blind_ante = 0 }
            vars = { self.config.joker_slot, self.config.hand_size, self.config.blind_ante }
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        if self.get_current_deck_key() ~= "b_slfa_fools" then
            SMODS.Back.obj_table['b_slfa_fools'].calculate(self)
        end
    end,
}