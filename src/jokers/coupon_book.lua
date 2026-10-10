SMODS.Joker {
    key = 'coupon_book',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 2,
        y = 0
    },
    rarity = 1,
    cost = 5,
    attributes = { 'scaling', 'economy', 'shop' },
    config = { extra = { percent = 25 } },
    loc_vars = function(self, info_queue, card)
        local count = 0
        for _ in pairs(G.GAME.used_vouchers) do count = count + 1 end
        return { vars = { card.ability.extra.percent, card.ability.extra.percent * (G.GAME.slfa and #G.GAME.slfa.ante_vouchers or 0) } }
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
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "percent" },
                { text = "%" },
            },
            text_config = { colour = G.C.ORANGE },
            calc_function = function(card)
                card.joker_display_values.percent = card.ability.extra.percent * #G.GAME.slfa.ante_vouchers
            end
        }
    end
}

SlopFactory.calculate_steps[#SlopFactory.calculate_steps+1] = function(context)
    if context.buying_card and context.card.ability.set == 'Voucher' then
        G.GAME.slfa.ante_vouchers[#G.GAME.slfa.ante_vouchers+1] = context.card
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, other_card in pairs(G.I.CARD) do
                    if other_card.set_cost then other_card:set_cost() end
                end
                return true
            end
        }))
    end
    if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss then
        G.GAME.slfa.ante_vouchers = {}
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, other_card in pairs(G.I.CARD) do
                    if other_card.set_cost then other_card:set_cost() end
                end
                return true
            end
        }))
    end
end

SlopFactory.resetters[#SlopFactory.resetters+1] = function(run_start)
    if run_start then
        G.GAME.slfa.ante_vouchers = {}
    end
end

local set_cost_value_ref = Card.set_cost_value
Card.set_cost_value = function(self)
    set_cost_value_ref(self)
    local coupons = find_joker('j_slfa_coupon_book')
    local total_off = 0
    for _, card in ipairs(coupons) do
        total_off = total_off + card.ability.extra.percent * #G.GAME.slfa.ante_vouchers
    end
    self.cost = self.cost - math.floor((self.base_cost + self.extra_cost + 0.5)*total_off/100)
end