module Ball_One.Model exposing (PatternValid(..),B_OneSubmodel, Ball, BallState(..), Dir(..), Goal,Path(..), Point, State(..), Pattern(..))
{-| This module defines the submodel type for the game Company and Love.

# Submodel types
@docs B_OneSubmodel

# Other Datatypes
@docs PatternValid, Ball, BallState, Dir, Goal, Path, Point, State, Pattern
-}

import Basis exposing (GameIdentity,Page(..),Item(..))

{-|
    This data type defines the submodel for the game Company and Love.
    
    The field chance records the remaining rounds.
    The field ball records the information of the basketball.
    The field goal records the information of the goal.
    The field state records the game status.
    The field score records the whole game score.
    The field endtime acts as the timer in interval of two rounds.
    The field pattern records the kind of ball one.
    The field time_goal is the timer of the whole game.
    The field time_ball records the time of pressing A to launch the ball.
    The field identity records the page where the start game button is placed and the item this game may carry.
    The field te records whether the big game enters TE line.

        Eg. B_OneSubmodel 5 ball goal (State_Start ValidPattern) 0 0 pattern 0 0 identity 
-}
type alias B_OneSubmodel =
    { chance : Int
    , ball : Ball
    , goal : Goal
    , state : State
    , score : Int
    , endtime : Float
    , pattern : Pattern
    , time_goal : Float
    , time_ball : Float
    , identity : GameIdentity
    , te : Bool
    }

{-|
    This data type defines the submodel for the basketball.
    
    The field anchor records the position of the ball.
    The field radius records the radius of the ball.
    The field speed records the speed of the ball.
    The field state records the moving state of the ball.
    The field aimtime records the aiming time of the ball.
    The field path records the state of movement.
    The field lineAngle records the angle of movement.
    The field strike records whether the ball has bee thrown in the basket.
    The field ball_dir records the direction of the ball.

        Eg. Ball ( 1300, 650 ) 90 0 Stop 0 Curve 0 False Right_dir
-}
type alias Ball =
    { anchor : Point
    , radius : Float
    , speed : Float
    , state : BallState
    , aimtime : Float
    , path : Path
    , lineAngle : Float
    , strike : Bool
    , ball_dir : Dir
    }

{-|
    This data type defines the way to express the position. 
-}
type alias Point =
    ( Float, Float )

{-|
    This data type defines the state of the game ball one.

    Play means the game is playing.
    State_Start means the game is in the intro page.
    State_Pause means the game is paused.
    State_Resume means the game is resumed.
    Interval means the game is in the interval between two rounds.
    Pass means the whole game is passed.
    Fail means the whole game is failed.
    ActNotEnough means the action points of the model is not enough
    to enter this game.
-}
type State
    = Play
    | State_Start PatternValid
    | State_Pause
    | State_Resume
    | Interval
    | Pass
    | Fail
    | ActNotEnough

{-|
    This data type defines whether the game has different patterns
    for players to choose.
    
    ValidPattern means different types of game can be chosen.
    InvalidPattern means the type is the default one.
-}
type PatternValid =
    ValidPattern
    | InvalidPattern

{-|
    This data type defines the path of the ball.

    Curve means the path is a curve.
    Line means the path is a line.
-}
type Path
    = Curve
    | Line

{-|
    This data type defines the state of the ball.

    Stop means the ball stops.
    Motion means the ball in motion.
    Win means the ball in the basket. If the judgement is made
    , the Bool will be False.
    Lose mean the ball out of basket.
-}
type BallState
    = Stop
    | Motion
    | Win Bool
    | Lose

{-|
    This data type defines the direction of the ball.

    Left_dir means the direction is left.
    Others are similar.
-}
type Dir
    = Left_dir
    | Right_dir
    | Up_dir
    | Down_dir

{-|
    This data type records the pattern of the game ball one.

    Pattern1 means the goal is static, the ball size is fixed.
    Pattern2 means the goal is moving, the ball size is fixed.
    Pattern3 means the goal is static, the ball size is changing.
    Pattern4 means the goal is moving, the ball size is changing.
    
-}
type Pattern
   = Pattern1  
   | Pattern2  
   | Pattern3  
   | Pattern4  


{-|
    This data type records the information of the basket(goal).

    The field anchor records the position of the goal.
    The field width records the width of the goal.
    The field heigth records the height of the goal.
    The field dir records the direction of the goal.
    The field boundary records the boundary of where the goal can
    randomly generate.
    
        Eg. Goal ( 0, 0 ) 0 0 Right_dir ( 200, 500 )
-}
type alias Goal =
    { anchor : Point
    , width : Float
    , height : Float
    , dir : Dir
    , boundary : (Float,Float)
    }





