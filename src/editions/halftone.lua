SMODS.Shader({ key = 'halftone', path = 'halftone.fs' })
SMODS.Sound { key = 'halftone', path = 'halftone.ogg' }

SMODS.Edition {
    key = 'halftone',
    shader = 'halftone',
    config = { extra = { discard_limit = 1, active = false } },
    in_shop = true,
    weight = 6,
    extra_cost = 4,
    sound = { sound = 'slfa_halftone', per = 1.01, vol = 1.05 },
    attributes = { 'discard_limit' },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.edition.extra.discard_limit },
                key = SMODS.is_playing_card(card) and self.key .. "_playing_card" or self.key }
    end,
    get_weight = function(self)
        return self.weight
    end,
    calculate = function(self, card, context)
        if SMODS.is_playing_card(card) then
            if context.hand_drawn and SMODS.is_playing_card(card) then
                for _, playing_card in ipairs(context.hand_drawn) do
                    if playing_card == card then
                        SMODS.change_discard_limit(card.edition.extra.discard_limit)
                        card.edition.extra.active = true
                        break
                    end
                end
            end
            if card.edition.extra.active then
                if context.main_scoring and context.cardarea == G.play then
                    for _, playing_card in ipairs(context.full_hand) do
                        if playing_card == card then
                            SMODS.change_discard_limit(-card.edition.extra.discard_limit)
                            card.edition.extra.active = false
                            break
                        end
                    end
                end
                if context.discard and context.other_card == card then
                    SMODS.change_discard_limit(-card.edition.extra.discard_limit)
                    card.edition.extra.active = false
                end
                if context.end_of_round and card.edition.extra.active then
                    SMODS.change_discard_limit(-card.edition.extra.discard_limit)
                    card.edition.extra.active = false
                end
            end
        end
    end,
    add_to_deck = function(self, card, context)
        SMODS.change_discard_limit(card.edition.extra.discard_limit)
        card.edition.extra.active = true
    end,
    remove_from_deck = function(self, card, context)
        if card.edition.extra.active then
            SMODS.change_discard_limit(-card.edition.extra.discard_limit)
            card.edition.extra.active = false
            if not G.GAME.before_play_buffer then
                G.hand:unhighlight_all()
            end
        end
    end,
    on_apply = function(card)
        if card.added_to_deck and not SMODS.is_playing_card(card) then
            SMODS.change_discard_limit(card.edition.extra.discard_limit)
            card.edition.extra.active = true
        end
    end,
    on_remove = function(card)
        if card.added_to_deck and card.edition.extra.active then
            SMODS.change_discard_limit(-card.edition.extra.discard_limit)
            card.edition.extra.active = false
            if not G.GAME.before_play_buffer then
                G.hand:unhighlight_all()
            end
        end
    end,
    --[[
    on_apply = function(card)
        card.T.w = card.T.w * 2.5
        card.T.h = card.T.h * 2.5
    end,]]
}