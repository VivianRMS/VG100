module ViewFrameObjects exposing (viewLogoPage)
{-|
    This module views the Logo Page for the player
# Logo Page View
@docs viewLogoPage 
-}
import Html exposing (Html, div, text)
import Html.Attributes as HtmlAttr
import Msg exposing (Msg(..))
import String exposing (fromFloat)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr

{-|
    This function presents the Logo Page for the player.
-}
viewLogoPage : Float -> Html Msg
viewLogoPage time =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        [ viewLogoPageHint time
        , Svg.svg
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            ]
            [ viewLogo time
            , viewTitle time
            ]
        ]


viewLogoPageHint : Float -> Html Msg
viewLogoPageHint time =
    if time <= 8000 then
        div
            []
            []

    else
        let
            floored =
                floor time

            moded =
                modBy 2000 floored
        in
        if moded <= 500 then
            div
                [ HtmlAttr.style "position" "fixed"
                , HtmlAttr.style "top" "400px"
                , HtmlAttr.style "left" "400px"
                , HtmlAttr.style "font-family" "Comic Sans MS, Comic Sans, cursive"
                , HtmlAttr.style "font-size" "22px"
                , HtmlAttr.style "color" "white"
                , HtmlAttr.style "font-weight" "bold"
                ]
                [ text "press Enter to continue" ]

        else
            div
                []
                []


viewLogo : Float -> Svg Msg
viewLogo time =
    let
        link =
            "assets/Logo.png"
    in
    Svg.image
        [ SvgAttr.width "60%"
        , SvgAttr.height "60%"
        , SvgAttr.x "200px"
        , SvgAttr.y "200px"
        , SvgAttr.xlinkHref link
        , SvgAttr.opacity
            (getLogoOpacity time
                |> fromFloat
            )
        ]
        []


viewTitle : Float -> Html Msg
viewTitle time =
    let
        link =
            "assets/Title.jpg"
    in
    Svg.image
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.x "0px"
        , SvgAttr.y "0px"
        , SvgAttr.xlinkHref link
        , SvgAttr.opacity
            (getTitleOpacity time
                |> fromFloat
            )
        ]
        []


getLogoOpacity : Float -> Float
getLogoOpacity time =
    if time <= 1500 then
        time * (3000 - time) / 1500 / 1500

    else if time <= 3500 then
        1

    else if time <= 5000 then
        (5000 - time) * (5000 - time) / 1500 / 1500

    else
        0


getTitleOpacity : Float -> Float
getTitleOpacity time =
    if time <= 6000 then
        0

    else if time <= 8000 then
        (10000 - time) * (time - 6000) / 2000 / 2000

    else
        1
