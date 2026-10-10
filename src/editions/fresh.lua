SMODS.Shader({ key = 'fresh', path = 'fresh.fs' })
SMODS.Sound { key = 'fresh', path = 'fresh.ogg' }

SMODS.Edition {
    key = 'fresh',
    shader = 'fresh',
    config = { extra = { tags = 2, hands = 1 } },
    in_shop = true,
    weight = 9,
    extra_cost = 3,
    sound = { sound = 'slfa_fresh', per = 1.04, vol = 1.02 },
    attributes = { 'skip', 'tags', },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.edition.extra.tags, card.edition.extra.hands },
            key = SMODS.is_playing_card(card) and self.key .. "_playing_card" or self.key }
    end,
    get_weight = function(self)
        return self.weight
    end,
    calculate = function(self, card, context)
        if card.ability.set == 'Joker' then
            if context.skip_blind then
                local tags = {}
                for _ = 1, card.edition.extra.config.tags do
                    tags[#tags+1] = { key = SMODS.poll_object{ type = "Tag", seed = "slfa_fresh" }, "Small" }
                end
                return {
                    message = localize { type = 'variable', key = 'a_slfa_plus_tag', vars = { card.edition.extra.tags } },
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

SlopFactory.calculate_steps[#SlopFactory.calculate_steps+1] = function(context)
    if context.final_scoring_step then
        for _, card in ipairs(context.full_hand) do
            if card.edition and card.edition.key == "e_slfa_fresh" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        ease_hands_played(-1)
                        SMODS.calculate_effect(
                            { message = localize { type = 'variable', key = 'a_hands', vars = { card.edition.extra.hands } } },
                            context.blueprint_card or card)
                        return true
                    end
                }))
                local tags = {}
                for _ = 1, card.edition.extra.tags do
                    tags[#tags+1] = { key = SMODS.poll_object{ type = "Tag", seed = "slfa_fresh" }, "Small" }
                end
                return {
                    message = localize { type = 'variable', key = 'a_slfa_plus_tag', vars = { card.edition.extra.tags } },
                    message_card = card,
                    func = function() -- This is for timing purposes, everything here runs after the message
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                for _, tag in ipairs(tags) do
                                    add_tag(tag)
                                    local ret = G.GAME.tags[#G.GAME.tags]:apply_to_run({type = 'immediate'})
                                    if ret and type(ret) == 'table' then
                                        add_round_eval_row({dollars = ret.dollars, bonus = true, name='tag'..i, pitch = pitch, condition = ret.condition, pos = ret.pos, tag = ret.tag})
                                        pitch = pitch + 0.06
                                        dollars = dollars + ret.dollars
                                    end
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