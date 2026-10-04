SMODS.Joker {
    key = 'secret_room',
    atlas = 'jokers',
    blueprint_compat = false,
    pos = {
        x = 6,
        y = 5
    },
    rarity = 2,
    cost = 6,
    attributes = { 'shop', 'economy', 'reroll', 'chance' },
    config = { extra = { odds = 3, card_slots = 0, card_slots_per = 1 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'slfa_secret_room')
        return { vars = { numerator, denominator, card.ability.extra.card_slots_per, card.ability.extra.card_slots } }
    end,
    calculate = function(self, card, context)
        if context.reroll_shop then
            if SMODS.pseudorandom_probability(card, 'slfa_secret_room', 1, card.ability.extra.odds) then
                card.ability.extra.card_slots = card.ability.extra.card_slots + card.ability.extra.card_slots_per
                change_shop_size(card.ability.extra.card_slots_per)
                return {
                    message = localize('k_slfa_plus_card_slot'),
                }
            end
        end
        if context.ending_shop and card.ability.extra.card_slots ~= 0 then
            change_shop_size(-card.ability.extra.card_slots)
            card.ability.extra.card_slots = 0
            return {
                message = localize('k_reset'),
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        local card_slots = card.ability.extra.card_slots
        G.E_MANAGER:add_event(Event({
            func = function()
                change_shop_size(card_slots)
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        local card_slots = card.ability.extra.card_slots
        G.E_MANAGER:add_event(Event({
            func = function()
                change_shop_size(-card_slots)
                return true
            end
        }))
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "card_slots" },
            },
            text_config = { colour = G.C.ORANGE },
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "odds" },
                    { text = ")" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            calc_function = function(card)
                local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'slfa_prime_day')
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
             end,
        }
    end
}