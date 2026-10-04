SMODS.Joker {
    key = 'max_load',
    atlas = 'jokers',
    pos = {
        x = 6,
        y = 4
    },
    rarity = 1,
    cost = 4,
    attributes = { 'chips', 'play_limit', 'discard_limit' },
    config = { extra = { chips = 200, select = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.select } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.change_play_limit(-card.ability.extra.select)
		SMODS.change_discard_limit(-card.ability.extra.select)
    end,
    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_play_limit(card.ability.extra.select)
		SMODS.change_discard_limit(card.ability.extra.select)
        if not G.GAME.before_play_buffer then
			G.hand:unhighlight_all()
		end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.CHIPS }
        }
    end,
}