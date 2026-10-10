-- code based on Cycle from Handsome Devils

SMODS.Joker {
    key = 'infinite_zest',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 4,
        y = 4
    },
    rarity = 2,
    cost = 7,
    slfa_bloat = true,
    attributes = { 'reroll_joker', 'joker', 'food' },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = { set = "Other", key = "slfa_reroll_joker", vars = { 25, 25 } }
        if card.area and card.area == G.jokers then
            local other_jokers = {}
            for _, joker in ipairs(G.jokers.cards) do
                if joker:has_attribute('food') then
                    other_jokers[#other_jokers+1] = joker
                end
            end
            if #other_jokers == 0 then return end
            local food_nodes = {}
            for _, joker in ipairs(other_jokers) do
                food_nodes[#food_nodes+1] = {
                    n = G.UIT.R,
                    config = { align = "m" },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, r = 0.04, padding = 0.01 },
                            nodes = {
                                { n = G.UIT.T, config = { text = localize { type = 'name_text', set = 'Joker', key = joker.config.center.key }, colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            end
            local main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.2 },
                    nodes = food_nodes
                }
            }
            return { main_end = main_end }
        end
    end,
    calculate = function(self, card, context)
        if context.joker_type_destroyed and context.card.area == G.jokers and context.card:has_attribute('food') then
            local message_table = SlopFactory.reroll_joker(context.card, { seed = 'infinite_zest', attributes = {'food'} })
            return {
                no_destroy = true,
                extra = message_table
            }
        end
    end,
    in_pool = function(self, args)
        for _, joker in ipairs(G.jokers.cards or {}) do
            if joker:has_attribute('food') then
                return true
            end
        end
        return false
    end,
    joker_display_def = function(JokerDisplay)
        return {}
    end
}