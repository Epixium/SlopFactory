SMODS.Back {
    key = 'fools',
    atlas = 'backs',
    pos = {
        x = 2,
        y = 0
    },
    config = { joker_slot = 2, no_interest = true },
    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.joker_slot } }
    end,
}