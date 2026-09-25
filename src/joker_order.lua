SlopFactory.COLLECTION_ORDER = {
    -- NORMAL
    "turquoise_joker",
    "cyclist",
    "anchor",
    "picky_joker",
    "shadow_puppet",
    "shopping_cart",
    "blitzkrieg",
    "lightspeed",
    "fuel_gauge",
    "kaleidoscope",
    "first_prize",
    "unlucky_joker",
    "speedrunner",
    "ace_in_the_hole",
    "white_joker",
    "base_power",
    "six_digits",
    -- VALUE GENERATOR
    "coupon_book",
    "cuisiner",
    "astrologer",
    "sad_joker",
    "defibrillator",
    "prime_day",
    "rewarded_ad",
    "platinum_card",
    "red_giant",
    -- FOOD
    "grape",
    "strawberry",
    "lemon",
    "blueberry",
    "charcuterie_board",
    -- ENHANCE, EDITION & POKER HAND
    "pimp",
    "frilly_joker",
    "fools_gold",
    "asterisk",
    "brown_bricks",
    "cheat_sheet",
    -- DEBUFF
    "debt_collector",
    "still_life",
    -- COPY
    "idea_guy",
    "jokester",
    "police_sketch"
}

local src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/jokers")
for _, file in ipairs(SlopFactory.COLLECTION_ORDER) do
    local path = "src/jokers/" .. file .. ".lua"
    if NFS.getInfo(NFS.getNormalizedPath(SMODS.current_mod.path .. path)) then
        assert(SMODS.load_file(path))()
    end
end