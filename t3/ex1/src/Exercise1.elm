module Exercise1 exposing (Race(..),Class(..),Armor(..),Character,wizzardd)

type Race =
            Mul
            | Thri_kreen
            | Halfing
            | Aarakocra
            | Elf

type Class =
            Artificer
            | Monk
            | Ranger
            | Barbarian

type Armor =
            Invulnerability
            | Etherealness
            | Spellguard_Shield
            | Animated_Shield

type alias Character =
    { race: Race
    , class : Class
    , armor : Armor
    }

wizzardd : Character
wizzardd =
    ( Character Elf Artificer Etherealness )