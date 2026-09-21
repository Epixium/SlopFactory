local function get_side_jokers(card)
    for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] == card then 
            return G.jokers.cards[i-1], G.jokers.cards[i+1]
        end
    end
    return nil, nil
end

SMODS.Joker {
    key = 'idea_guy',
    atlas = 'jokers',
    pos = {
        x = 7,
        y = 3
    },
    rarity = 1,
    cost = 10,
    attributes = { 'copying', 'debuff', 'position' },
    config = { extra = { overridden = nil } },
    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
            local copied_joker
            local overwritten_joker
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then 
                    copied_joker = G.jokers.cards[i - 1]
                    overwritten_joker = G.jokers.cards[i + 1]
                end
            end
            local compatible = copied_joker and copied_joker ~= card and copied_joker.config.center.blueprint_compat
            local main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { main_end = main_end }
        end
    end,
    calculate = function(self, card, context)

        context.selling_self = nil -- idea guy doesn't pass itself when selling

        local left_joker, right_joker = get_side_jokers(card)
        if not left_joker or not right_joker or not left_joker.config.center.blueprint_compat then return end
        local ret = SMODS.blueprint_effect(right_joker, left_joker, context)
        if ret then
            ret.colour = G.C.BLUE
            ret.message_card = right_joker
            return ret
        end
        if context.post_trigger and context.other_card == right_joker then
            EMPTY(context.other_ret)
        end
        if context.selling_card and context.card == right_joker then
            right_joker:remove_from_deck() -- manual style
            card.ability.extra.overridden = nil
        end
    end,
    update = function(self, card, dt)
        if card.area.config.collection then return false end
        
        if card.ability.extra.overridden and
            card.ability.extra.overridden.getting_sliced or card.ability.extra.dissolve ~= 0
        then
            card.ability.extra.overridden = nil
        end
        
        local _, right_joker = get_side_jokers(card)
        
        -- un-override the last overridden joker
        if card.ability.extra.overridden ~= right_joker then
            if card.ability.extra.overridden and card.ability.extra.overridden.add_to_deck then
                card.ability.extra.overridden:add_to_deck(true)
                if JokerDisplay then
                    card.ability.extra.overridden:initialize_joker_display()
                end
            end
            if right_joker and right_joker.remove_from_deck then
                right_joker:remove_from_deck(true)
            end
            --SMODS.calculate_context({slfa_idea_guy_debuff = true, other_card = right_joker})
        end

        card.ability.extra.overridden = right_joker
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.overridden then
            card.ability.extra.overridden:add_to_deck(true)
            if JokerDisplay then
                card.ability.extra.overridden:initialize_joker_display()
            end
            card.ability.extra.overridden = nil
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.RED },
                { text = ")" }
            },
            calc_function = function(card)
                local _, right_joker = get_side_jokers(card)
                local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
                if right_joker then
                    right_joker.joker_display_values = right_joker.joker_display_values or {}
                    local definition = JokerDisplay.Definitions[right_joker.config.center.key]
                    JokerDisplay.copy_display(right_joker, copied_joker, copied_debuff)
                    if definition and definition.get_blueprint_joker then
                        right_joker.joker_display_stop_calc = true
                    end
                end
                card.joker_display_values.is_compatible = copied_joker ~= nil
                card.joker_display_values.blueprint_compat = localize(card.joker_display_values.is_compatible and 'k_compatible' or 'k_incompatible')
            end,
            style_function = function(card, text, reminder_text, extra)
                if reminder_text and reminder_text.children[2] then
                    reminder_text.children[2].config.colour = card.joker_display_values.is_compatible and G.C.GREEN or G.C.RED
                end
            end,
            get_blueprint_joker = function(card)
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then
                        return G.jokers.cards[i-1]
                    end
                end
                return nil
            end
        }
    end
}