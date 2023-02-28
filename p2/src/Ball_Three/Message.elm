module Ball_Three.Message exposing (BallThreeUserMsg(..), ColorType(..), Group(..), ModelMsgBallThree(..))
{-| This module defines message types for the game Seize the wanted.

# Message types
@docs BallThreeUserMsg, ColorType, Group, ModelMsgBallThree

-}

{-|
    This data type includes messages about color type.
    The Dark msg conveys a message of color with dark type.
    The Light msg conveys a message of color with light type.

-}

type ColorType
    = Dark
    | Light

{-|
    This data type includes messages about color group.
    The Red msg conveys a message of color in group red.
    The green msg conveys a message of color in group green.
    The blue msg conveys a message of color in group blue.
    The none msg conveys a message of the state that has not decided color group.

-}

type Group
    = Red
    | Green
    | Blue
    | None

{-|
    This data type includes different user messages for ball3 game, namely those controlled by players.
    The StartBallThree msg conveys a message that the player starts playing.
    The NextBallThree msg conveys a message that the player enter the next round.
    The Pause msg conveys a message that the player pauses the game.
    The Resume msg conveys a message that the player resumes the game after pausing the game.
    The B3Game2Plot msg conveys a message that the player enters the plot page from the ball3 game page.
    The B3ChoosePattern msg conveys a message of player's choice about the pattern of the ball3 game.
    The Locked msg conveys a message that the game is in the state that can't be played by players.

-}

type
    BallThreeUserMsg
    = StartBallThree
    | NextBallThree
    | Pause
    | Resume
    | B3Game2Plot
    | B3ChoosePattern Int
    | Locked

{-|
    This data type includes different model messages for ball3 game, namely those not controlled by players.
    The GetDir msg conveys a message to randomize the initial moving direction of color blocks.
    The GetColor_P1 msg conveys a message to randomize the color and color type of color blocks in pattern1.
    The GetColor_P2 msg conveys a message to randomize the color of color blocks in pattern2.
-}

type ModelMsgBallThree
    = GetDir Float
    | GetColor_P1 ( Int, ColorType )
    | GetColor_P2 Int

