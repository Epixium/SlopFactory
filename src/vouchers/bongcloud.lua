
local function restock_vouchers()
    remove_all(G.shop_vouchers.cards)
    G.shop_vouchers.cards = {}
    for _ = 0, G.GAME.modifiers.extra_vouchers or 0 do
        SMODS.add_voucher_to_shop()
    end
    G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
end

-- bongcloud
SMODS.Voucher {
    key = 'bongcloud',
    atlas = 'vouchers',
    pos = { x = 2, y = 0 },
    config = { extra = { size = 1 } },
    attributes = { 'hand_size' },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.size } }
    end,
    redeem = function(self, card)
        check_for_unlock({ 'slfa_bongcloud_redeemed' })
        G.hand:change_size(-card.ability.extra.size)
        restock_vouchers()
    end
}

-- Brilliancy
SMODS.Voucher {
    key = 'brilliancy',
    atlas = 'vouchers',
    pos = { x = 3, y = 0 },
    config = { extra = { size = 2, slots = 1, active = true } },
    unlocked = false,
    requires = { 'v_slfa_bongcloud' },
    attributes = { 'hand_size', 'shop' },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.size, card.ability.extra.slots } }
    end,
    redeem = function(self, card)
        G.hand:change_size(card.ability.extra.size)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.change_voucher_limit(card.ability.extra.slots)
                return true
            end,
        }))
    end,
    calculate = function(self, card, context)
        if context.end_of_round and G.GAME.blind.boss then
            card.ability.extra.active = false
        end
        if context.starting_shop then
            if card.ability.extra.active then
                restock_vouchers()
            else
                card.ability.extra.active = true
            end
        end
    end,
    locked_loc_vars = function(self, info_queue, card)
        return { vars = { 1, G.PROFILES[G.SETTINGS.profile].voucher_usage.v_slfa_bongcloud and G.PROFILES[G.SETTINGS.profile].voucher_usage.v_slfa_bongcloud.count or 0 } }
    end,
    check_for_unlock = function(self, args)
        return args.type == 'slfa_bongcloud_redeemed' and G.PROFILES[G.SETTINGS.profile].voucher_usage['v_slfa_bongcloud'] and
            G.PROFILES[G.SETTINGS.profile].voucher_usage['v_slfa_bongcloud'].count >= 1
    end,
}