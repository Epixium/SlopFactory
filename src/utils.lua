-- Update the debuffed state of all playing cards.
SlopFactory.update_debuffed = function()
    G.E_MANAGER:add_event(Event {
        func = function()
            for k, v in ipairs(G.playing_cards) do
                G.GAME.blind:debuff_card(v)
            end
            return true
        end
    })
end