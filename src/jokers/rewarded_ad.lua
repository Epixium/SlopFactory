-- code based on Cycle from Handsome Devils

local rarity_up_chance = 0.15
local rarity_down_chance = 0.05

local function reroll_joker(card)

    local rarity = card.config.center.rarity
    local rarity_roll = pseudorandom(pseudoseed('slfa_rewarded_ad_reroll_rarity'))
    local delta_rarity = (rarity_roll >= 1-rarity_up_chance and 1) or (rarity_roll <= rarity_down_chance and -1) or 0
    local final_rarity = (1 <= rarity and rarity <= 3 and math.max(1, math.min(3, rarity + delta_rarity))) or rarity
    local pool = {}
    local src = G.P_JOKER_RARITY_POOLS and G.P_JOKER_RARITY_POOLS[final_rarity] or G.P_CENTER_POOLS['Joker']


    for _, center in ipairs(src) do
        if center.key ~= card.config.center.key then
            pool[#pool + 1] = center
        end
    end

    local new_center = nil
    if #pool > 0 then
        new_center = pseudorandom_element(pool, pseudoseed('slfa_rewarded_ad_reroll_joker'))
    end

    -- if i'm stealing from handsome devils might as well leave in the compat
    local has_cursed = card.ability and card.ability.hnds_cursed
    local curse_data = has_cursed and card.ability.hnds_curse and copy_table(card.ability.hnds_curse) or nil

    local rep = {
        card = card,
        center = new_center,
        has_cursed = has_cursed,
        curse_data = curse_data,
    }

    if rep.center then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                local new_card = rep.card

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()

                        if new_card.remove_from_deck and type(new_card.remove_from_deck) == 'function' then
                            pcall(new_card.remove_from_deck, new_card)
                        end

                        new_card:set_ability(rep.center, true)

                        new_card:add_to_deck()

                        new_card:start_materialize()
                        new_card:juice_up(0.5, 0.3)
                        play_sound('card1', 1, 0.6)
                        return true
                    end
                }))
                return true
            end
        }))
    end

    return rep.card, final_rarity
end

SMODS.Joker {
    key = 'rewarded_ad',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 1,
        y = 2
    },
    soul_pos = {
        x = 2,
        y = 2
    },
    rarity = 3,
    cost = 7,
    config = { extra = { dollars = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval then
            local other_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i + 1] end
            end
            local new_joker, final_rarity
            local delta_rarity
            if other_joker then
                delta_rarity = -other_joker.config.center.rarity
                new_joker, final_rarity = reroll_joker(other_joker)
                delta_rarity = delta_rarity + final_rarity
            end
            local rarities = {"Common", "Uncommon", "Rare", "Legendary"}
            return {
                dollars = -card.ability.extra.dollars,
                extra = {
                    message = localize((tonumber(delta_rarity) == nil and 'slfa_rewarded_ad_reroll')
                        or (delta_rarity > 0 and 'slfa_rewarded_ad_rarity_up')
                        or (delta_rarity < 0 and 'slfa_rewarded_ad_rarity_down')
                        or 'slfa_rewarded_ad_reroll'),
                    colour = SMODS.Rarities[rarities[final_rarity] or final_rarity].badge_colour,
                }
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "-$" },
                { ref_table = "card.ability.extra", ref_value = "dollars" },
            },
            text_config = { colour = G.C.GOLD },
        }
    end
}