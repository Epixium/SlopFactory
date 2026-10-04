local function multiply_ret_values(ret, mult)
    for k, v in pairs(ret) do
        --local is_scoring = false
        if type(v) == "number" then
            ret[k] = v * mult
            if ret.message then
                ret.message = string.gsub(ret.message,
                    "%d+%.?%d*",
                    function(match)
                        return tostring(tonumber(match) * mult)
                    end
                )
            end
        end
    end
    if ret.extra then
        ret.extra = multiply_ret_values(ret.extra, mult)
    end
    return ret
end

SMODS.Joker {
    key = 'kerosene_lamp',
    atlas = 'jokers',
    pos = {
        x = 7,
        y = 5
    },
    rarity = 3,
    cost = 10,
    attributes = { 'position', 'value_manip' },
    config = { extra = { value_mult = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.value_mult } }
    end,
    calculate = function(self, card, context)
        if context.post_trigger and context.other_card and context.other_card.ability and context.other_card.ability.set == 'Joker' then
            local other_joker
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i - 1] end
            end
            if context.other_card == other_joker then
                for joker, ret in pairs(context.other_ret) do
                    context.other_ret[joker] = multiply_ret_values(ret, card.ability.extra.value_mult)
                    --local is_scoring = false
                    --[[
                    for param_key, param in pairs(SMODS.Scoring_Parameters) do
                        if k == param_key then is_scoring = true; break; end
                        for _, calc_key in ipairs(param.calculation_keys) do
                            if k == calc_key then is_scoring = true; break; end
                        end
                        if is_scoring then break end
                    end
                    if is_scoring then
                        --print("multiplying " .. k)
                        context.other_ret[joker][k] = v * card.ability.extra.value_mult
                        if context.other_ret[joker].message then
                            context.other_ret[joker].message = string.gsub(context.other_ret[joker].message,
                                "%d+%.?%d*",
                                function(match)
                                    return tostring(tonumber(match) * card.ability.extra.value_mult)
                                end
                            )
                        end
                    end]]
                end
            end
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {}
    end,
}