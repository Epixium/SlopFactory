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
            self.config = { booster_slot = -1, booster_pack = 'p_buffoon_jumbo' }
            vars = { localize { type = 'name_text', set = 'Other', key = self.config.booster_pack }, self.config.booster_slot }
        else
            key = self.key
            self.config = { joker_slot = 2, hand_size = -2, jokers = { 'j_joker' } }
            vars = { self.config.joker_slot, self.config.hand_size, localize { type = 'name_text', set = 'Joker', key = self.config.jokers[1] } }
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        CardSleeves.Sleeve.apply(self)
        if self.get_current_deck_key() ~= "b_slfa_fools" then
            SMODS.Back.obj_table['b_slfa_fools'].apply(self)
        else
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.change_booster_limit(self.config.booster_slot)
                    return true
                end
            }))
        end
    end,
    calculate = function(self, sleeve, context)
        if self.get_current_deck_key() == 'b_slfa_fools' then
            if context.starting_shop then
                local booster = SMODS.add_booster_to_shop(self.config.booster_pack .. '_' .. 1)
                booster.cost = 0
                return true
            end
        end
    end
}