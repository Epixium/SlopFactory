SMODS.Shader({ key = 'megaflash', path = 'megaflash.fs' })
SMODS.Sound { key = 'megaflash', path = 'megaflash.ogg' }

SMODS.Edition {
    key = 'megaflash',
    shader = 'megaflash',
    config = { card_limit = -1, repetitions = 2 },
    in_shop = true,
    weight = 3,
    extra_cost = 5,
    sound = { sound = 'slfa_megaflash', per = 1.05, vol = 1.5 },
    attributes = { 'joker_slot', 'retrigger', },
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.card_limit, self.config.repetitions },
                key = SMODS.is_playing_card(card) and self.key .. "_playing_card" or self.key }
    end,
    get_weight = function(self)
        return self.weight
    end,
    calculate = function(self, card, context)
        if (context.repetition or context.retrigger_joker_check) and context.other_card == card then
            return { repetitions = G.P_CENTERS[card.edition.key].config.repetitions }
        end
    end,
    on_apply = function(card)
        if SMODS.is_playing_card(card) then return end
        card.T.w = card.T.w * 1.3
        card.T.h = card.T.h * 1.3
        if card.children.floating_sprite then
            card.children.floating_sprite.T.w = card.children.floating_sprite.T.w * 1.3
            card.children.floating_sprite.T.h = card.children.floating_sprite.T.h * 1.3
        end
    end,
    on_remove = function(card)
        if SMODS.is_playing_card(card) then return end
        card.T.w = card.T.w / 1.3
        card.T.h = card.T.h / 1.3
        if card.children.floating_sprite then
            card.children.floating_sprite.T.w = card.children.floating_sprite.T.w / 1.3
            card.children.floating_sprite.T.h = card.children.floating_sprite.T.h / 1.3
        end
    end,
    on_load = function(card)
        if SMODS.is_playing_card(card) then return end
        card.T.w = card.T.w * 1.3
        card.T.h = card.T.h * 1.3
        if card.children.floating_sprite then
            card.children.floating_sprite.T.w = card.children.floating_sprite.T.w / 1.3
            card.children.floating_sprite.T.h = card.children.floating_sprite.T.h / 1.3
        end
    end,
}

if JokerDisplay then
   JokerDisplay.Edition_Definitions["e_slfa_megaflash"] = {
        condition_function = function(card)
            return not card.debuff and card.edition and card.edition.key and card.edition.key == "e_slfa_megaflash"
        end,
        mod_function = function(card)
            return { }
        end,
        retrigger_joker_function = function(card)
            return card.edition.repetitions
        end
    }
end