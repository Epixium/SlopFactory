--[[
local initialize_display_ref = Card.initialize_joker_display
Card.initialize_joker_display = function(self, custom_parent, stop_calc)
    print('JD for ' .. self.config.center.key .. ' being initialized now...')
    return initialize_display_ref(self, custom_parent, stop_calc)
end
]]
local function slfa_setup_police_sketch_joker(card)
    local key = card.ability.extra.current_joker
    G.slfa_saved_jokers = G.slfa_saved_jokers or {}
    -- save schuff
    local old_ability = copy_table(card.ability)
    local old_center = card.config.center
    local old_center_key = card.config.center_key
    local old_joker_display = card.children.joker_display
    local old_joker_display_small = card.children.joker_display_small
    local old_joker_display_debuff = card.children.joker_display_debuff
    --local old_children = card.children
    -- ok now we get to rip out the card's chest and make a new heart for it
    card:set_ability(key, true, 'quantum')
    --card:update(0.016)
    G.slfa_saved_jokers[card.sort_id] = SMODS.shallow_copy(card)
    G.slfa_saved_jokers[card.sort_id].added_to_deck = false
    G.slfa_saved_jokers[card.sort_id].ability
        = copy_table(G.slfa_saved_jokers[card.sort_id].ability)
    for k, v in pairs({'T', 'VT', 'CT'}) do
        G.slfa_saved_jokers[card.sort_id][v]
            = copy_table(G.slfa_saved_jokers[card.sort_id][v])
    end
    G.slfa_saved_jokers[card.sort_id].config
        = SMODS.shallow_copy(G.slfa_saved_jokers[card.sort_id].config)
    
    -- reset schtuff
    card.ability = old_ability
    card.config.center = old_center
    card.config.center_key = old_center_key
    card.children.joker_display = old_joker_display
    card.children.joker_display_small = old_joker_display_small
    card.children.joker_display_debuff = old_joker_display_debuff
    --card.children = old_children
    for k, v in pairs({'juice_up', 'start_dissolve', 'remove', 'flip'}) do
        G.slfa_saved_jokers[card.sort_id][v] = function(_, ...)
            return card[v](card, ...)
        end
    end
    return G.slfa_saved_jokers[card.sort_id]
end

local function slfa_random_police_sketch_joker()
    local poll = SMODS.poll_object({
        set = 'Joker',
        seed = pseudorandom('slfa_police_sketch' .. G.GAME.round_resets.ante),
        filter = function(pool)
            local new_pool = {}
            for _, table in ipairs(pool) do
                if not SMODS.has_attribute(G.P_CENTERS[table.key], 'copying') then
                    new_pool[#new_pool+1] = {table.key, 'Joker'}
                end
            end
            return new_pool
        end,
        rarity = false,
        allow_legendaries = false
    })
    if type(poll) == 'table' then
        poll = poll[1]
    end
    return poll
end

local function slfa_reset_police_sketch_joker(card)
    card.ability.extra.current_joker = card.ability.extra.upcoming_joker or slfa_random_police_sketch_joker()
    card.ability.extra.upcoming_joker = slfa_random_police_sketch_joker()

    --card.ability.extra.current_joker = 'j_slfa_anchor'
    --sendInfoMessage("police sketch joker is now: " .. card.ability.extra.current_joker .. "", "SLFA")
    return card.ability.extra.current_joker
end

SMODS.Joker {
    key = 'police_sketch',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 6,
        y = 3
    },
    rarity = 3,
    cost = 10,
    attributes = { 'copying', 'joker', 'hands', 'on_sell', 'generation' },
    config = { extra = { current_joker = nil, upcoming_joker = nil } };
    loc_vars = function(self, info_queue, card)
        local center = G.P_CENTERS[card.ability.extra.current_joker or 'j_joker']
        local other_center = SMODS.shallow_copy(center)
        if card.ability.extra.current_joker and center.loc_vars then
            other_center.loc_vars = function(self_again, info_deux, uncard)
                return center.loc_vars(self_again, info_deux, G.slfa_saved_jokers[card.sort_id])
            end
        end
        info_queue[#info_queue+1] = other_center or G.P_CENTERS[card.ability.extra.current_joker or 'j_joker']
        return { vars = { localize { type = 'name_text', set = 'Joker', key = card.ability.extra.current_joker or 'j_joker' } } }
    end,
    load = function(self, card, card_table, other_card)
        print("hey bud we're loading")
        G.E_MANAGER:add_event(Event({
            func = function()
                if not card.ability.extra.current_joker then
                    --print("police sketch doesn't have an assigned joker! resetting...")
                    slfa_reset_police_sketch_joker(card)
                end
                --print("setting up police sketch for " .. card.ability.extra.current_joker .. "...")
                slfa_setup_police_sketch_joker(card)
                return true
            end
        }))
    end,
    set_ability = function(self, card, initial, delay_sprites)
        G.E_MANAGER:add_event(Event({
            func = function()
                if card.area and card.area.config and not card.area.config.collection then
                    slfa_reset_police_sketch_joker(card)
                    slfa_setup_police_sketch_joker(card)
                end
                return true
            end
        }))
    end,
    calculate = function(self, card, context)

        if not G.slfa_saved_jokers or not G.slfa_saved_jokers[card.sort_id] then
            return nil
        end
        local effects = {}
        local joker = G.slfa_saved_jokers[card.sort_id]

        if joker then
            local ret = joker:calculate_joker(context)
            effects[#effects+1] = ret
        end

        if context.after and not context.blueprint then
            effects[#effects+1] = {
                message = localize { type = 'name_text', set = 'Joker', key = card.ability.extra.upcoming_joker },
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        --message = localize { type = 'name_text', set = 'Joker', key = card.ability.extra.current_joker },
                        func = function()
                            joker:remove_from_deck()
                            slfa_reset_police_sketch_joker(card)
                            slfa_setup_police_sketch_joker(card):add_to_deck()
                            return true
                        end,
                        trigger = 'before'
                    }))
                    return true
                end)
            }
        end

        if context.selling_self then
            SMODS.add_card {
                key = card.ability.extra.current_joker
            }
            effects[#effects+1] = {message = localize('slfa_police_sketch_gotem'), true} -- This is for Joker retrigger purposes
        end

        return SMODS.merge_effects(effects)

    end,
    add_to_deck = function(self, card, from_debuff)
        if G.slfa_saved_jokers and G.slfa_saved_jokers[card.sort_id] then
            G.slfa_saved_jokers[card.sort_id]:add_to_deck(from_debuff)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.slfa_saved_jokers and G.slfa_saved_jokers[card.sort_id] then
            G.slfa_saved_jokers[card.sort_id]:remove_from_deck(from_debuff)
        end
    end,
    update = function(self, card, dt)
        if G.slfa_saved_jokers and G.slfa_saved_jokers[card.sort_id] then
            G.slfa_saved_jokers[card.sort_id]:update(dt)
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            calc_function = function(card)
                if G.slfa_saved_jokers and G.slfa_saved_jokers[card.sort_id] then
                    local joker = G.slfa_saved_jokers[card.sort_id]
                    joker:update_joker_display(card)
                end
            end,
        }
    end
}

local find_cards_ref = SMODS.find_card
SMODS.find_card = function(key, count_debuffed)
    local ret = find_cards_ref(key, count_debuffed)
    -- discard copying jokers, which can never be in police sketch's pool
    -- this also prevents police sketch from going recursive!
    if SMODS.has_attribute(G.P_CENTERS[key], 'copying') then return ret end
    -- get all the existing police sketches
    local found_sketches = SMODS.find_card('j_slfa_police_sketch', count_debuffed)
    if next(found_sketches) then
        -- loop over them, add their current jokers to the list if matching
        for _,card in ipairs(found_sketches) do
            if G.slfa_saved_jokers and G.slfa_saved_jokers[card.sort_id] and key == card.ability.extra.current_joker then
                ret[#ret+1] = G.slfa_saved_jokers[card.sort_id]
            end
        end
    end

    return ret
end

--[[
copy of old version

local function slfa_setup_police_sketch_joker(card)
    local key = card.ability.extra.current_joker
    G.slfa_saved_jokers = G.slfa_saved_jokers or {}
    G.slfa_saved_jokers[card.sort_id] = G.slfa_saved_jokers[card.sort_id] or {}
    if not G.slfa_saved_jokers[card.sort_id][key] then
        local old_ability = copy_table(card.ability)
        local old_center = card.config.center
        local old_center_key = card.config.center_key
        card:set_ability(key, true, 'quantum')
        card:update(0.016)
        G.slfa_saved_jokers[card.sort_id][key] = SMODS.shallow_copy(card)
        G.slfa_saved_jokers[card.sort_id][key].joker_display_values = nil
        G.slfa_saved_jokers[card.sort_id][key].ability
            = copy_table(G.slfa_saved_jokers[card.sort_id][key].ability)
        for k, v in pairs({'T', 'VT', 'CT'}) do
            G.slfa_saved_jokers[card.sort_id][key][v]
                = copy_table(G.slfa_saved_jokers[card.sort_id][key][v])
        end
        G.slfa_saved_jokers[card.sort_id][key].config
            = SMODS.shallow_copy(G.slfa_saved_jokers[card.sort_id][key].config)
        card.ability = old_ability
        card.config.center = old_center
        card.config.center_key = old_center_key
        for k, v in pairs({'juice_up', 'start_dissolve', 'remove', 'flip'}) do
            G.slfa_saved_jokers[card.sort_id][key][v] = function(_, ...)
                return card[v](card, ...)
            end
        end
    end

    return G.slfa_saved_jokers[card.sort_id][key]
end

local function reset_slfa_police_sketch_joker(card)
    card.ability.extra.current_joker = SMODS.poll_object({
        set = 'Joker',
        seed = pseudorandom('slfa_police_sketch' .. G.GAME.round_resets.ante),
        filter = function(pool)
            local new_pool = {}
            for _, table in ipairs(pool) do
                if not SMODS.has_attribute(G.P_CENTERS[table.key], 'copying') then
                    new_pool[#new_pool+1] = {table.key, 'Joker'}
                end
            end
            return new_pool
        end
    })
    if type(card.ability.extra.current_joker) == 'table' then
        card.ability.extra.current_joker = card.ability.extra.current_joker[1]
    end
    sendInfoMessage("police sketch joker is now: " .. card.ability.extra.current_joker .. "", "SLFA")
    slfa_setup_police_sketch_joker(card)
end

SMODS.Joker {
    key = 'police_sketch',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 6,
        y = 3
    },
    rarity = 3,
    cost = 10,
    attributes = { 'copying', 'joker', 'hands', 'on_sell', 'generation' },
    config = { extra = { current_joker = 'j_joker' } };
    loc_vars = function(self, info_queue, card)
        local center = G.P_CENTERS[card.ability.extra.current_joker]
        local other_center = SMODS.shallow_copy(center)
        if center.loc_vars then
            other_center.loc_vars = function(self_again, info_deux, uncard)
                return center.loc_vars(self_again, info_deux, G.slfa_saved_jokers[card.sort_id][card.ability.extra.current_joker])
            end
        end
        info_queue[#info_queue+1] = other_center or G.P_CENTERS[card.ability.extra.current_joker]
        return { vars = { localize { type = 'name_text', set = 'Joker', key = card.ability.extra.current_joker } } }
    end,
    set_ability = function(self, card, initial, delay_sprites)
        G.E_MANAGER:add_event(Event({
            func = function()
                if card.area and card.area.config and not card.area.config.collection then
                    reset_slfa_police_sketch_joker(card)
                    --G.slfa_saved_jokers[card.sort_id][card.ability.extra.current_joker]:set_ability(initial, delay_sprites)
                end
                return true
            end
        }))
    end,
    calculate = function(self, card, context)

        if not G.slfa_saved_jokers or not G.slfa_saved_jokers[card.sort_id] then slfa_setup_police_sketch_joker(card) end
        local chosen_joker = G.slfa_saved_jokers[card.sort_id][card.ability.extra.current_joker]
        local effects = {}
        if chosen_joker and not context.after then
            local ret = chosen_joker:calculate_joker(context)
            if ret and type(ret) == 'table' and not ret.message_card then ret.message_card = card end
            effects[#effects+1] = ret
        end

        if context.after and not context.blueprint then
            effects[#effects+1] = {
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        --message = localize { type = 'name_text', set = 'Joker', key = card.ability.extra.current_joker },
                        func = function()
                            chosen_joker:remove_from_deck()
                            reset_slfa_police_sketch_joker(card)
                            G.slfa_saved_jokers[card.sort_id][card.ability.extra.current_joker]:add_to_deck()
                            return true
                        end
                    }))
                    return true
                end)
            }
        end

        if context.selling_self then
            SMODS.add_card {
                key = card.ability.extra.current_joker
            }
            effects[#effects+1] = {message = localize('slfa_police_sketch_gotem'), true} -- This is for Joker retrigger purposes
        end

        return SMODS.merge_effects(effects)
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.slfa_saved_jokers and G.slfa_saved_jokers[card.sort_id] then
            local joker = G.slfa_saved_jokers[card.sort_id][card.ability.extra.current_joker]
            if joker then
                joker:add_to_deck(from_debuff)
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.slfa_saved_jokers and G.slfa_saved_jokers[card.sort_id] then
            local joker = G.slfa_saved_jokers[card.sort_id][card.ability.extra.current_joker]
            if joker then
                joker:remove_from_deck(from_debuff)
            end
        end
    end,
    update = function(self, card, dt)
        if G.slfa_saved_jokers and G.slfa_saved_jokers[card.sort_id] then
            local joker = G.slfa_saved_jokers[card.sort_id][card.ability.extra.current_joker]
            if joker then
                joker:update(dt)
            end
        end
    end,
}
]]