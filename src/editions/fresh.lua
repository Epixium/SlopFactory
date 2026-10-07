SMODS.Shader({ key = 'fresh', path = 'fresh.fs' })
SMODS.Sound { key = 'fresh', path = 'fresh.ogg' }

SMODS.Edition {
    key = 'fresh',
    shader = 'fresh',
    config = { tags = 2, extra = { is_active = true } },
    in_shop = true,
    weight = 9,
    extra_cost = 3,
    sound = { sound = 'slfa_fresh', per = 1.04, vol = 1.02 },
    attributes = { 'skip', 'tags', },
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.tags },
            key = SMODS.is_playing_card(card) and self.key .. "_playing_card" or self.key }
    end,
    get_weight = function(self)
        return self.weight
    end,
    calculate = function(self, card, context)
        if card.ability.set == 'Joker' then
            if context.skip_blind then
                local tags = {}
                for _ = 1, G.P_CENTERS[card.edition.key].config.tags do
                    tags[#tags+1] = { key = SMODS.poll_object{ type = "Tag", seed = "slfa_fresh" }, "Small" }
                end
                return {
                    message = localize { type = 'variable', key = 'a_slfa_plus_tag', vars = { G.P_CENTERS[card.edition.key].config.tags } },
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
            if context.main_scoring and context.cardarea == G.play and
                G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 then
                local tags = {}
                for _ = 1, card.edition.tags do
                    tags[#tags+1] = { key = SMODS.poll_object{ type = "Tag", seed = "slfa_fresh" }, "Small" }
                end
                return {
                    message = localize { type = 'variable', key = 'a_slfa_plus_tag', vars = { G.P_CENTERS[card.edition.key].config.tags } },
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
    end,
}