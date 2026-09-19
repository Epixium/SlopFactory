SlopFactory = {
    resetters = {}
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

--#endregion

--#region File Loading

assert(SMODS.load_file("src/utils.lua"))()

local jokers_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/jokers")
for _, file in ipairs(jokers_src) do
    assert(SMODS.load_file("src/jokers/" .. file))()
end

--#endregion

function SMODS.current_mod.reset_game_globals(run_start)
    if run_start then G.GAME.slfa = {} end
    for _, func in ipairs(SlopFactory.resetters) do
        func(run_start)
    end
end