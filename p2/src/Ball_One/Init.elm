module Ball_One.Init exposing (initB_OneSubmodel, initRandomGoal)
{-|
    This module inits the game of ball one.

# Init ball one game
@docs initB_OneSubmodel, initRandomGoal

-}
import Random

import Ball_One.Model exposing (B_OneSubmodel, Ball, BallState(..), Dir(..), Goal, Path(..), Pattern(..), PatternValid(..), State(..))
import Basis exposing (GameIdentity, Item(..), Page(..))

{-|
    This function initializes the game ball one.
-}
initB_OneSubmodel : Page -> Item -> Pattern -> Bool -> B_OneSubmodel
initB_OneSubmodel page item pattern =
    let
        identity =
            GameIdentity page item
    in
    B_OneSubmodel 5 initBall initGoal (State_Start ValidPattern) 0 0 pattern 0 0 identity


initBall : Ball
initBall =
    Ball ( 1300, 650 ) 90 0 Stop 0 Curve 0 False Right_dir


initGoal : Goal
initGoal =
    Goal ( 0, 0 ) 0 0 Right_dir ( 200, 500 )

{-|
    This function initializes the random position of the goal.
-}
initRandomGoal : Random.Generator ( Float, Float )
initRandomGoal =
    Random.pair (Random.float 200 900) (Random.float 200 500)