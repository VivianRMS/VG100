module Model exposing (CurrentState(..), GameStatus, Model, WinOrFailure(..), init, initModel)

{- The Overall model of our game -}

import Background.Ball as Ball
import Background.Bricks as Bricks
import Background.Paddle as Paddle
import Message exposing (Msg(..))
import Random exposing (initialSeed)
import Task exposing (perform)
import Time exposing (now, posixToMillis)


type alias Model =
    GameStatus


type CurrentState
    = Paused
    | Playing
    | Stopped
    | PreAnimation -- only appear at the start of the game
    | BeforeStart --before starting each round
    | BeforeWholeGame
    | RuleExplanation -- only before level 1 begins


type WinOrFailure
    = Undetermined
    | Victory
    | Failure


type alias GameStatus =
    { bricks : List Bricks.Bricks
    , paddle : Paddle.Paddle
    , balls : List Ball.Ball
    , state : CurrentState
    , key : ( Bool, Bool ) --in this case Bool is clear and concise and work very well, so a tuple of Bool it is!
    , level : Int
    , winOrFailure : WinOrFailure
    , time : Float
    }


init : Int -> ( Model, Cmd Msg )
init level =
    let
        posixToMsg : Time.Posix -> Msg
        posixToMsg p =
            p
                |> posixToMillis
                |> initialSeed
                |> RandomSeed
    in
    --This is for randomizing the bricks in the game
    ( initModel level, perform posixToMsg now )


initModel : Int -> Model
initModel level =
    let
        gameState =
            case level of
                1 ->
                    PreAnimation

                _ ->
                    BeforeStart
    in
    { bricks = []
    , paddle = Paddle.Paddle 45.0 1.0 Paddle.Original
    , balls = Ball.initBalls
    , state = gameState
    , key = ( False, False )
    , level = level
    , winOrFailure = Undetermined
    , time = 0
    }
