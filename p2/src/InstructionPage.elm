module InstructionPage exposing (viewInstructionPage)
{-|
    This module presents the instruction page for the player.

# Main Instruction Page Module
@docs viewInstructionPage
-}
import Html exposing (Html, div, text, time)
import Html.Attributes as HtmlAttr
import Model exposing (Model)
import Msg exposing (Msg(..))
import String exposing (fromFloat)
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr


{-|
    This function presents the instruction page for the player.   
-}

viewInstructionPage : Model -> Html Msg
viewInstructionPage model =
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
        [Svg.svg
            [SvgAttr.width "100%"
             ,SvgAttr.height "100%"]
            [Svg.image
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.xlinkHref link
            ]
            []]
        , viewInstructionText model
        ]
viewInstructionText : Model -> Html Msg
viewInstructionText model =
    div
        []
        [ viewIntrotext model 1 1 (168,190)
        , viewIntrotext model 2 2 (168,310)
        , viewIntrotext model 3 3 (168,430)
        , viewIntrotext model 4 4 (168,550)
        , viewIntrotext model 5 5 (168,670)
        , viewIntrotext model 6 6 (168,790)
        , viewIntrotext model 7 7 (168,910)
        , viewIntrotext model 8 8 (168,1010)
        ]

viewIntrotext : Model -> Int -> Int -> (Float,Float) -> Html Msg
viewIntrotext model time index (left,top) =
    let
        txt =
            getintrotext index
    in
        div
            [ HtmlAttr.style "opacity" (getIntrotextOpacity model.time time)
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.style "left" ( (String.fromFloat left ) ++ "px" )
            , HtmlAttr.style "top" ( (String.fromFloat top ) ++ "px" )
            , HtmlAttr.style  "font-family" "Comic Sans MS, Comic Sans, cursive"
            , HtmlAttr.style "font-size" "33px"
            , HtmlAttr.style "font-weight" "bold"
            , HtmlAttr.style "color" "#22543d"
            ]
            [ text txt ]

getintrotext : Int -> String
getintrotext index =
    case index of
        1 ->
            "Dear friend,"
        2 ->
            "Listen, this is my last letter to you. Many lives have passed away recently, and it's my turn now."
        3 ->
            "SummerSara is going on. Past memories are vanishing, and time is trapped in a 7-day loop."
        4 ->
            "My friend, come to the town, recover memories and let time flow again !"
        5 ->
            "Find my friend, the photographer, to know more about memories. Go to the library for guidance."
        6 ->
            "Yours,"
        7 ->
            "Lee"
        8 ->
            "press S to start your journey"
        _ ->
            ""

getIntrotextOpacity : Float -> Int -> String
getIntrotextOpacity time num =
    if num <= 3 then
        getSmallIntroOpacity time num
    else
        getBigIntroOpacity time num
getSmallIntroOpacity : Float -> Int -> String
getSmallIntroOpacity time num = 
    case num of
        1 ->
            if time <= 2000 then
                time
                    * (4000 - time)
                    / 2000
                    / 2000
                    |> fromFloat

            else
                "1"

        2 ->
            if time <= 4000 then
                "0"

            else if time <= 6000 then
                (time - 4000)
                    * (8000 - time)
                    / 2000
                    / 2000
                    |> fromFloat

            else
                "1"

        3 ->
            if time <= 8000 then
                "0"

            else if time <= 10000 then
                (time - 8000)
                    * (12000 - time)
                    / 2000
                    / 2000
                    |> fromFloat

            else
                "1"
        _ ->
            ""
getBigIntroOpacity : Float -> Int -> String
getBigIntroOpacity time num =
    case num of
        4 ->
            if time <= 12000 then
                "0"

            else if time <= 14000 then
                (time - 12000)
                    * (16000 - time)
                    / 2000
                    / 2000
                    |> fromFloat

            else
                "1"

        5 ->
            if time <= 16000 then
                "0"

            else if time <= 18000 then
                (time - 16000)
                    * (20000 - time)
                    / 2000
                    / 2000
                    |> fromFloat

            else
                "1"

        6 ->
            if time <= 20000 then
                "0"

            else if time <= 22000 then
                (time - 20000)
                    * (24000 - time)
                    / 2000
                    / 2000
                    |> fromFloat

            else
                "1"
        7 ->
            if time <= 24000 then
                "0"
            else if time <= 26000 then
                (time - 24000)
                    *(28000 - time)
                    / 2000
                    / 2000
                    |> fromFloat
            else
                "1"

        8 ->
            if time <= 28000 then
                "0"
            else if time <= 30000 then
                (time - 28000)
                    *(32000 - time)
                    / 2000
                    / 2000
                    |> fromFloat
            else
                "1"
        _ ->
            ""