SMODS.Shader({ key = 'fresh', path = 'fresh.fs' })

SMODS.Edition {
    key = 'fresh',
    shader = 'fresh',
    config = { tags = 2 },
    in_shop = true,
    weight = 6,
    extra_cost = 3,
    sound = { sound = 'slfa_megaflash', per = 1.4, vol = 1.02 },
    attributes = { 'skip', 'tags', },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.edition and card.edition.tags or self.config.tags } }
    end,
    get_weight = function(self)
        return self.weight
    end,
    calculate = function(self, card, context)
        if card.ability.set == 'Joker' then
            if context.skip_blind then
                local tags = {}
                for _ = 1, card.edition.tags do
                    tags[#tags+1] = { key = SMODS.poll_object{ type = "Tag", seed = "slfa_fresh" }, "Small" }
                end
                return {
                    message = localize { type = 'variable', key = 'a_slfa_plus_tag', vars = { card.edition.tags } },
                    message_card = card,
                    func = function() -- This is for timing purposes, everything here runs after the message
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                for _, tag in ipairs(tags) do
                                    add_tag(tag)
                                end
                                play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                                play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                                return true
                            end)
                        }))
                    end
                }
            end
        else
            if context.end_of_round and G.GAME.current_round.hands_played == 1 then
                for _, playing_card in ipairs(G.GAME.last_hand.full_hand) do
                    if playing_card == card then
                        local tags = {}
                        for _ = 1, card.edition.tags do
                            tags[#tags+1] = { key = SMODS.poll_object{ type = "Tag", seed = "slfa_fresh" }, "Small" }
                        end
                        return {
                            message = localize { type = 'variable', key = 'a_slfa_plus_tag', vars = { card.edition.tags } },
                            message_card = card,
                            func = function() -- This is for timing purposes, everything here runs after the message
                                G.E_MANAGER:add_event(Event({
                                    func = (function()
                                        for _, tag in ipairs(tags) do
                                            add_tag(tag)
                                        end
                                        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                                        return true
                                    end)
                                }))
                            end
                        }
                    end
                end
            end
        end
    end,
}