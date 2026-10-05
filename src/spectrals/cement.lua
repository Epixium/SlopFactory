
local function get_valid_jokers()
    local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
    local valid_jokers = {}
    for _, joker in ipairs(editionless_jokers) do
        if joker.eternal_compat ~= false and not joker.ability.perishable and not joker.ability.eternal then
            valid_jokers[#valid_jokers+1] = joker
        end
    end
    return valid_jokers
end

SMODS.Consumable {
    key = 'cement',
    atlas = 'spectrals',
    pos = {
        x = 0,
        y = 0
    },
    attributes = { 'joker', 'editions', 'sticker' },
    set = 'Spectral',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_slfa_megaflash
        info_queue[#info_queue + 1] = {key = 'eternal', set = 'Other'}
    end,
    use = function(self, card, area, copier)
        local editionless_jokers = get_valid_jokers()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local eligible_card = pseudorandom_element(editionless_jokers, 'slfa_cement')
                eligible_card:set_edition("e_slfa_megaflash")
                eligible_card:add_sticker('eternal', true)
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end,
    can_use = function(self, card)
        return next(get_valid_jokers())
    end,
}