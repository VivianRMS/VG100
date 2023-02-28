module Ball_Two.Ball_Two exposing (Dir(..),Scene(..),WinOrFail(..),BallState(..),Ball,Basket,GameStatus(..),Pattern(..),BTwoResult,PatternValid(..))

{-| This module defines basic data types for important elements in the game Defend the fragile.

# Data types
@docs Dir, Scene, WinOrFail, BallState, Ball, Basket, GameStatus, Pattern, BTwoResult, PatternValid

-}

import Msg exposing (KeyInput(..), Msg(..))
import Ball_Four.Ball_Four exposing (Pattern(..))
import Ball_Three.Model exposing (GameState(..))

{-|
    This data type defines the state of the ball.
    The type of Launched is after the ball is released and before judging whether the ball hit the target.
    The type of NotLaunched is when the player is adjusting the shooting angle of the ball, before the ball is released.  
    The type of Judge is when assessing whether the ball hits the target .
    The type of Bounce is after judging, if the ball hits the targets, then the ball will bounce back.
    The type of Over is when the position of the ball is out of the interface's boundary.
    the type of Gameover is when reaching the end of this small game.
    
-}


type BallState
    = Launched
    | NotLaunched
    | Judge
    | Bounce
    | Over
    | GameOver

{-|
    This data type defines the status of the whole game.
    The Playing type is when ball has been released and before judging the result.
    The Paused_prepare type is when the game is paused in the preparing stage.
    The Paused_playing type is when the game is paused in the playing stage.
    The JudgeResult type is when the game is assessing the result of the round.
    The Interval type is when the ball is bouncing back before showing the round page.
    The Roundpage type is when showing the round result.
    The Prepare type is before relesing the ball.
    The Intro type is when showing a simple intro page before the game starts.
    The End  type is when showing the ending page of the game after the game is over.
    The ActNotEnough is when showing the time exhausted page if the action points is not enough to play the game. 

-}


type GameStatus
    = Playing
    | Paused_prepare
    | Paused_playing
    | JudgeResult
    | Interval
    | RoundPage
    | Prepare
    | Intro PatternValid
    | End
    | ActNotEnough

{-|
    This data type defines whether the choice of the pattern is valid.
    The ValidPattern type is the pattern that players can choose to play.
    The InvalidPattern is the pattern that still does't offer to players.

-}

type PatternValid =
    ValidPattern
    | InvalidPattern

{-|
    This data type defines whether the player wins or loses the game.
    The RoundVictory type is when the player wins in the round.
    The RoundFail type is when the player loses in the round.
    The GameVictory type is when the player wins at last in the game.
    The GameFail type is when the player loses at last in the game.
    The Process type is when the result has not be determined.

-}

type WinOrFail
    = RoundVictory
    | RoundFail
    | GameVictory
    | GameFail
    | Process

{-|
    This data type defines moving direction of the basket(target).
    The L type is moving left.
    The R type is moving right.

-}

type Dir
    = L
    | R

{-|
    This data type defines the game pattern.
    The Pattern1 type has one moving target.
    The Pattern2 type has two moving target.

-}

type Pattern
   = Pattern1
   | Pattern2

{-|
    This data type defines the game scene.
    The Scene1 type is about scissors shooting at the shield.
    The Scene2 type is about darts shooting at the target.

-}

type Scene
 = Scene1  -- Photographer Line
 | Scene2  -- Classroom throwing dart

{-|
    This data type records the result of the game.
    The field win_num is the number that the player wins.
    The field lose_num is the number that the player loses.
    The field victoty_or_fail records the final game result. 

    Eg. BTwoResult 1 1 RoundFail
-}

type alias BTwoResult =
    { win_num : Int
    , lose_num : Int
    , victory_or_fail : WinOrFail
    }

{-|
    This data type records the basic situation of the ball.
    The field ball_angle is the shooting angle of the ball.
    The field ball_posx is the x position of the ball.
    The field ball_posy is the y position of the ball.
    The field ball_radius is the radius of the ball.
    The field ball_scale is used for changing ball's size according to ball's position.
    The field ball_state is the state of the ball.
    The field ball_dir is the changing direction of the ball when adjusting the angle's value.
    The field shoot_pos is the coordinate position when judging whether the ball hits the target.

    Eg. Ball pi/2 90 80 8 1 NotLaunched Right (40,30)

-}

type alias Ball =
    { ball_angle : Float
    , ball_posx : Float
    , ball_posy : Float
    , ball_radius : Float
    , ball_scale : Float
    , ball_state : BallState
    , ball_dir : KeyInput
    , shoot_pos : ( Float, Float )
    }

{-|
    This data type records the basic situation of one basket(target).
    The field basket_posx is the x position of the target.
    The field basket_posy is the y position of the target.
    The field basket_dir is the moving direction of the target.
    The field boundary is the boundary value for the moving target.
    The field basket_radius is the radius of the target.
    The basket_time is the moving time of the target.

    Eg. Basket 60 40 R (10,160) 10 0
    
-}

type alias Basket =
    { basket_posx : Float
    , basket_posy : Float
    , basket_dir : Dir
    , boundary : ( Float, Float )
    , basket_radius : Float
    , basket_time : Float
    }



