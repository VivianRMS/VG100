module Ball_Two.Model exposing (BTwoModel,initBTwoModel_S1P1,initBTwoModel_S1P2,initBTwoModel_S2P1,initBTwoModel_S2P2)
{-| This module defines basic submodel of ball4 and initialization functions for the submodel in the game Break the loop.

# Submodel types
@docs BTwoModel

# Initialization functions
@docs initBTwoModel_S1P1,initBTwoModel_S1P2,initBTwoModel_S2P1,initBTwoModel_S2P2

-}

import Ball_Two.Ball_Two exposing (Scene(..),WinOrFail(..),BallState(..),Ball,Basket,GameStatus(..),Pattern(..),BTwoResult,PatternValid(..))
import Basis exposing (GameIdentity,Page(..),Item(..))
import Ball_Two.Initial exposing (initBall,initBasket_P1,initBasket_P2,initBTwoResult)

{-|
    This data type defines the submodel for the game Defend the fragile.
    The field ball records the information of the ball.
    The field hole records the information of the target.
    The field game_status records the game status.
    The field time_basket records the moving time of the target.
    The field time records the total time that the game is proceeding.
    The field result records the result of the whole game.
    The field round records the round of the game.
    The field identity records the page where the start game button is placed and the item this game may carry.
    The field pattern records the pattern of the game.
    The field te records whether the player has entered the true ending.
    The field scene records the scene of the game.
 
    Eg. BTwoModel ball basket Prepare 0 0 result 1 identity (10,160) Pattern2 False Scene1
-}

type alias BTwoModel =
    { ball : Ball
    , basket : List Basket
    , game_status : GameStatus
    , time_basket : Float
    , time : Float
    , result : BTwoResult
    , round : Int
    , identity : GameIdentity
    , field : (Float,Float)
    , pattern : Pattern
    , te : Bool
    , scene: Scene
    }

{-|
    This function is the initialization of a ball4's submodel in scene1 and pattern1.
    With input of the initialization of the ball, the target, the game result, the game status, the time, the pattern, the round, the scene
    the page where the player enters the game and the item the game may carry, the BTwoSubmodel is initialized.

-}

initBTwoModel_S1P1 : Page -> Item -> Bool -> BTwoModel
initBTwoModel_S1P1 page item te =
    let
        identity = GameIdentity page item
    in
    BTwoModel initBall initBasket_P1 (Intro ValidPattern) 0 0 initBTwoResult 1  identity (5,155) Pattern1 te Scene1

{-|
    This function is the initialization of a ball4's submodel in scene1 and pattern2.
    With input of the initialization of the ball, the target, the game result, the game status, the time, the pattern, the round, the scene
    the page where the player enters the game and the item the game may carry, the BTwoSubmodel is initialized.

-}

initBTwoModel_S1P2 : Page -> Item -> Bool ->  BTwoModel
initBTwoModel_S1P2 page item te =
    let
        identity = GameIdentity page item
    in
    BTwoModel initBall initBasket_P2 (Intro ValidPattern) 0 0 initBTwoResult 1  identity (5,155) Pattern2 te Scene1

{-|
    This function is the initialization of a ball4's submodel in scene2 and pattern1.
    With input of the initialization of the ball, the target, the game result, the game status, the time, the pattern, the round, the scene
    the page where the player enters the game and the item the game may carry, the BTwoSubmodel is initialized.

-}

initBTwoModel_S2P1 : Page -> Item -> Bool ->  BTwoModel
initBTwoModel_S2P1 page item te =
    let
        identity = GameIdentity page item
    in
    BTwoModel initBall initBasket_P1 (Intro ValidPattern) 0 0 initBTwoResult 1  identity (5,155) Pattern1 te Scene2

{-|
    This function is the initialization of a ball4's submodel in scene2 and pattern2.
    With input of the initialization of the ball, the target, the game result, the game status, the time, the pattern, the round, the scene
    the page where the player enters the game and the item the game may carry, the BTwoSubmodel is initialized.

-}

initBTwoModel_S2P2 : Page -> Item -> Bool ->  BTwoModel
initBTwoModel_S2P2 page item te =
    let
        identity = GameIdentity page item
    in
    BTwoModel initBall initBasket_P2 (Intro ValidPattern) 0 0 initBTwoResult 1  identity (5,155) Pattern2 te Scene2

