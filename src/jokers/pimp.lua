SMODS.Joker {
    key = 'pimp',
    perishable_compat = false,
    atlas = 'jokers',
    pos = {
        x = 2,
        y = 4
    },
    rarity = 2,
    cost = 6,
    attributes = { 'mult', 'editions', 'scaling' },
    config = { extra = { mult = 0, mult_gain = 7 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
    end,
    set_ability = function(self, card, initial, delay_sprites)
        G.E_MANAGER:add_event(Event({
            func = function()
                if card.area and card.area.config and not card.area.config.collection then
                    card:set_edition(SMODS.poll_edition({ guaranteed = true }))
                else
                    card:set_edition('e_polychrome', true, true)
                end
                return true
            end
        }))
        
    end,
    calculate = function(self, card, context)
        if not context.blueprint then
            local scale = false
            if context.playing_card_added then -- if a playing card has an edition
                for _, playing_card in ipairs(context.cards) do
                    if playing_card.edition then
                        scale = true
                        break
                    end
                end
            end
            if context.card_added then -- if a non-playing card has an edition
                if context.card.edition then
                    scale = true
                end
            end

            if scale then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_gain"
                })
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.MULT },
        }
    end,
}