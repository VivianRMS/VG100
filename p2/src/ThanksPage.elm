module ThanksPage exposing (viewThanksPage)
{-|
    This module presents the thanks page to the player.
# Main Thanks Page
@docs viewThanksPage
-}
import Html exposing (div,Html,text)
import Msg exposing (Msg(..))
import Basis exposing (Page(..))
import Html.Attributes as HtmlAttr exposing (style)
import ViewBuildings exposing (viewback)
import ViewButton exposing (backButton)

{-|
    This function presents the thanks page for the player.
-}
viewThanksPage : Html Msg
viewThanksPage =
   let
        link =
            "assets/letter.jpg"
   in
    div
        [     style "width" "1920px"
            , style "height" "1080px"
            , style "position" "fixed"
            , style "left" "0px"
            , style "top" "0px"
            , style "z-index" "-5"
            , style "background" "#d6ccc0"
        ]
        [ viewback link
        , backButton Map
        , viewThanksText
        ]

viewThanksText : Html Msg
viewThanksText =
    div
        []
        [ viewthanktext 1 (168,190)
        , viewthanktext 2 (168,310)
        , viewthanktext 3 (168,430)
        , viewthanktext 4 (168,550)
        , viewthanktext 5 (168,670)
        , viewthanktext 6 (168,790)
        ]

viewthanktext : Int -> (Float,Float) -> Html Msg
viewthanktext index (left,top) =
    let
        txt =
            getthanktext index
    in
        div
            [ HtmlAttr.style "position" "fixed"
            , HtmlAttr.style "left" ( (String.fromFloat left ) ++ "px" )
            , HtmlAttr.style "top" ( (String.fromFloat top ) ++ "px" )
            , HtmlAttr.style  "font-family" "Comic Sans MS, Comic Sans, cursive"
            , HtmlAttr.style "font-size" "33px"
            , HtmlAttr.style "font-weight" "bold"
            , HtmlAttr.style "color" "#390d5b"
            ]
            [ text txt ]

getthanktext : Int -> String
getthanktext index =
    case index of
        1 ->
            "Hereby we present our thankfulness:"
        2 ->
            "To professors and teaching assistants, who give inspiring instructions and help us polish our work;"
        3 ->
            "To Axiba, LuTianYiQAQ, and Wulu who painted great scenes and map;"
        4 ->
            "To And and Moxuan who painted lively items for the game;"
        5 ->
            "To all RainbowX members who devoted tirelessly to the project;"
        6 ->
            "And to you, our player, who steps into the journey with us."
        _ ->
            ""
