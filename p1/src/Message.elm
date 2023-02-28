module Message exposing (KeyInput(..), Msg(..))

{- All the messages we use in our game -}

import Random exposing (Seed)



-- Key Direction and MusicChange


type KeyInput
    = Left
    | Right
    | Up
    | Down
    | Idle
    | Pausing
    | Resume
    | ChangeMusic


type Msg
    = PressedKey KeyInput
    | ReleasedKey KeyInput
    | Tick Float
    | Start
    | Pause
    | Continue -- game states
    | Next --connection between level score and new level info or game background and level1 info
    | Pass Int -- used to pass a certain level
    | Replay -- return to level intro page
    | RandomSeed Seed -- decide the location of bricks with special items
