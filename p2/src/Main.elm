module Main exposing (main)
{-|
    This is the main module of our game.

# Main
@docs main

-}
import Browser
import Init exposing (init)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Subscriptions exposing (subscription)
import Update exposing (update)
import View exposing (view)

{-|
    This function is the main function of our game.
-}
main : Program () Model Msg
main =
    Browser.element { init = init, update = update, subscriptions = subscription, view = view }
