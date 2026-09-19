local calculate_blueprint_copies = function(card, _cycle_count, _cycle_debuff)
     local joker_display_definition = JokerDisplay.Definitions[card.config.center.key]
    if not joker_display_definition.get_blueprint_jokers or (_cycle_count and _cycle_count > #G.jokers.cards + 1) then
        return {}, {}
    end
    local other_jokers = joker_display_definition.get_blueprint_jokers(card)
    local copied_jokers = {}
    local copied_debuffs = {}
    for _, other_joker in ipairs(other_jokers) do
       if other_joker ~= card and other_joker.config.center.blueprint_compat then
            local other_joker_display_definition = JokerDisplay.Definitions[other_joker.config.center.key]
            if other_joker_display_definition and other_joker_display_definition.get_blueprint_joker then
                copied_jokers[#copied_jokers+1], copied_debuffs[#copied_debuffs+1] = JokerDisplay.calculate_blueprint_copy(other_joker,
                    _cycle_count and _cycle_count + 1 or 1,
                    _cycle_debuff or other_joker.debuff)
            elseif other_joker_display_definition and other_joker_display_definition.get_blueprint_jokers then
                local subcopies, subdebuffs = calculate_blueprint_copies(other_joker,
                    _cycle_count and _cycle_count + 1 or 1,
                    _cycle_debuff or other_joker.debuff)
                for _, elem in ipairs(subcopies) do
                    copied_jokers[#copied_jokers+1] = elem
                end
                for _, elem in ipairs(subdebuffs) do
                    copied_debuffs[#copied_debuffs+1] = elem
                end
            else
                copied_jokers[#copied_jokers+1], copied_debuffs[#copied_debuffs+1] = other_joker, (_cycle_debuff or other_joker.debuff)
            end
        end
    end
    return copied_jokers, copied_debuffs
end

SMODS.Joker {
    key = 'jokester',
    atlas = 'jokers',
    pos = {
        x = 7,
        y = 2
    },
    rarity = 3,
    cost = 10,
    attributes = { 'copying', 'position', 'joker' },
    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
            local other_jokers = {}
            for _, joker in ipairs(G.jokers.cards) do
                local name = localize { type = 'name_text', set = joker.ability.set, key = joker.config.center.key }
                if string.find(name, localize('k_joker')) or string.find(name, 'Joker') then
                    other_jokers[#other_jokers+1] = joker
                end
            end
            if #other_jokers == 0 then return end
            local compat_nodes = {}
            for _, joker in ipairs(other_jokers) do
                local compatible = joker ~= card and joker.config.center.blueprint_compat
                compat_nodes[#compat_nodes+1] = {
                    n = G.UIT.R,
                    config = { align = "m" },
                    nodes = {
                        { 
                            n = G.UIT.C,
                            config = { ref_table = card, r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = joker.config.center.name, colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 * 0.8 } },
                            }
                        },
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            end
            local main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = compat_nodes
                }
            }
            return { main_end = main_end }
        end
    end,
    calculate = function(self, card, context)
        local other_jokers = {}
        for _, joker in ipairs(G.jokers.cards) do
            local name = localize { type = 'name_text', set = joker.ability.set, key = joker.config.center.key }
            if string.find(name, localize('k_joker')) or string.find(name, 'Joker') then
                other_jokers[#other_jokers+1] = joker
            end
        end
        local effects = {}
        for _, joker in ipairs(other_jokers) do
            local ret = SMODS.blueprint_effect(card, joker, context)
            if ret then
                ret.colour = G.C.BLUE
                effects[#effects+1] = ret
            end
        end
        if #effects == 0 then return end
        return SMODS.merge_effects(effects)
    end,
    in_pool = function(self, args)
        for _, joker in ipairs(G.jokers.cards) do
            local name = localize { type = 'name_text', set = joker.ability.set, key = joker.config.center.key }
            if string.find(name, localize('k_joker')) or string.find(name, 'Joker') then
                return true
            end
        end
        return false
    end,
    --[[
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.RED },
                { text = ")" }
            },
            calc_function = function(card)
                local copied_jokers, copied_debuffs = calculate_blueprint_copies(card)
                card.joker_display_values.blueprint_compat = localize('k_incompatible')

                if card.children.joker_display then
                    card.children.joker_display:remove_text()
                    card.children.joker_display:remove_reminder_text()
                    card.children.joker_display:remove_extra()
                end
                if card.children.joker_display_small then
                    card.children.joker_display_small:remove_text()
                    card.children.joker_display_small:remove_reminder_text()
                    card.children.joker_display_small:remove_extra()
                end
                for i = 1, #copied_jokers do
                    add_to_display(card, copied_jokers[i], copied_debuffs[i])
                end
            end,
            get_blueprint_jokers = function(card)
                local other_jokers = {}
                for _, joker in ipairs(G.jokers.cards) do
                    if string.find(joker.config.center.name, localize('k_joker')) then
                        other_jokers[#other_jokers+1] = joker
                    end
                end
                return other_jokers
            end
        }
    end
    ]]
}