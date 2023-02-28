module View exposing (..)

import Debug exposing (toString)
import Html as Html
import Html.Attributes as HtmlAttr
import Types exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Html.Events exposing (onClick)
import Update exposing (init_ship)

view_blast : Blast -> Svg Msg
view_blast blast =
    let
        ( x, y ) =
            blast.pos

        color = case blast.ship_type of
            Main -> "#ff0026d2"
            Enemy -> "#6aff149f"
    in
    Svg.rect
        [ SvgAttr.width "20"
        , SvgAttr.height "5"
        , SvgAttr.x (toString x)
        , SvgAttr.y (toString y)
        , SvgAttr.fill color
        ]
        []


view_ship : Ship -> Svg Msg
view_ship ship =
    let
        ( x, y ) =
            ship.pos

        link = case ship.ship_type of
            Main -> "src/image/mainship.png"
            Enemy -> "src/image/enemy.png"
    in
        Svg.image
            [ SvgAttr.width "130"
            , SvgAttr.height "70"
            , SvgAttr.x (toString x)
            , SvgAttr.y (toString y)
            , SvgAttr.xlinkHref link
            ]
            []

viewRestartButton : Html.Html Msg
viewRestartButton =
    Html.button
        [ HtmlAttr.style "background" "#34495f"
        , HtmlAttr.style "border" "0"
        , HtmlAttr.style "bottom" "30px"
        , HtmlAttr.style "color" "#fff"
        , HtmlAttr.style "cursor" "pointer"
        , HtmlAttr.style "display" "block"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "18px"
        , HtmlAttr.style "font-weight" "300"
        , HtmlAttr.style "height" "60px"
        , HtmlAttr.style "left" "30px"
        , HtmlAttr.style "line-height" "60px"
        , HtmlAttr.style "outline" "none"
        , HtmlAttr.style "padding" "0"
        , HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "width" "120px"
        , onClick Noop
        ]
        [ Html.text "Restart" ]



view : Model -> Html.Html Msg
view model =
    let
        mainship =
            Maybe.withDefault (init_ship Main) (List.head (List.filter (\x -> x.ship_type == Main ) model.ships) )
        info =
            case model.state of
                End ->
                    viewRestartButton
                Process ->
                    Html.div
                        []
                        []
    in
    Html.div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "background" "#2E1F5F6F"
        ]
        [ info
        ,    Svg.svg
                    [ SvgAttr.width "100%"
                    , SvgAttr.height "100%"
                    ]
                    ( List.append (List.map view_blast model.blasts) (List.map view_ship model.ships) )
        ]