module MsgColor exposing (UserMsgColor(..),ModelMsgColor(..))
{-| This module defines message types for the game Color Union.

# Message types
@docs UserMsgColor, ModelMsgColor

-}
import Color exposing (Tri,CState)

{-|
    This data type includes different user messages for Color Union, namely those controlled by players.
    The CClick Tri msg conveys a message that the player wants to change the color of the clicked triangle.
    The CState CState msg conveys a message of transformation between different game status.
    The CGame2Plot msg conveys a message that the player wants to leave the game and go back to the previous page.

-}
type UserMsgColor
    = CClick Tri
    | CState CState
    | CNcolor Int
    | CGame2Plot

{-|
    This data type includes different model messages for Color Union, namely those not controlled by players.
    The ColorAutomatic msg conveys a message to check whether the player achieves success.

-}
type ModelMsgColor
    = ColorAutomatic
