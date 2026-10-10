SlopFactory = {
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
    key = 'tarots_fd',
    path = 'tarots_fd.png',
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

if next(SMODS.find_mod("FoolsDisplay")) then
    assert(SMODS.load_file("src/fools_display.lua"))()
end

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