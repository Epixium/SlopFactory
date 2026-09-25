SMODS.Back {
    key = 'fools',
    atlas = 'backs',
    pos = {
        x = 2,
        y = 0
    },
    config = { joker_slot = 3, hand_size = -3, blind_ante = 0 },
    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.joker_slot, self.config.hand_size, self.config.blind_ante } }
    end,
    apply = function(self, back)
        ease_ante(self.config.blind_ante - G.GAME.round_resets.blind_ante)
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
        G.GAME.round_resets.blind_ante = self.config.blind_ante
    end
}