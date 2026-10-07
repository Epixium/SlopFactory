SMODS.Shader({ key = 'halftone', path = 'halftone.fs' })
SMODS.Sound { key = 'halftone', path = 'halftone.ogg' }

SMODS.Edition {
    key = 'halftone',
    shader = 'halftone',
    config = { extra = { dollars = 1, dollars_per = 1, trigger_count = 0 } },
    in_shop = true,
    weight = 6,
    extra_cost = 4,
    sound = { sound = 'slfa_halftone', per = 1.01, vol = 1.05 },
    attributes = { 'economy', 'scaling', },
    loc_vars = function(self, info_queue, card)
        if card.edition and card.edition.extra then
            return { vars = { card.edition.extra.dollars, card.edition.extra.dollars_per },
                    key = SMODS.is_playing_card(card) and self.key .. "_playing_card" or self.key }
        else
            return { vars = { self.config.dollars, self.config.dollars_per },
                    key = SMODS.is_playing_card(card) and self.key .. "_playing_card" or self.key }
        end
    end,
    get_weight = function(self)
        return self.weight
    end,
    calculate = function(self, card, context)
        if context.post_trigger and context.other_card == card then
            if card.ability.set == 'Joker' then
                if not context.other_context.end_of_round then
                    card.edition.extra.trigger_count = card.edition.extra.trigger_count + 1;
                end
            else
                if context.other_context.individual and context.other_context.other_card == card and context.other_context.cardarea == G.play then
                    card.edition.extra.trigger_count = card.edition.extra.trigger_count + 1;
                end
            end
        end
        if context.end_of_round and context.main_eval then
            if card.edition.extra.trigger_count == 0 then
                SMODS.scale_card(card, {
                    ref_table = card.edition.extra,
                    ref_value = 'dollars',
                    scalar_value = 'dollars_per'
                })
            end
            card.edition.extra.trigger_count = 0
        end
        if context.modify_final_cashout then
            return {
                modify = card.edition.extra.dollars
            }
        end
        if context.playing_card_end_of_round and context.cardarea == G.hand then
            if card.edition.extra.trigger_count == 0 then
                SMODS.scale_card(card, {
                    ref_table = card.edition.extra,
                    ref_value = 'dollars',
                    scalar_value = 'dollars_per'
                })
            end
            card.edition.extra.trigger_count = 0
            return { dollars = card.edition.extra.dollars }
        end
    end,
}