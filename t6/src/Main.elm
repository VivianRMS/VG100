module Main exposing (..)

import Browser
import Browser.Events exposing (onKeyDown,onAnimationFrameDelta)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import Types exposing (..)
import Update exposing (update, init_ship)
import View exposing (view)

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- INITIALIZATION

init : () -> ( Model, Cmd Msg )
init =
    let
        model =
            { ships = [ init_ship Main ], blasts = [], ship_time = 0 , state = Process }
    in
    \() -> ( model, Cmd.none )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch[
     onAnimationFrameDelta Tick
    , onKeyDown (Decode.map key keyCode)
    ]

key : Int -> Msg
key keycode =
    case keycode of
        40 ->
            Go Down

        38 ->
            Go Up

        _ ->
            Noop

