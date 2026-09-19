SMODS.Joker {
    key = 'anchor',
    atlas = 'jokers',
    pos = {
        x = 8,
        y = 2
    },
    rarity = 1,
    cost = 4,
    attributes = { 'mult', 'hand_size' },
    config = { extra = { mult = 20, h_size = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.h_size } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        print('PENIS')
        G.hand:change_size(-card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        print('VAGINA')
        G.hand:change_size(card.ability.extra.h_size)
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.MULT }
        }
    end,
}