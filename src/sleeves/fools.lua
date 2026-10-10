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
            self.config = { booster_pack = 'p_slfa_buffoon_fools', price_hike = 50 }
            vars = { localize { type = 'name_text', set = 'Other', key = self.config.booster_pack }, self.config.price_hike }
        else
            key = self.key
            self.config = { joker_slot = 2, no_interest = true }
            vars = { self.config.joker_slot }
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        CardSleeves.Sleeve.apply(self)
        if self.get_current_deck_key() ~= "b_slfa_fools" then
            SMODS.Back.obj_table['b_slfa_fools'].apply(self)
        end
    end,
    calculate = function(self, sleeve, context)
        if self.get_current_deck_key() == 'b_slfa_fools' then
            if context.starting_shop then
                SMODS.add_booster_to_shop(self.config.booster_pack .. '_' .. 1)
                return true
            end
        end
    end
}

if CardSleeves then
    local set_cost_value_ref = Card.set_cost_value
    Card.set_cost_value = function(self)
        set_cost_value_ref(self)
        if G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_slfa_fools' and G.GAME.selected_sleeve == 'sleeve_slfa_fools' then
            local sleeve = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve)
            if sleeve and sleeve.config and sleeve.config.price_hike then
                self.cost = self.cost + math.floor((self.base_cost + self.extra_cost + 0.5)*sleeve.config.price_hike/100)
            end
        end
    end
end