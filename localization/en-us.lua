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
                    "Earn no {C:attention}Interest",
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
                    "Earn no {C:attention}Interest",
                }
            },
            sleeve_slfa_fools_alt = {
                name = "Fool's Sleeve",
                text = {
                    "Shop has a free",
                    "{C:attention,T:p_buffoon_fools_1}#1#{}",
                    "All cards and packs in",
                    "shop cost {C:red}#2#%{} more",
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
            },
            j_slfa_grape = {
                name = "Grape",
                text = {
                    "The next {C:attention}#1#{} played",
                    "{C:spades}Spade{} cards permanently",
                    "add {C:chips}+#2#{} Chips to played",
                    "{C:attention}poker hand{} when scored",
                }
            },
            j_slfa_strawberry = {
                name = "Strawberry",
                text = {
                    "The next {C:attention}#1#{} played",
                    "{C:hearts}Heart{} cards permanently",
                    "add {C:mult}+#2#{} Mult to played",
                    "{C:attention}poker hand{} when scored",
                }
            },
            j_slfa_lemon = {
                name = "Lemon",
                text = {
                    "The next {C:attention}#1#{} played",
                    "{C:diamonds}Diamond{} cards retrigger",
                    "{C:attention}#2#{} additional times",
                }
            },
            j_slfa_blueberry = {
                name = "Blueberry",
                text = {
                    "The next {C:attention}#1#{} {C:clubs}Club{} cards",
                    "held in hand retrigger",
                    "{C:attention}#2#{} additional time",
                }
            },
            j_slfa_pimp = {
                name = "Pimp",
                text = {
                    "This Joker gains {C:mult}+#1#{} Mult",
                    "when a card with an",
                    "{C:dark_edition}Edition{} is obtained",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
                }
            },
            j_slfa_cheat_sheet = {
                name = "Cheat Sheet",
                text = {
                    "{C:attention}Straights{} containing an",
                    "{C:attention}Ace{} are considered",
                    "{C:attention}Straight Flushes{}"
                }
            },
            j_slfa_infinite_zest = {
                name = "Infinite Zest",
                text = {
                    "{C:attention}Food Jokers{} are {C:attention}rerolled{}",
                    "into other Food Jokers",
                    "when destroyed"
                }
            },
            j_slfa_max_load = {
                name = "Max Load",
                text = {
                    "{C:chips}+#1#{} Chips",
                    "{C:red}-#2#{} card",
                    "selection limit",
                }
            },
            j_slfa_cash_back = {
                name = "Cash Back",
                text = {
                    "This Joker gains {C:chips}+#1#{} Chips",
                    "when a purchase is made",
                    "with less than {C:money}$#2#{}",
                    "{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)"
                }
            },
            j_slfa_witness_protection = {
                name = "Witness Protection",
                text = {
                    "This Joker gains {C:mult}+#1#{} Mult",
                    "if {C:attention}played{} hand contains",
                    "no ranks above {C:attention}5{}",
                    "{C:inactive,s:0.8}(Aces count as 1)",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
                }
            },
            j_slfa_the_cooler_joker = {
                name = "The Cooler Joker",
                text = {
                    "{C:mult}+#1#{} Mult while {C:attention}\"Joker\"{}",
                    "is to the left",
                }
            },
            j_slfa_bargain_bin = {
                name = "Bargain Bin",
                text = {
                    "{C:blue}Common{} Jokers in",
                    "shop are {C:money}$#1#{} off",
                }
            },
            j_slfa_piggy_bank = {
                name = "Piggy Bank",
                text = {
                    "If you have exactly {C:money}$#1#{},",
                    "creates {C:attention}#2# #3#s{}",
                    "{C:red}self destructs{}"
                }
            },
            j_slfa_museum = {
                name = "Museum",
                text = {
                    "This Joker gains",
                    "{C:chips}+#1#{} Chips when a card",
                    "becomes {C:attention}Enhanced{}",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
                }
            },
            j_slfa_snow_joker = {
                name = "Snow Joker",
                text = {
                    "This Joker gains {C:chips}+#1#{} Chips",
                    "when a played card scores",
                    "Melts into {C:attention}\"Splash\"{} with",
                    "{C:chips}+#3#{} Chips in {C:attention}#2#{} hands",
                    "{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)"
                }
            },
            j_slfa_secret_room = {
                name = "Secret Room",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "add {C:attention}+#3#{} card slot to",
                    "shop after {C:attention}reroll{},",
                    "resets at end of {C:attention}shop{}",
                    "{C:inactive}(Currently {C:attention}+#4#{C:inactive} slots)"
                }
            },
            j_slfa_kerosene_lamp = {
                name = "Kerosene Lamp",
                text = {
                    "{C:attention}Multiply{} scoring values of",
                    "{C:attention}Joker{} to the left by {X:attention,C:white} X#1# {}",
                    "{C:inactive}(ex: Chips, XMult, Dollars){}"
                }
            },
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
        Spectral = {
            c_slfa_cement = {
                name = "Cement",
                text = {
                    "Add {C:dark_edition}Megaflash",
                    "and {C:attention}Eternal{} to",
                    "a random {C:attention}Joker",
                },
            }
        },
        Edition = {
            e_slfa_megaflash = {
                name = "Megaflash",
                text = {
                    "{C:dark_edition}#1#{} Joker slot",
                    "Retrigger this",
                    "card {C:attention}#2#{} times",
                },
            },
            e_slfa_megaflash_playing_card = {
                name = "Megaflash",
                text = {
                    "{C:dark_edition}#1#{} hand size",
                    "Retrigger this",
                    "card {C:attention}#2#{} times",
                },
            },
            e_slfa_fresh = {
                name = "Fresh",
                text = {
                    "When {C:attention}Blind{} is",
                    "skipped, create",
                    "{C:attention}#1#{} random {C:attention}Tags",
                },
            },
            e_slfa_fresh_playing_card = {
                name = "Fresh",
                text = {
                    "If {C:attention}Blind{} is defeated",
                    "in {C:attention}one hand{} with",
                    "this card, create",
                    "{C:attention}#1#{} random {C:attention}Tags",
                },
            },
        },
        Tag = {
            tag_slfa_megaflash = {
                name = "Megaflash Tag",
                text = {
                    "Next base edition shop",
                    "Joker is free and",
                    "becomes {C:dark_edition}Megaflash",
                },
            },
            tag_slfa_fresh = {
                name = "Fresh Tag",
                text = {
                    "Next base edition shop",
                    "Joker is free and",
                    "becomes {C:dark_edition}Fresh",
                },
            },
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
            },
            p_slfa_buffoon_fools = {
                name = "Fool's Buffoon Pack",
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{} {C:joker}Joker{} cards",
                },
            }
        }
    },
    misc = {
        v_dictionary = {
            a_slfa_plus_tag = "+#1# Tags",
        },
        dictionary = {
            k_chips = "Chips",
            k_slfa_discarded_ex = "Discarded!",
            k_slfa_downgrade_ex = "Downgrade!",
            k_slfa_debuffed_ex = "Debuffed!",
            k_slfa_showmeyourpower_ex = "SHOW ME YOUR POWER!",
            k_slfa_plus_tag = "+1 Tag",
            k_slfa_plus_card_slot = "+1 Card Slot",
            k_slfa_fuel_gauge_refuel = "Refueled!",
            k_slfa_reroll_joker = "Rerolled!",
            k_slfa_reroll_joker_up = "Rarity Up!",
            k_slfa_reroll_joker_down = "Rarity Down",
            k_slfa_speedrunner_huevo = "Huevo!",
            k_slfa_police_sketch_gotem = "Got 'Em!",
            k_slfa_snow_joker_melted = "Melted!",
            slfa_blitzkrieg_active = "Active!",
            slfa_blitzkrieg_inactive = "Inactive",
        },
        labels = {
            slfa_megaflash = "Megaflash",
            slfa_fresh = "Fresh",
        },
        poker_hands = {
            slfa_none = "None"
        },
    }
}