SlopFactory = {
    resetters = {
        function(run_start)
            if run_start then
                G.GAME.slfa = {}
            end
        end
    }
}

SMODS.current_mod.optional_features = {
    quantum_enhancements = true,
    post_trigger = true
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

--#endregion

--#region Attributes

SMODS.Attribute {
    key = 'reroll_joker'
}

--#endregion

--#region File Loading

assert(SMODS.load_file("src/utils.lua"))()

assert(SMODS.load_file("src/joker_order.lua"))()
--SlopFactory.load_src('jokers')
SlopFactory.load_src('tarots')
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