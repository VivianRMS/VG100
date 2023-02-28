module MsgKlotski exposing (ModelMsgKlotski(..), UserMsgKlotski(..))


{-| This module defines message types for the game Klotski.

# Message types
@docs UserMsgKlotski, ModelMsgKlotski

-}

import Klotski exposing (Cell,KState)

{-|
    This data type includes different user messages for Klotski, namely those controlled by players.
    The KMove Cell msg conveys a message that the player is moving the cell by clicking it.
    The KState KState msg conveys a message of transformation between different game status.
    The KGame2Plot msg conveys a message that the player wants to leave the game and go back to the previous page.

-}

type UserMsgKlotski
    = KMove Cell
    | KState KState
    | KGame2Plot

{-|
    This data type includes different model messages for Klotski, namely those not controlled by players.
    The KlotskiAutomatic msg conveys a message to check whether the player achieves success and also whether the initial
    order of indexes have been randomized.
    The KInitRO Int msg conveys a message to randomize the initial order of indexes.

-}

type ModelMsgKlotski
    = KlotskiAutomatic
    | KInitRO Int
