SMODS.Joker {
    key = 'bargain_bin',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 5
    },
    soul_pos = {
        x = 1,
        y = 5
    },
    rarity = 1,
    cost = 5,
    attributes = { 'shop', 'economy', 'sell_value', 'joker', 'rarity' },
    config = { extra = { dollars = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, other_card in pairs(G.I.CARD) do
                    if other_card.set_cost then other_card:set_cost() end
                end
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, other_card in pairs(G.I.CARD) do
                    if other_card.set_cost then other_card:set_cost() end
                end
                return true
            end
        }))
    end,
    joker_display_def = function(JokerDisplay)
        return {}
    end
}

local set_cost_value_ref = Card.set_cost_value
Card.set_cost_value = function(self)
    set_cost_value_ref(self)
    if self:is_rarity("Common") then
        local bins = find_joker('j_slfa_bargain_bin')
        for _, joker in ipairs(bins) do
            self.cost = self.cost - joker.ability.extra.dollars
        end
        self.cost = math.max(self.cost, 0)
    end
end
