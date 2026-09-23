SMODS.DrawStep {
    key = 'slfa',
    order = 102,
    func = function(card, _)
        if card.ability.name == "The Fool" and G.GAME.last_tarot_planet then
            if G.P_CENTERS[G.GAME.last_tarot_planet].original_mod
                and G.P_CENTERS[G.GAME.last_tarot_planet].original_mod.id == 'SlopFactory' then
                if card.ability.set == 'Tarot' then
                    card.children.center.atlas = G.ASSET_ATLAS['slfa_tarots_fd']
                end
                card.children.center:set_sprite_pos(G.P_CENTERS[G.GAME.last_tarot_planet].pos)
            end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}