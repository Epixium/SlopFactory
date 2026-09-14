return {
    descriptions = {
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
            j_slfa_shopping_cart = {
                name = "Shopping Cart",
                text = {
                    "This Joker gains {C:mult}Mult{}",
                    "equal to the {C:attention}first purchase{}",
                    "made in the {C:attention}shop{}",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
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
            j_slfa_ace_in_the_hole = {
                name = "Ace in the Hole",
                text = {
                    "Destroy all scoring {C:attention}Aces{}",
                    "This Joker gains {X:mult,C:white} X#1# {} Mult",
                    "when an {C:attention}Ace{} is destroyed",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
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
                    "Lose {C:money}$#1#{} and reroll",
                    "the {C:attention}Joker{} to the right",
                    "at end of round"
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_discarded_ex = "Discarded!",
            k_downgrade_ex = "Downgrade!",
            k_showmeyourpower_ex = "SHOW ME YOUR POWER!",
            k_plus_tag = "+1 Tag",
            slfa_blitzkrieg_active = "Active!",
            slfa_blitzkrieg_inactive = "Inactive",
            slfa_fuel_gauge_refuel = "Refueled!",
            slfa_rewarded_ad_reroll = "Rerolled!",
            slfa_rewarded_ad_rarity_up = "Rarity Up!",
            slfa_rewarded_ad_rarity_down = "Rarity Down",
        },
        poker_hands = {
            slfa_none = "None"
        },
    }
}