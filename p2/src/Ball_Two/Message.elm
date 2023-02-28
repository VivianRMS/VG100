module Ball_Two.Message exposing (BallTwoUserMsg(..), ModelMsgBallTwo(..))
{-| This module defines message types for the game Defend the fragile.

# Message types
@docs BallTwoUserMsg, ModelMsgBallTwo

-}

{-|
    This data type includes different user messages for ball2 game, namely those controlled by players.
    The Start_prepare msg conveys a message that the player starts playing when the game status is prepare.
    The Start_playing msg conveys a message that the player starts playing when the game status is playing.
    The Pause_prepare msg conveys a message that the player pauses the game when the game status is prepare.
    The Pause_playing msg conveys a message that the player pauses the game when the game status is playing.
    The Nextstep msg conveys a message that the player enters the next round or the next game page.
    The Enter msg conveys a message that the player enters the game from the intro page.
    The None msg conveys a message that no messages are sent.
    The B2Game2Plot msg conveys a message that the player enters the plot page from the ball2 game page.
    The B2ChoosePattern msg conveys a message of player's choice about the pattern of the ball2 game.
    The Locked msg conveys a message that the game is in the state that can't be played by players.
-}

type BallTwoUserMsg
    = Start_prepare
    | Start_playing
    | Pause_prepare
    | Pause_playing
    | Nextstep
    | Enter
    | None
    | B2Game2Plot
    | B2ChoosePattern Int
    | Locked


{-|
    This data type includes different model messages for Klotski, namely those not controlled by players.
    The Basketposx_P1 msg conveys a message to randomize the initial x position of target in pattern1.
    The Basketposx_P2 msg conveys a message to randomize the initial x position of the two targets in pattern2.

-}


type ModelMsgBallTwo
    = Basketposx_P1 Float
    | Basketposx_P2 (Float,Float)
