module Ball_Four.Model exposing (BFourModel,initBFourModel_P1,initBFourModel_P2)
{-| This module defines basic submodel of ball4 and initialization functions for the submodel in the game Break the loop.

# Submodel types
@docs BFourModel

# Initialization functions
@docs initBFourModel_P1,initBFourModel_P2

-}

import Ball_Four.Ball_Four exposing (BallState(..),Ball,Hole,GameStatus(..),Pattern(..),BFourResult,initBall,initHole,initBFourResult,PatternValid(..))
import Basis exposing (GameIdentity,Page(..),Item(..))

{-|
    This data type defines the submodel for the game Break the loop.
    The field ball records the information of the ball.
    The field hole records the information of the hole.
    The field game_status records the game status.
    The field time_hole records the moving time of the hole.
    The field time records the total time that the game is proceeding.
    The field result records the result of the whole game.
    The field round records the round of the game.
    The field identity records the page where the start game button is placed and the item this game may carry.
    The field pattern records the pattern of the game.
    The field te records whether the player has entered the true ending.

    Eg. BFourModel ball hole Prepare 1 1 result 1 identity Pattern1 False
-}

type alias BFourModel =
    { ball : Ball
    , hole : Hole
    , game_status : GameStatus
    , time_hole : Float
    , time : Float
    , result : BFourResult
    , round : Int
    , identity : GameIdentity
    , pattern : Pattern
    , te : Bool
    }

{-|
    This function is the initialization of a ball4's submodel in pattern1.
    With input of the initialization of the ball, the hole, the game result, the game status, the time, the pattern, the round,
    the page where the player enters the game and the item the game may carry, the BFourSubmodel is initialized.

-}

initBFourModel_P1 : Page -> Item -> Bool -> BFourModel
initBFourModel_P1 page item te =
    let
        identity = GameIdentity page item
    in
    BFourModel initBall initHole (Intro ValidPattern) 0 0 initBFourResult 1 identity Pattern1 te


{-|
    This function is the initialization of a ball4's submodel in pattern2.
    With input of the initialization of the ball, the hole, the game result, the game status, the time, the pattern, the round,
    the page where the player enters the game and the item the game may carry, the BFourSubmodel is initialized.

-}


initBFourModel_P2 : Page -> Item -> Bool -> BFourModel
initBFourModel_P2 page item te =
    let
        identity = GameIdentity page item
    in
    BFourModel initBall initHole (Intro ValidPattern) 0 0 initBFourResult 1 identity Pattern2 te