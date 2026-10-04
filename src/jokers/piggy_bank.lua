SMODS.Joker {
    key = 'piggy_bank',
    atlas = 'jokers',
    eternal_compat = false,
    pos = {
        x = 2,
        y = 5
    },
    rarity = 1,
    cost = 4,
    attributes = { 'economy', 'tag', 'generation' },
    config = { extra = { dollars = 0, tags = 2 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'tag_coupon', set = 'Tag' }
        return { vars = { card.ability.extra.dollars, card.ability.extra.tags, localize { type = 'name_text', set = 'Tag', key = 'tag_coupon' } } }
    end,
    calculate = function(self, card, context)
        if context.money_altered and context.initial + context.amount == card.ability.extra.dollars then
            return {
                message = localize { type = 'variable', key = 'a_slfa_plus_tag', vars = { card.ability.extra.tags } },
                message_card = card,
                func = function() -- This is for timing purposes, everything here runs after the message
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            for _ = 1, card.ability.extra.tags do
                                add_tag({ key = 'tag_coupon' })
                            end
                            play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                            play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                            SMODS.destroy_cards(card, nil, nil, true)
                            return true
                        end)
                    }))
                end
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {}
    end,
}