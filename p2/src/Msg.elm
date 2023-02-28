module Msg exposing (Drawermsg(..), KeyInput(..), ModelMsg(..), Msg(..), Photographermsg(..), UserMsg(..), Weavermsg(..), sendMsg)
{-| This module defines the basic data type of Msg and the function of send Msg.

# Data types
@docs Drawermsg, KeyInput, ModelMsg, Msg, Photographermsg, UserMsg, Weavermsg

# Functions
@docs sendMsg

-}
import Ball_Four.Message exposing (BallFourUserMsg)
import Ball_One.Msg exposing (BallOneUserMsg(..), ModelMsgBallOne(..))
import Ball_Three.Message exposing (BallThreeUserMsg, ModelMsgBallThree)
import Ball_Two.Message exposing (BallTwoUserMsg, ModelMsgBallTwo)
import Basis exposing (Building(..), Content(..), GameKind(..), Item(..), Page)
import MsgColor exposing (ModelMsgColor, UserMsgColor)
import MsgKlotski exposing (ModelMsgKlotski, UserMsgKlotski)
import Task exposing (perform, succeed)
import Browser.Dom exposing (Viewport)

{-|
    This general messeage dispatches the message received.
-}
type Msg
    = Usermsg UserMsg
    | Modelmsg ModelMsg
    | Tick Float
    | Change String
    | ChangePhoto String
    | ChangeDrawer String
    | Resize Int Int
    | GetViewport Viewport

{-|
    This message type defines the messages that are sent by the user.
-}
type UserMsg
    = Samsara
    | GotoPlace Page
    | PhotographerMsg Photographermsg
    | DrawerMsg Drawermsg
    | WeaverMsg Weavermsg
    | BacktoPlace Page
    | KlotskiUserMsg UserMsgKlotski
    | BallTwoUserMsg BallTwoUserMsg
    | BallThreeUserMsg BallThreeUserMsg
    | BallFourUserMsg BallFourUserMsg
    | BallOneUserMsg BallOneUserMsg
    | PressedKey KeyInput
    | ReleasedKey KeyInput
    | ColorUserMsg UserMsgColor
    | P2G GameKind
    | G2P Page
    | POut
    | TextNext


{-|
    This type defines the information that keyinput maps to.
-}
type KeyInput
    = Left
    | Right
    | Up
    | Down
    | Launch
    | Aim
    | Go
    | Idle
    | Skip
    | LoadMap

{-|
    This type defines the message received for the photographer line.
-}
type Photographermsg
    = GetFragment Int
    | GetPhotoClue Content
    | GetPhotoItem Item
    | JudgePhotoString

{-|
    This type defines the message received for the drawer(painter) line.
-}
type Drawermsg
    = GetItem Item
    | GetClue Content
    | JudgeDrawerString 

{-|
    This type defines the message received for the weaver line.
-}
type Weavermsg
    = GetWeavItem Item
    | GetWeavClue Content
    | JudgeString

{-|
    This type defines the message received from the model.
-}
type ModelMsg
    = TurnDay
    | DetermineLine
    | DeductActionPoint
    | RecordLineEnding
    | KlotskiModelMsg ModelMsgKlotski
    | BallTwoModelMsg ModelMsgBallTwo
    | ColorModelMsg ModelMsgColor
    | BallThreeModelMsg ModelMsgBallThree
    | BallOneModelMsg ModelMsgBallOne
    | ToExhaustPage

{-|
    This function turns a message to a command message.
-}
sendMsg : msg -> Cmd msg
sendMsg msg =
    succeed msg
        |> perform identity
