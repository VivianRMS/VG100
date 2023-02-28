module Ball_Four.Ball_Four exposing (WinOrFail(..),BallState(..),Ball,Hole,GameStatus(..),Pattern(..),BFourResult,initBall,initHole,initBFourResult,PatternValid(..))

{-| This module defines basic data types and initialization functions for important elements in the game Break the loop.

# Data types
@docs WinOrFail,BallState,Ball,Hole,GameStatus,Pattern,BFourResult,PatternValid

# Initialization functions
@docs initBall,initHole,initBFourResult

-}
import Msg exposing (KeyInput(..))
{-|
    This data type defines the state of the ball.
    The type of Launched is after the ball is released and before judging whether the ball can be in the hole.
    The type of NotLaunched is when the player is adjusting the shooting angle and range of the ball, before the ball is released.  
    The type of Judge is when assessing whether the position of the ball is in the hole.
    The type of Bounce is after judging, if the ball's position is out of the hole, then the ball will bounce back after hitting the board.
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

type PatternValid 
    = ValidPattern
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
    This data type defines the game pattern.
    The trajectory of the moving hole is "Loop" in Pattern1 type.
    The trajectory of the moving hole is "Summer" in Pattern2 type.

-}

type Pattern
   = Pattern1
   | Pattern2

{-|
    This data type records the result of the game.
    The field win_num is the number that the player wins.
    The field lose_num is the number that the player loses.
    The field round_result records the game result of each round.
    The field victoty_or_fail records the final game result. 

    Eg. BFourResult 1 1 RoundFail Process
-}
   
type alias BFourResult =
    { win_num : Int
    , lose_num : Int
    , round_result : WinOrFail
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
    The field ball_distance is the shooting range of the ball.
    The field shoot_pos is the coordinate position when the ball hits the board.
    
    Eg. Ball pi/2 90 80 8 1 NotLaunched Right 50 (50,30)

-}

type alias Ball =
    { ball_angle : Float
    , ball_posx : Float
    , ball_posy : Float
    , ball_radius : Float
    , ball_scale : Float
    , ball_state : BallState
    , ball_dir : KeyInput
    , ball_distance : Int
    , shoot_pos : ( Float, Float )
    }

{-|
    This data type records the basic situation of the hole.
    The field hole_posx is the x position of the hole.
    The field hole_posy is the y position of the hole.
    The field hole_speed is the moving speed of the hole.
    The field hole_radius is the radius of the hole.
    The field boundary is the boundary value for the entire interface.

    Eg. Hole 40 30 1 5 (30,150)
-}

type alias Hole =
    { hole_posx : Float
    , hole_posy : Float
    , hole_speed : Float
    , hole_radius : Float
    , boundary : ( Float, Float )
    }


{-|
    This function initializes basic status of the ball.
   
-}

initBall : Ball
initBall =
    Ball (pi / 2) 82 80 8 1 NotLaunched Idle 40 ( 0, 0 )

{-|
    This function initializes basic status of the hole.
   
-}

initHole : Hole
initHole =
    Hole 0 10 10 3  ( 0, 160 )

{-|
    This function initializes basic status of the game result.
   
-}

initBFourResult : BFourResult
initBFourResult =
    BFourResult 0 0 Process Process
