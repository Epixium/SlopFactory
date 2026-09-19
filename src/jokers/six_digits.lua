SMODS.Joker {
    key = 'six_digits',
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {
        x = 5,
        y = 1
    },
    rarity = 2,
    cost = 6,
    attributes = { 'six', 'hand_size' },
    config = { extra = { h_size = 0, h_size_per = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.h_size_per } }
    end,
    update = function(self, card, dt)
        if not card.area or not card.area.config or card.area.config.collection then return false end
        if G.hand then
            local six_count = 0
            for _, playing_card in ipairs(G.hand.cards) do
                if playing_card:get_id() == 6 and not playing_card.debuff then
                    six_count = six_count + 1
                end
            end
            local hand_size = six_count * card.ability.extra.h_size_per
            if card.added_to_deck then
                G.hand:change_size(hand_size - card.ability.extra.h_size)
            end
            card.ability.extra.h_size = hand_size
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.h_size = 0
        local six_count = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_card:get_id() == 6 and not playing_card.debuff then
                six_count = six_count + 1
            end
        end
        card.ability.extra.h_size = six_count * card.ability.extra.h_size_per
        G.hand:change_size(card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+", },
                { ref_table = "card.ability.extra", ref_value = "h_size" },
            },
            text_config = { colour = G.C.ORANGE }
        }
    end
}