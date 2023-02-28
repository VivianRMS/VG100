module Main exposing (..)

{- Main -}

import Browser exposing (element)
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyPress, onKeyUp)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import Message exposing (KeyInput(..), Msg(..))
import Model exposing (Model, init)
import Update exposing (update)
import View exposing (view)


main : Program Int Model Msg
main =
    element { init = init, update = update, view = view, subscriptions = subscriptions }



-- judge where to use key or onAnimationFrameDelta


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ if model.state == Model.PreAnimation || model.state == Model.Playing then
            onAnimationFrameDelta Tick

          else
            Sub.none
        , onKeyDown keyPressedDecoder
        , onKeyUp keyReleasedDecoder
        , onKeyPress keyPressedDecoder
        ]



--KeyPressed is to make the movement of the paddle smooth


keyPressedDecoder : Decode.Decoder Msg
keyPressedDecoder =
    Decode.map (key >> PressedKey) keyCode


keyReleasedDecoder : Decode.Decoder Msg
keyReleasedDecoder =
    Decode.map (key >> ReleasedKey) keyCode


key : Int -> KeyInput
key keycode =
    case keycode of
        37 ->
            Left

        38 ->
            Up

        39 ->
            Right

        40 ->
            Down

        61 ->
            ChangeMusic

        80 ->
            Pausing

        82 ->
            Resume

        _ ->
            Idle
