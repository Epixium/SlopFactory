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
        return { vars = { card.edition.card_limit, card.edition.repetitions } }
    end,
    get_weight = function(self)
        return self.weight
    end,
    calculate = function(self, card, context)
        if (context.repetition or context.retrigger_joker_check) and context.other_card == card then
            return { repetitions = self.config.repetitions }
        end
    end,
    on_apply = function(card)
        if card.ability.set == "Base" or card.ability.set == "Enhanced" then return end
        card.T.w = card.T.w * 1.3
        card.T.h = card.T.h * 1.3
        if card.children.floating_sprite then
            card.children.floating_sprite.T.w = card.children.floating_sprite.T.w * 1.3
            card.children.floating_sprite.T.h = card.children.floating_sprite.T.h * 1.3
        end
    end,
    on_remove = function(card)
        if card.ability.set == "Base" or card.ability.set == "Enhanced" then return end
        card.T.w = card.T.w / 1.3
        card.T.h = card.T.h / 1.3
        if card.children.floating_sprite then
            card.children.floating_sprite.T.w = card.children.floating_sprite.T.w / 1.3
            card.children.floating_sprite.T.h = card.children.floating_sprite.T.h / 1.3
        end
    end,
    on_load = function(card)
        if card.ability.set == "Base" or card.ability.set == "Enhanced" then return end
        card.T.w = card.T.w * 1.3
        card.T.h = card.T.h * 1.3
        if card.children.floating_sprite then
            card.children.floating_sprite.T.w = card.children.floating_sprite.T.w / 1.3
            card.children.floating_sprite.T.h = card.children.floating_sprite.T.h / 1.3
        end
    end,
}

JokerDisplay.Edition_Definitions["e_slfa_megaflash"] = {
    condition_function = function(card)
        return not card.debuff and card.edition and card.edition.key and card.edition.key == "e_slfa_megaflash"
    end,
    mod_function = function(card)
        return { }
    end,
    retrigger_joker_function = function(card)
        return card.edition.config.repetitions
    end
}