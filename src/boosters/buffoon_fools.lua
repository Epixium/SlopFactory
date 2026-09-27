SMODS.Booster {
    key = 'buffoon_fools_1',
    weight = 0,
    kind = 'Buffoon',
    cost = 0,
    atlas = 'boosters',
    pos = { x = 1, y = 0 },
    config = { extra = 5, choose = 1 },
    group_key = "k_buffoon_pack", -- Delete this if you're using `group_name` in `loc_txt`
    no_collection = function()
        return CardSleeves == nil
    end,
    loc_vars = function(self, info_queue, card)
        -- This loc_vars is here to show how it would normally be structured and use the `key` return
        -- If you don't need that you can omit the loc_vars and SMODS will handle the default variables for you
        local cfg = (card and card.ability) or self.config
        return {
            vars = {
                math.min(cfg.choose + (G.GAME.modifiers.booster_choice_mod or 0),
                    math.max(1, cfg.extra + (G.GAME.modifiers.booster_size_mod or 0))),
                math.max(1, cfg.extra + (G.GAME.modifiers.booster_size_mod or 0)) },
            key = self.key:sub(1, -3), -- This uses the description key of the booster without the number at the end. Remove this if your booster doesn't have artwork variants like vanilla
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        return { set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "buf" }
    end,
}

local set_cost_value_ref = Card.set_cost_value
Card.set_cost_value = function(self)
    set_cost_value_ref(self)
    if string.find(self.config.center.key, "slfa_buffoon_fools") then
        self.cost = 0
    end
end
