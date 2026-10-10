SlopFactory = {
    config = SMODS.current_mod.config,
    resetters = {
        function(run_start)
            if run_start then
                G.GAME.slfa = {}
            end
        end
    },
    calculate_steps = {}
}

SMODS.current_mod.optional_features = {
    quantum_enhancements = true,
    post_trigger = true,
    retrigger_joker = true
}

--#region Atlases

SMODS.Atlas {
    key = 'jokers',
    path = 'jokers.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'placeholders',
    path = 'placeholders.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'tarots',
    path = 'tarots.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'spectrals',
    path = 'spectrals.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'backs',
    path = 'backs.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'sleeves',
    path = 'sleeves.png',
    px = 73,
    py = 95
}

SMODS.Atlas {
    key = 'boosters',
    path = 'boosters.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'tags',
    path = 'tags.png',
    px = 34,
    py = 34
}

--#endregion

--#region Attributes

SMODS.Attribute { key = 'reroll_joker' }
SMODS.Attribute { key = 'play_limit' }
SMODS.Attribute { key = 'discard_limit' }
SMODS.Attribute { key = 'value_manip' }
SMODS.Attribute { key = 'sticker' }

--#endregion

--#region File Loading

assert(SMODS.load_file("src/utils.lua"))()

assert(SMODS.load_file("src/joker_order.lua"))()
--SlopFactory.load_src('jokers')
SlopFactory.load_src('editions')
SlopFactory.load_src('tarots')
SlopFactory.load_src('spectrals')
SlopFactory.load_src('boosters')
SlopFactory.load_src('tags')
SlopFactory.load_src('backs')
if next(SMODS.find_mod('CardSleeves')) then SlopFactory.load_src('sleeves') end

--#endregion

function SMODS.current_mod.reset_game_globals(run_start)
    for _, func in ipairs(SlopFactory.resetters) do
        func(run_start)
    end
end

SMODS.current_mod.calculate = function(self, context)
    local effects = {}
    for _, func in ipairs(SlopFactory.calculate_steps) do
        local ret = func(context)
        if ret then
            effects[#effects+1] = ret
        end
    end
    if #effects == 0 then return end
    return SMODS.merge_effects(effects)
end


SMODS.current_mod.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, align = "cm", padding = 0.1, colour = G.C.BLACK, minw = 8}, nodes = {
        {n = G.UIT.R, config = {align = "cm", padding = 0}, nodes = {
            {n = G.UIT.C, config = {align = "c", padding = 0}, nodes = {
                {n = G.UIT.T, config = {text = "Enable Bloat", colour = G.C.UI.TEXT_LIGHT, scale = 0.35}}
            }},
            {n = G.UIT.C, config = {align = "cl", padding = 0.05}, nodes = {
                create_toggle{ col = true, label = "", scale = 0.85, w = 0, shadow = true, ref_table = SlopFactory.config, ref_value = 'bloat_enabled' }
            }}
        }}
    }}
end

local add_to_pool_ref = SMODS.add_to_pool
function SMODS.add_to_pool(prototype_obj, args)
    if not SlopFactory.config.bloat_enabled and prototype_obj.slfa_bloat then
        return false
    end
    return add_to_pool_ref(prototype_obj, args)
end

local hide_from_collection_ref = SMODS.hide_from_collection
function SMODS.hide_from_collection(prototype_obj, args)
    if not SlopFactory.config.bloat_enabled and prototype_obj.slfa_bloat then
        return true
    end
    return hide_from_collection_ref(prototype_obj, args)
end