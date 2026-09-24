SMODS.Joker {
    key = 'platinum_card',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 5,
        y = 3
    },
    rarity = 3,
    cost = 9,
    attributes = { 'shop', 'economy', 'reroll' },
    config = { extra = { shop_size = 3, reroll_cost = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.shop_size, card.ability.extra.reroll_cost } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                change_shop_size(card.ability.extra.shop_size)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost + card.ability.extra.reroll_cost
                G.GAME.current_round.reroll_cost = G.GAME.current_round.reroll_cost + card.ability.extra.reroll_cost
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        local shop_size = card.ability.extra.shop_size
        local reroll_cost = card.ability.extra.reroll_cost
        G.E_MANAGER:add_event(Event({
            func = function()
                change_shop_size(-shop_size)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - reroll_cost
                G.GAME.current_round.reroll_cost = math.max(0,
                    G.GAME.current_round.reroll_cost - reroll_cost)
                return true
            end
        }))
    end,
}