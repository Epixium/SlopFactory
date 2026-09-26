SMODS.Back {
    key = 'fools',
    atlas = 'backs',
    pos = {
        x = 2,
        y = 0
    },
    config = { joker_slot = 2, hand_size = -2, jokers = { 'j_joker' } },
    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.joker_slot, self.config.hand_size, localize { type = 'name_text', set = 'Joker', key = self.config.jokers[1] } } }
    end,
}