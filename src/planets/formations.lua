SMODS.Atlas {
    key = 'formations',
    path = 'planets.png',
    px = 71,
    py = 95
}

local function formation_builder(key, x, y, hand_type, xchips, mult, badge)
    SMODS.PokerHand:take_ownership(hand_type, {
        slfa_l_xchips = xchips,
        slfa_l_mmult = mult
    }, true)
    SMODS.Consumable {
        key = key,
        set = "Planet",
        cost = 3,
        weight = 5,
        atlas = "formations",
        pos = { x = x, y = y },
        slfa_formation = true,
        unlocked = false,
        attributes = { "hand_type", "hand_level", "space" },
        config = { hand_type = hand_type, formation = true },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    G.GAME.hands[card.ability.hand_type].level,
                    localize(card.ability.hand_type, 'poker_hands'),
                    G.GAME.hands[card.ability.hand_type].slfa_l_xchips,
                    math.ceil(G.GAME.hands[card.ability.hand_type].chips * (G.GAME.hands[card.ability.hand_type].slfa_l_xchips - 1)),
                    G.GAME.hands[card.ability.hand_type].slfa_l_mmult,
                    colours = { (G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)]) }
                }
            }
        end,
        locked_loc_vars = function(self, info_queue, card)
            return { vars = { localize(hand_type, 'poker_hands'), 5 } }
        end,
        use = function(self, card, area, copier)
            SMODS.upgrade_poker_hands({
                hands = card.ability.hand_type,
                parameters = {'chips', 'mult'},
                level_up = 1,
                func = function(base, hand, parameter, level_up)
                    if parameter == 'chips' then
                        return math.ceil(base * (G.GAME.hands[hand].slfa_l_xchips ^ level_up))
                    elseif parameter == 'mult' then
                        return base - G.GAME.hands[hand].slfa_l_mmult * level_up
                    end
                    return base
                end,
                from = card
            })
        end,
        set_card_type_badge = badge and function(self, card, badges)
            badges[#badges + 1] = create_badge(localize(badge),
                get_type_colour(card.config.center or card.config, card), SMODS.ConsumableTypes.Planet.text_colour,
                1.2)
        end,
        in_pool = function(self, args)
            return G.GAME.hands[hand_type].level >= 3
        end,
        check_for_unlock = function(self, args)
            return args.type == 'upgrade_hand' and args.hand == hand_type and args.level >= 5
        end,
    }
end

formation_builder('caloris', 1, 0,
    'Pair', 1.3, 3, 'k_slfa_formation')
formation_builder('aphrodite', 1, 0,
    'Three of a Kind', 1.4, 4, 'k_slfa_formation')
formation_builder('mariana', 1, 0,
    'Full House', 1.4, 8, 'k_slfa_formation')
formation_builder('olympus', 1, 0,
    'Four of a Kind', 1.2, 4, 'k_slfa_formation')
formation_builder('red_spot', 1, 0,
    'Flush', 1.3, 5, 'k_slfa_formation')
formation_builder('hexagon', 1, 0,
    'Straight', 1.1, 1, 'k_slfa_formation')
formation_builder('dark_spot', 1, 0,
    'Two Pair', 1.2, 1, 'k_slfa_formation')
formation_builder('iris', 1, 0,
    'Straight Flush', 2, 6, 'k_slfa_formation')
formation_builder('dune_fields', 2, 0,
    'High Card', 1.4, 3, 'k_slfa_formation')
formation_builder('cross', 1, 0,
    'Five of a Kind', 1.3, 5, 'k_slfa_formation_q')
formation_builder('bright_spot', 1, 0,
    'Flush House', 1.2, 2, 'k_slfa_formation')
formation_builder('penitentes', 1, 0,
    'Flush Five', 1.5, 10, 'k_slfa_formation_q')



SMODS.Booster:take_ownership_by_kind('Celestial', {
    create_card = function(self, card, i)
        local _card
        if G.GAME.used_vouchers.v_telescope and i == 1 then
            local _planet, _hand, _tally = nil, nil, 0
            for k, v in ipairs(G.handlist) do
                if SMODS.is_poker_hand_visible(v) and G.GAME.hands[v].played > _tally then
                    _hand = v
                    _tally = G.GAME.hands[v].played
                end
            end
            if _hand then
                local _planets = {}
                for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                    if v.config.hand_type == _hand and (not v.in_pool or v:in_pool()) then
                        _planets[#_planets+1] = v.key
                    end
                end
                _planet = SMODS.poll_object({ pool = _planets, seed = 'slfa_tele_planet_choice' })
            end
            _card = {set = "Planet", area = G.pack_cards, skip_materialize = true, soulable = true, key = _planet, key_append = "pl1"}
        else
            _card = {set = "Planet", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "pl1"}
        end
        return _card
    end,
})

