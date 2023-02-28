module Subscriptions exposing (keyPressedDecoder, subscription)
{-|
    This module deals with the subscriptions we receive
# Subscriptions 
@docs subscription, keyPressedDecoder


-}
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyPress, onKeyUp)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import Model exposing (Model)
import Msg exposing (KeyInput(..), ModelMsg(..), Msg(..), UserMsg(..))
import Browser.Events exposing (onResize)

{-|
    This funtion batches all subscriptions we need for the game.
-}
subscription : Model -> Sub Msg
subscription _ =
    Sub.batch
        [ onAnimationFrameDelta Tick
        , onKeyDown keyPressedDecoder
        , onKeyUp keyReleasedDecoder
        , onKeyPress keyPressedDecoder
        , onKeyUp (Decode.map keyUp keyCode)
        , onKeyDown (Decode.map keyDown keyCode)
        , onResize Resize
        ]

{-|
    This function is to change the keyinput to the corresponding message.
-}
keyPressedDecoder : Decode.Decoder Msg
keyPressedDecoder =
    let
        t : KeyInput -> Msg
        t x =
            PressedKey x
                |> Usermsg
    in
    Decode.map (key >> t) keyCode


keyReleasedDecoder : Decode.Decoder Msg
keyReleasedDecoder =
    let
        t : KeyInput -> Msg
        t x =
            ReleasedKey x
                |> Usermsg
    in
    Decode.map (key >> t) keyCode


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

        32 ->
            Launch
        13 ->
            Skip
        83 ->
            LoadMap

        _ ->
            Idle


keyDown : Int -> Msg
keyDown keycode =
    case keycode of
        65 ->
            PressedKey Aim |> Usermsg

        _ ->
            PressedKey Idle |> Usermsg


keyUp : Int -> Msg
keyUp keycode =
    case keycode of
        65 ->
            ReleasedKey Go |> Usermsg

        _ ->
            ReleasedKey Idle |> Usermsg
