module Ball_One.Msg exposing (BallOneUserMsg(..), ModelMsgBallOne(..))
{-| This module defines message types for the game Company and love.

# Message types
@docs BallOneUserMsg, ModelMsgBallOne

-}

import Ball_One.Model exposing (Pattern(..))


{-|
    This data type includes different user messages for ball1 game, namely those controlled by players.
    The StartBallOne msg conveys a message that the player starts playing.
    The PauseBallOne msg conveys a message that the player pauses the game.
    The ResumeBallOne msg conveys a message that the player resumes the game after pausing the game.
    The B1Game2Plot msg conveys a message that the player enters the plot page from the ball1 game page.
    The B1ChoosePattern msg conveys a message of player's choice about the pattern of the ball1 game.
    The Locked msg conveys a message that the game is in the state that can't be played by players.
-}

type BallOneUserMsg
    = StartBallOne
    | PauseBallOne
    | ResumeBallOne
    | B1Game2Plot
    | B1ChoosePattern Pattern
    | Locked

{-|
    This data type includes model messages for game Company and love, namely those not controlled by players.
    The B_one msg conveys a message to randomize the initial position of the basket.
-}

type ModelMsgBallOne
    = B_One ( Float, Float )
