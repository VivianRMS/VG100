module Ball_Two.Initial exposing (initBall,initBasket_P1,initBasket_P2,initBTwoResult,initRandomBasketPos_P1,initRandomBasketPos_P2)

{-| This module defines initialization fuction for important elements in the game Defend the fragile.

# Initialization functions
@docs initBall,initBasket_P1,initBasket_P2,initBTwoResult,initRandomBasketPos_P1,initRandomBasketPos_P2

-}

import Random
import Ball_Two.Ball_Two exposing(Dir(..),Scene(..),WinOrFail(..),BallState(..),Ball,Basket,GameStatus(..),Pattern(..),BTwoResult,PatternValid(..))
import Msg exposing (KeyInput(..), Msg(..))

{-|
    This function initializes basic status of the ball.
   
-}

initBall : Ball
initBall =
    Ball (pi/2) 79 75 6 1 NotLaunched Left ( 0, 0 )

{-|
    This function initializes basic status of the target in pattern1.
   
-}

initBasket_P1 : List Basket
initBasket_P1 =
    [Basket 10 15 R ( 20, 140 ) 10 0]

{-|
    This function initializes basic status of the target in pattern2.
   
-}

initBasket_P2 : List Basket
initBasket_P2 =
    List.append [Basket 10 12 R ( 20, 80 ) 8 0]  [Basket 10 7 R ( 100, 140 ) 8 0]

{-|
    This function initializes the result of the game .
   
-}

initBTwoResult : BTwoResult
initBTwoResult =
    BTwoResult 0 0 Process

{-|
    This function initializes the position of the target randomly in pattern1 .
   
-}

initRandomBasketPos_P1 :Random.Generator Float
initRandomBasketPos_P1  =
    Random.float 10 130

{-|
    This function initializes the position of the target randomly in pattern2 .
   
-}

initRandomBasketPos_P2 :Random.Generator (Float,Float)
initRandomBasketPos_P2  =
    Random.pair (Random.float 20 80) (Random.float 100 140)