return {
    descriptions = {
        Back = {
            b_slfa_orange = {
                name = "Orange Deck",
                text = {
                    "After defeating",
                    "each {C:attention}Blind{}, {C:attention}reroll{} the",
                    "rightmost Joker",
                },
            },
            b_slfa_fools = {
                name = "Fool's Deck",
                text = {
                    "{C:attention}+#1#{} Joker slots",
                    "{C:red}#2#{} hand size",
                    "Start with {C:attention,T:j_joker}#3#{}"
                }
            }
        },
        Sleeve = {
            sleeve_slfa_orange = {
                name = "Orange Sleeve",
                text = {
                    "After defeating",
                    "each {C:attention}Blind{}, {C:attention}reroll{} the",
                    "rightmost Joker",
                },
            },
            sleeve_slfa_orange_alt = {
                name = "Orange Sleeve",
                text = {
                    "After {C:attention}discard{}, {C:attention}reroll{}",
                    "the rightmost Joker",
                },
            },
            sleeve_slfa_fools = {
                name = "Fool's Sleeve",
                text = {
                    "{C:attention}+#1#{} Joker slots",
                    "{C:red}#2#{} hand size",
                    "Start with {C:attention,T:j_joker}#3#{}"
                }
            },
            sleeve_slfa_fools_alt = {
                name = "Fool's Sleeve",
                text = {
                    "Shop has a free",
                    "{C:attention,T:p_buffoon_jumbo_1}#1#{}",
                    "{C:red}#2#{} Booster slot"
                }
            },
        },
        Joker = {
            j_slfa_turquoise_joker = {
                name = "Turquoise Joker",
                text = {
                    "{C:chips}+#1#{} Chips per hand played",
                    "{C:red}-#2#{} Chips per card held in hand",
                    "{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)"
                }
            },
            j_slfa_cyclist = {
                name = "Cyclist",
                text = {
                    "This Joker gains {C:chips}+#1#{} Chips",
                    "per {C:attention}consecutive{} higher tier",
                    "{C:attention}poker hand{} played",
                    "{C:inactive}(ex: {C:attention}Pair{C:inactive}, {C:attention}Straight{C:inactive}, {C:attention}Flush{C:inactive})",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips, {C:attention}#3#{C:inactive})"
                }
            },
            j_slfa_shadow_puppet = {
                name = "Shadow Puppet",
                text = {
                    "{C:mult}+#1#{} Mult for each",
                    "remaining {C:attention}hand{}",
                }
            },
            j_slfa_picky_joker = {
                name = "Picky Joker",
                text = {
                    "{C:mult}+#1#{} Mult",
                    "{C:green}#2# in #3#{} chance to",
                    "discard all {C:attention}unenhanced{}",
                    "cards held in hand"
                }
            },
            j_slfa_anchor = {
                name = "Anchor",
                text = {
                    "{C:mult}+#1#{} Mult",
                    "{C:attention}-#2#{} hand size"
                }
            },
            j_slfa_shopping_cart = {
                name = "Shopping Cart",
                text = {
                    "This Joker gains {C:mult}Mult{}",
                    "equal to the {C:attention}first purchase{}",
                    "made in the {C:attention}shop{}",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
                }
            },
            j_slfa_coupon_book = {
                name = "Coupon Book",
                text = {
                    "Earn {C:money}$#1#{} at end of",
                    "round per {C:attention}Voucher{}",
                    "redeemed this run",
                    "{C:inactive}(Currently {C:money}$#2#{C:inactive})"
                }
            },
            j_slfa_frilly_joker = {
                name = "Frilly Joker",
                text = {
                    "{C:attention}Bonus{} and {C:attention}Mult{}",
                    "cards count as the",
                    "same {C:attention}Enhancement{}"
                }
            },
            j_slfa_asterisk = {
                name = "Asterisk",
                text = {
                    "The last {C:attention}Wild{}",
                    "card in played hand",
                    "counts as {C:attention}any rank{}",
                    "in {C:attention}poker hands{}",
                    "{C:inactive,s:0.8}(ex: {C:attention,s:0.8}K K K 2 Wild{}",
                    "{C:inactive,s:0.8}-> {C:attention,s:0.8}Four of a Kind{C:inactive,s:0.8}){}"
                }
            },
            j_slfa_idea_guy = {
                name = "Idea Guy",
                text = {
                    "{C:attention}Joker{} to the right",
                    "copies ability of {C:attention}Joker{}",
                    "to the left instead",
                    "of using its own"
                }
            },
            j_slfa_unlucky_joker = {
                name = "Unlucky Joker",
                text = {
                    "This Joker gains {C:chips}+#1#{} Chips",
                    "when a {C:attention}listed{} {C:green}probability{} {C:red}fails{}",
                    "{C:red}-#2#{} Chips when a {C:attention}listed{}",
                    "{C:green}probability{} succeeds",
                    "{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)"
                }
            },
            j_slfa_blitzkrieg = {
                name = "Blitzkrieg",
                text = {
                    "{X:red,C:white} X#1# {} Mult if {C:attention}last round{}",
                    "was won in {C:attention}one hand{}",
                    "{C:inactive}#2#{}"
                }
            },
            j_slfa_lightspeed = {
                name = "Lightspeed",
                text = {
                    "{X:mult,C:white} X#1# {} Mult on {C:attention}first{}",
                    "{C:attention}hand{} of round if no",
                    "{C:attention}discards{} are used"
                }
            },
            j_slfa_fuel_gauge = {
                name = "Fuel Gauge",
                text = {
                    "{X:mult,C:white} X#1# {} Mult, loses {X:mult,C:white} X#2# {} Mult",
                    "at end of round",
                    "Resets when a Joker is {C:attention}sold{}",
                    "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)"
                }
            },
            j_slfa_cuisiner = {
                name = "Cuisiner",
                text = {
                    "Earn {C:money}$#1#{} per",
                    "remaining {C:attention}discard{}",
                    "at end of round",
                    "{C:attention}-#2#{} hand size"
                }
            },
            j_slfa_debt_collector = {
                name = "Debt Collector",
                text = {
                    "Earn {C:money}$#1#{} per",
                    "{C:attention}debuffed{} card played",
                    "{V:1}#2#{} cards are {C:attention}debuffed{},",
                    "suit changes every hand"
                }
            },
            j_slfa_kaleidoscope = {
                name = "Kaleidoscope",
                text = {
                    "Retrigger all cards",
                    "with a previous scoring",
                    "card's {C:attention}rank{} and {C:attention}suit{}",
                }
            },
            j_slfa_first_prize = {
                name = "First Prize",
                text = {
                    "Retrigger all played cards",
                    "with the {C:attention}first rank drawn{}",
                    "this round {C:attention}#1#{} additional times",
                    "{C:inactive}(Currently {C:attention}#2#{C:inactive}){}"
                }
            },
            j_slfa_defibrillator = {
                name = "Defibrillator",
                text = {
                    "If {C:attention}final hand{} of round",
                    "has only {C:attention}2{} cards, convert",
                    "the {C:attention}left{} card into the",
                    "{C:attention}right{} card and retrigger",
                    "both {C:attention}#1#{} additional times"
                }
            },
            j_slfa_six_digits = {
                name = "Six Digits",
                text = {
                    "Each {C:attention}6{} held in hand",
                    "gives {C:attention}+#1#{} hand size"
                }
            },
            j_slfa_prime_day = {
                name = "Prime Day",
                text = {
                    "Each played {C:attention}2{}, {C:attention}3{},",
                    "{C:attention}5{}, or {C:attention}7{} has a {C:green}#1# in #2#{}",
                    "chance to create a",
                    "free {C:attention}#3#{}",
                    "when scored",
                }
            },
            j_slfa_astrologer = {
                name = "Astrologer",
                text = {
                    "{C:green}#1# in #2#{} chance to create",
                    "a {C:tarot}Tarot{} card when a",
                    "{C:planet}Planet{} card is used"
                }
            },
            j_slfa_brown_bricks = {
                name = "Brown Bricks",
                text = {
                    "Allows {C:attention}Full Houses{} to be",
                    "made with {C:attention}Stone{} cards in",
                    "place of any {C:attention}used rank{}",
                    "{C:inactive}(ex. {C:attention}9 {C:inactive}S S {C:attention}4 {C:inactive}S){}"
                }
            },
            j_slfa_fools_gold = {
                name = "Fool's Gold",
                text = {
                    "{C:attention}Unenhanced{} cards",
                    "count as {C:attention}Gold{} cards",
                    "{C:attention}Gold{} cards give {X:mult,C:white} X#1# {} Mult",
                    "while held in hand"
                }
            },
            j_slfa_still_life = {
                name = "Still Life",
                text = {
                    "{C:attention}Face{} cards are {C:attention}debuffed{}",
                    "Each played {C:attention}face{} card has",
                    "a {C:green}#1# in #2#{} chance to give",
                    "{C:attention}+#3#{} hand size for the round",
                    "{C:inactive}(Currently {C:attention}+#4#{C:inactive} hand size){}"
                }
            },
            j_slfa_speedrunner = {
                name = "Speedrunner",
                text = {
                    "{C:chips}+#1#{} Chips",
                    "When {C:attention}Small Blind{} or",
                    "{C:attention}Big Blind{} is selected,",
                    "{C:red}self destructs{}"
                }
            },
            j_slfa_ace_in_the_hole = {
                name = "Ace in the Hole",
                text = {
                    "Destroy all scoring {C:attention}Aces{}",
                    "This Joker gains {X:mult,C:white} X#1# {} Mult",
                    "when an {C:attention}Ace{} is destroyed",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
                }
            },
            j_slfa_base_power = {
                name = "Base Power",
                text = {
                    "Level {C:attention}1{} {C:attention}poker hands{}",
                    "have {C:chips}+#1#{} Base Chips",
                    "and {X:mult,C:white} X#2# {} Base Mult",
                }
            },
            j_slfa_red_giant = {
                name = "Red Giant",
                text = {
                    "This Joker gains {X:mult,C:white} X#1# {} Mult",
                    "for each {C:attention}consumable{} used",
                    "Resets when a {C:attention}consumable{} is sold",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
                }
            },
            j_slfa_white_joker = {
                name = "White Joker",
                text = {
                    "{X:mult,C:white} X#1# {} Mult for each scoring",
                    "{C:hearts}#2#{} or {C:diamonds}#3#{} card",
                    "After hand or discard,",
                    "{C:hearts}#2#{} or {C:diamonds}#3#{} cards",
                    "in hand are {C:attention}debuffed{}"
                }
            },
            j_slfa_sad_joker = {
                name = "Sad Joker",
                text = {
                    "Create a {C:planet}Planet{} card",
                    "if played hand scores",
                    "{C:purple}#1#{} chips or less"
                }
            },
            j_slfa_rewarded_ad = {
                name = "Rewarded Ad",
                text = {
                    "Lose {C:money}$#1#{} and {C:attention}reroll{}",
                    "the {C:attention}Joker{} to the right",
                    "at end of round"
                }
            },
            j_slfa_jokester = {
                name = "Jokester",
                text = {
                    "Copies ability of",
                    "all {C:attention}Jokers{} with",
                    "{C:attention}'Joker'{} in their name",
                }
            },
            j_slfa_platinum_card = {
                name = "Platinum Card",
                text = {
                    "{C:attention}+#1#{} card slots",
                    "available in shop",
                    "{C:green}Rerolls{} cost {C:money}$#2#{} more"
                }
            },
            j_slfa_police_sketch = {
                name = "Police Sketch",
                text = {
                    "Mimics a random",
                    "{C:attention}unowned{} Joker",
                    "Sell this card to gain",
                    "a {C:attention}copy{} of that Joker",
                    "{s:0.8}Joker changes every hand{}",
                    "{C:inactive}(Currently {C:attention}#1#{C:inactive})"
                }
            }
        },
        Tarot = {
            c_slfa_branch = {
                name = "The Branch",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "{C:attention}reroll{} selected Joker",
                }
            }
        },
        Other = {
            slfa_reroll_joker = {
                name = "Joker Rerolling",
                text = {
                    "Replace a Joker",
                    "with a new one",
                    "{C:attention,s:0.8}#1#%{s:0.8} chance to {C:green,s:0.8}increase{s:0.8} rarity",
                    "{C:attention,s:0.8}#2#%{s:0.8} chance to {C:red,s:0.8}decrease{s:0.8} rarity",
                    "{C:inactive,s:0.7}(Retains Edition and Stickers)",
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_discarded_ex = "Discarded!",
            k_downgrade_ex = "Downgrade!",
            k_debuffed_ex = "Debuffed!",
            k_showmeyourpower_ex = "SHOW ME YOUR POWER!",
            k_plus_tag = "+1 Tag",
            slfa_blitzkrieg_active = "Active!",
            slfa_blitzkrieg_inactive = "Inactive",
            slfa_fuel_gauge_refuel = "Refueled!",
            slfa_rewarded_ad_reroll = "Rerolled!",
            slfa_rewarded_ad_rarity_up = "Rarity Up!",
            slfa_rewarded_ad_rarity_down = "Rarity Down",
            slfa_speedrunner_huevo = "Huevo!",
            slfa_police_sketch_gotem = "Got 'Em!"
        },
        poker_hands = {
            slfa_none = "None"
        },
    }
}