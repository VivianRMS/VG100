module Ball_Four.Message exposing (BallFourUserMsg(..))
{-| This module defines message types for the game Break the loop.

# Message types
@docs BallFourUserMsg

-}

{-|
    This data type includes different user messages for ball4 game, namely those controlled by players.
    The Start msg conveys a message that the player starts the game.
    The Start_playing msg conveys a message that the player starts playing when the game status is playing.
    The Start_prepare msg conveys a message that the player starts playing when the game status is prepare.
    The Pause_prepare msg conveys a message that the player pauses the game when the game status is prepare.
    The Pause_playing msg conveys a message that the player pauses the game when the game status is playing.
    The NextBallFour msg conveys a message that the player enters the next round or the next game page.
    The EnterBallFour msg conveys a message that the player enters the game from the intro page.
    The Exit msg conveys a message that the player exits from the game.
    The None msg conveys a message that no messages are sent.
    The B4Game2Plot msg conveys a message that the player enters the plot page from the ball4 game page.
    The B4ChoosePattern msg conveys a message of player's choice about the pattern of the ball4 game.
    The Locked msg conveys a message that the game is in the state that can't be played by players.
-}

type BallFourUserMsg
    = Start
    | Start_playing
    | Start_prepare
    | Pause_prepare
    | Pause_playing
    | NextBallFour
    | EnterBallFour
    | Exit
    | None
    | B4Game2Plot
    | B4ChoosePattern Int
    | Locked