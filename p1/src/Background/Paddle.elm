module Background.Paddle exposing (Paddle, ScaleTime(..), makePaddle, moveTimerPaddle)

{- The module that contains functions and types for the paddles. -}

import Debug exposing (toString)
import Html exposing (Html)
import Html.Attributes exposing (..)
import Message exposing (..)

-- whether a paddle is scaled

type ScaleTime
    = Original
    | Scaling Float

-- maximum time for scaling

maximumPaddleScaleTime : Float
maximumPaddleScaleTime =
    500.0


type alias Paddle =
    { xPosition : Float
    , scale : Float
    , timerScale : ScaleTime
    }

-- draw a paddle

makePaddle : Paddle -> Html msg
makePaddle { xPosition, scale } =
    Html.img
        [ style "width" (toString (10.0 * scale) ++ "%")
        , style "height" "auto"
        , style "left" (toString xPosition ++ "%")
        , style "top" "90%"
        , style "position" "absolute"
        , src "assets/images/paddle.png"
        ]
        []

-- if the paddle is being scaled, move timer to record scalertime

moveTimerPaddle : Paddle -> Paddle
moveTimerPaddle paddle =
    case paddle.timerScale of
        Original ->
            paddle

        Scaling past ->
            if past >= maximumPaddleScaleTime then
                { paddle | scale = 1.0, timerScale = Original }

            else
                { paddle | timerScale = Scaling (past + 1.0) }
