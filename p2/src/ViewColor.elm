module ViewColor exposing (viewColor,renderLabel,renderCount)
{-| This module controls the view for the game Color Union.

# Color Union View Function
@docs viewColor, renderLabel, renderCount

-}
import Color exposing (CState(..),Tri,triHeight,triWidth,CResult(..),Pattern(..),TDirection(..),triButtonTwoDeltaY,triButtonOneDeltaY,triButtonOneWidth,triButtonTwoThreeWidth,triButtonThreeDeltaY,triButtonFourDeltaX,triButtonFourWidth,triButtonFourDeltaY,maxStep)
import Debug exposing (toString)
import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Model exposing (Model)
import ModelColor exposing (CSubmodel)
import Msg exposing (Msg(..),UserMsg(..))
import MsgColor exposing (UserMsgColor(..))
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import GameTransitionView exposing (viewGameScene,gamebackground,winPage,failPage,introPage,getTextBlock)
import Markdown

{-|
    This function defines the view for the Color Union.
-}
viewColor : Model -> Html Msg
viewColor model =
    colorView model


renderColorGameButton : CSubmodel -> Html Msg
renderColorGameButton cmodel =
            case cmodel.state of
                CBefore ->
                    div
                    []
                    [ buttonInGame (100,200) "Next" ( Usermsg (ColorUserMsg (CState CBefore ) ) )
                    , buttonInGame (100,600) "Exit" ( Usermsg (ColorUserMsg CGame2Plot) )
                    ]

                CPrepare _ ->
                    case cmodel.te of
                        False ->
                            let
                                txt =
                                    case cmodel.pattern of
                                        PApple ->
                                            "Apple"
                                        PBlueCloth ->
                                            "BlueCloth"
                                        PGrassRing ->
                                            "GrassRing"
                                        PLeaf ->
                                            "Leaf"
                                        _ ->
                                            "Start"
                            in
                                buttonInGame (100,200) txt ( Usermsg (ColorUserMsg (CState (CPrepare cmodel.pattern))) )
                        True ->
                            div
                            []
                            [ buttonInGame (500,350) "Leaf" ( Usermsg (ColorUserMsg (CState (CPrepare PLeaf))) )
                            , buttonInGame (500,850) "Pattern2" ( Usermsg (ColorUserMsg (CState (CPrepare PTE1))) )
                            , buttonInGame (500,1350) "Pattern1" ( Usermsg (ColorUserMsg (CState (CPrepare PTE2))) )
                            ]

                CPlaying ->
                    if cmodel.chance <= 0 then
                        buttonInGame (100,200) "Give Up" (Usermsg (ColorUserMsg (CState CGiveUp)))
                    else
                        buttonInGame (100,200) "Restart" (Usermsg (ColorUserMsg (CState (CPrepare cmodel.pattern))) )

                CEnd ->
                    let
                        txt =
                            case cmodel.te of
                                True ->
                                    "Menu"
                                False ->
                                    "Exit"
                    in
                    buttonInGame (100,200) txt ( Usermsg (ColorUserMsg CGame2Plot) )

                _ ->
                    buttonInGame (100,200) "Exit" ( Usermsg (ColorUserMsg CGame2Plot) )




buttonInGame : (Float,Float) -> String -> Msg -> Html Msg
buttonInGame (bottom,left) pattern msg =
    button
        (List.append
            (List.append ( renderColorGameButtonA bottom ) ( renderColorGameButtonB left ))
            [ onClick msg ]
        )
        [ text pattern ]

renderColorGameButtonA : Float ->List (Attribute msg)
renderColorGameButtonA bottom =
    [ style "background" "#34495f"
    , style "border" "0"
    , style "bottom" ( ( String.fromFloat bottom ) ++ "px" )
    , style "color" "#fff"
    , style "cursor" "pointer"
    , style "display" "block"
    , style "font-family" "Comic Sans MS, Comic Sans, cursive"
    , style "font-size" "60px"
    ]


renderColorGameButtonB : Float ->List (Attribute msg)
renderColorGameButtonB left =
    [ style "font-weight" "300"
    , style "height" "100px"
    , style "right" ( ( String.fromFloat left ) ++ "px" )
    , style "line-height" "60px"
    , style "outline" "none"
    , style "padding" "0"
    , style "position" "absolute"
    , style "width" "250px"
    ]


colorView : Model -> Html Msg
colorView model =
    let
        cSubmodel =
            model.cmodel
    in
    div
        []
        [ viewGameScene cSubmodel.identity.page
        , colorPlayingView cSubmodel
        , renderColorGameButton cSubmodel
        ]


colorPlayingView : CSubmodel -> Html Msg
colorPlayingView cmodel =
    case cmodel.state of
        CBefore ->
            div
                []
                [ gamebackground
                , introPage title
                , renderGameIntroPanel cmodel.te cmodel.pattern
                ]

        CPrepare _ ->
            div
                []
                [ gamebackground
                , introPage title
                ]

        _ ->
            let
                triss =
                    makeTriss cmodel

                buttons=
                    makeTrisButtons cmodel.tris
            in
            div
                []
                ( [ gamebackground
                , introPage title
                , triss
                , buttons
                , makeColorStepBoxes cmodel
                , colorVFView cmodel
                , renderOtherInfo cmodel ]
                )



makeTriss : CSubmodel -> Html Msg
makeTriss cmodel =
    div
    [style "font-family" "Comic Sans MS, Comic Sans, cursive"
             , style "font-size" "30px"
             , style "height" "800px"
             , style "left" "0px"
             , style "line-height" "1.5"
             , style "padding" "0 15px"
             , style "position" "absolute"
             , style "top" "0px"
             , style "width" "1800px"
             , style "display" "block"
             , style "z-index" "-5"
    ]
    [
    Svg.svg
        [ SvgAttr.height "1000"
        , SvgAttr.width "1800"
        ]
        (makeTris cmodel.tris)
    ]


makeTris : List Tri -> List (Html Msg)
makeTris tris =
    List.map makeOneTri tris


makeOneTri : Tri -> Html Msg
makeOneTri tri =
    let
        ntri =
            tri

        ( pointOne_X, pointOne_Y ) =
            Maybe.withDefault ( 0, 0 ) (List.head ntri.pos)

        ( pointTwo_X, pointTwo_Y ) =
            Maybe.withDefault ( 0, 0 ) (List.head (List.drop 1 ntri.pos))

        ( pointThree_X, pointThree_Y ) =
            Maybe.withDefault ( 0, 0 ) (List.head (List.drop 2 ntri.pos))

        triPosition =
            toString pointOne_X
                ++ ","
                ++ toString pointOne_Y
                ++ " "
                ++ toString pointTwo_X
                ++ ","
                ++ toString pointTwo_Y
                ++ " "
                ++ toString pointThree_X
                ++ ","
                ++ toString pointThree_Y

        color =
            case ntri.color of
                1 ->
                    "orange"

                2 ->
                    "#3437B6FF"

                3 ->
                    "green"

                4 ->
                    "red"

                5 ->
                    "#d5c055"

                6 ->
                    "#8662bd"

                7 ->
                    "#a1ce7e"

                8 ->
                    "#457019FF"

                9 ->
                    "#be8f56"

                10 ->
                    "#cf95ff"

                11 ->
                    "#4BA3D9FF"

                12 ->
                    "#e5d68f"

                13 ->
                    "black"

                14 ->
                    "#E566D0FF"

                15 ->
                    "#eab8e1"

                _ ->
                    "black"
    in
    Svg.polygon
        [ SvgAttr.height (toString triHeight)
        , SvgAttr.width (toString triWidth)
        , SvgAttr.points triPosition
        , SvgAttr.fill color
        , SvgAttr.stroke "none"
        ]
        []


makeTrisButtons : List Tri -> Html Msg
makeTrisButtons tris =
    div []
    ( List.map makeOneTriButtons tris )


makeOneTriButtons : Tri -> Html Msg
makeOneTriButtons tri =
    div
        []
        [ makeOneTriButtonFour tri
        , makeOneTriButtonTwoThree tri
        , makeOneTriButtonOne tri
        ]


makeOneTriButtonOne : Tri -> Html Msg
makeOneTriButtonOne tri =
    let
        ( x, y ) =
            Maybe.withDefault ( 0, 0 ) (List.head tri.pos)

        tDir =
            tri.tdir

        ntopOne =
            y + triButtonOneDeltaY

        left =
            case tDir of
                TRight ->
                    x

                TLeft ->
                    x - triButtonOneWidth

    in
    div
        []
        [ button
            [ style "background-color" "transparent"
            , style "border-style" "none"
            , style "top" (toString ntopOne ++ "px")
            , style "left" (toString left ++ "px")
            , style "height" (toString triButtonOneWidth ++ "px")
            , style "width" (toString triButtonOneWidth ++ "px")
            , style "display" "block"
            , style "position" "absolute"
            , onClick (Usermsg (ColorUserMsg (CClick tri)))
            ]
            []
        ]


makeOneTriButtonTwoThree : Tri -> Html Msg
makeOneTriButtonTwoThree tri =
    let
        ( x, y ) =
            Maybe.withDefault ( 0, 0 ) (List.head tri.pos)

        tDir =
            tri.tdir

        ntopTwo =
            y + triButtonTwoDeltaY

        ntopThree =
            y + triButtonThreeDeltaY

        left =
            case tDir of
                TRight ->
                    x

                TLeft ->
                    x - triButtonTwoThreeWidth
    in
    div
        []
        [ button
            [ style "background-color" "transparent"
            , style "border-style" "none"
            , style "top" (toString ntopTwo ++ "px")
            , style "left" (toString left ++ "px")
            , style "height" (toString triButtonTwoThreeWidth ++ "px")
            , style "width" (toString triButtonTwoThreeWidth ++ "px")
            , style "display" "block"
            , style "position" "absolute"
            , onClick (Usermsg (ColorUserMsg (CClick tri)))
            ]
            []
        , button
            [ style "background-color" "transparent"
            , style "border-style" "none"
            , style "top" (toString ntopThree ++ "px")
            , style "left" (toString left ++ "px")
            , style "height" (toString triButtonTwoThreeWidth ++ "px")
            , style "width" (toString triButtonTwoThreeWidth ++ "px")
            , style "display" "block"
            , style "position" "absolute"
            , onClick (Usermsg (ColorUserMsg (CClick tri)))
            ]
            []
        ]


makeOneTriButtonFour : Tri -> Html Msg
makeOneTriButtonFour tri =
    let
        ( x, y ) =
            Maybe.withDefault ( 0, 0 ) (List.head tri.pos)

        tDir =
            tri.tdir

        ntop =
            y + triButtonFourDeltaY

        nleft =
            case tDir of
                TRight ->
                    x + triButtonFourDeltaX

                TLeft ->
                    x - triButtonFourDeltaX

        l =
            triButtonFourWidth
    in
    div
        []
        [ button
            [ style "background-color" "transparent"
            , style "border-style" "none"
            , style "top" (toString ntop ++ "px")
            , style "left" (toString nleft ++ "px")
            , style "height" (toString l ++ "px")
            , style "width" (toString l ++ "px")
            , style "display" "block"
            , style "position" "absolute"
            , onClick (Usermsg (ColorUserMsg (CClick tri)))
            ]
            []
        ]


makeColorStepBoxes : CSubmodel -> Html Msg
makeColorStepBoxes cmodel =
    let
        colors  =
            cmodel.colors
        ncolor =
            cmodel.nColor
        colorlist =
            List.indexedMap Tuple.pair colors
    in
    div
        [ style "display"
            (if cmodel.result /= CUndetermined then
                "none"

             else
                "block"
            )
        ]
        ( List.map ( makeOneColorBox ncolor ) colorlist )

makeOneColorBox : Int -> ( Int , Int ) -> Html Msg
makeOneColorBox ncolor ( num , color )=
    let
        txt =
            if ncolor == color then
                "Chosen"
            else
                ""

        bgcolor =
            colorToStr color

        y =
            400 + num * 100
    in
    button
        [ style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "font-size" "40px"
        , style "background-color" bgcolor
        , style "stroke" "#fff"
        , style "top" ( ( String.fromInt y ) ++ "px" )
        , style "left" "300px"
        , style "height" "80px"
        , style "width" "150px"
        , style "display" "block"
        , style "position" "absolute"
        , onClick (Usermsg (ColorUserMsg (CNcolor color)))
        ]
        [ text txt
        ]

{-|
    This function defines the view of label.
-}
renderLabel : String -> Html Msg
renderLabel txt =
    div
        [ style "color" "#543939cb"
        , style "font-weight" "300"
        , style "line-height" "1"
        , style "margin" "0 0 0"
        ]
        [ text txt ]

renderChancePanel : CSubmodel -> Html Msg
renderChancePanel {chance} =
    div
        [ style "width" "150px"
        , style "height" "80px"
        , style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "font-size" "60px"
        , style "left" "20px"
        , style "position" "absolute"
        , style "top" "20px"
        ]
        [ renderLabel "Chance"
        , renderCount (chance)
        ]

renderStepPanel : CSubmodel -> Html Msg
renderStepPanel { step,pattern } =
    div
        [ style "width" "150px"
        , style "height" "80px"
        , style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "font-size" "60px"
        , style "left" "20px"
        , style "position" "absolute"
        , style "top" "20px"
        ]
        [ renderLabel "Step"
        , renderCount (( maxStep pattern ) - step)
        ]
{-|
    This function defines the view of count.
-}
renderCount : Int -> Html Msg
renderCount n =
    div
        [ style "color" "#29163d"
        , style "font-size" "80px"
        , style "line-height" "1"
        , style "margin" "10px 10px 0"
        ]
        [ text (String.fromInt n) ]


colorToStr : Int -> String
colorToStr color =
    case color of
        1 ->
            "orange"

        2 ->
            "#3437B6FF"

        3 ->
            "green"

        4 ->
            "red"

        5 ->
            "#d5c055"

        6 ->
            "#8662bd"

        7 ->
            "#a1ce7e"

        8 ->
            "#457019FF"

        9 ->
            "#be8f56"

        10 ->
            "#cf95ff"

        11 ->
            "#4BA3D9FF"

        12 ->
            "#e5d68f"

        13 ->
            "black"

        14 ->
            "#E566D0FF"

        15 ->
            "#eab8e1"

        _ ->
            "black"


colorVFView : CSubmodel -> Html Msg
colorVFView cmodel =
    let
        resultpage =
            case cmodel.result of
                CVictory ->
                    winPage title

                CFailure ->
                    failPage title

                _ ->
                    div [] []
    in
    div
        [ style "display"
            (if cmodel.result == CUndetermined then
                "none"

             else
                "block"
            )
        ]
        [ resultpage
        ]

renderGameIntroPanel : Bool -> Pattern -> Html Msg
renderGameIntroPanel te pattern =
    div
    []
    [introPage title
    ,renderalltext te pattern
    ]

renderalltext : Bool -> Pattern -> Html Msg
renderalltext te pattern =
    div
        [ style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "font-size" "30px"
        , style "height" "800px"
        , style "left" "80px"
        , style "line-height" "1.5"
        , style "padding" "0 15px"
        , style "position" "absolute"
        , style "top" "80px"
        , style "width" "1300px"
        , style "display" "block"
        , style "z-index" "-5"
        ]
        [ getTextBlock 280 200 800 100 (getPlotText te pattern)
        , getTextBlock 80 1100 600 450 (getScoringText te pattern)
        , getTextBlock 440 200 800 550 getGameRuleText
        ]

getPlotText : Bool -> Pattern -> Html Msg
getPlotText te pattern =
    case te of
        True ->
            Markdown.toHtml [] """
Welcome to Color Union! Have a try!
"""
        False ->
            case pattern of
                PHint ->
                    Markdown.toHtml [] """
Welcome to Color Union! Have a try!
"""
                PApple ->
                    Markdown.toHtml [] """
Unify color and Fetch RED pigment!
"""
                PBlueCloth ->
                    Markdown.toHtml [] """
Unify color and Fetch BLUE pigment!
"""
                PGrassRing ->
                    Markdown.toHtml [] """
Unify color and Fetch GREEN pigment!
"""
                PLeaf ->
                    Markdown.toHtml [] """
Could you please help clean the leaves in the pool?
"""
                _ ->
                    Markdown.toHtml [] """
Welcome to Color Union! Have a try!
"""

getScoringText : Bool -> Pattern -> Html Msg
getScoringText te pattern =
    case te of
        True ->
            Markdown.toHtml [] """
Scoring Rule:

Each try doesn't consume hours.

One successful try in Leaf pattern earns you 10 GT points.

One successful try in Pattern1 and Pattern2 earns you 20 and 30 GT points respectively.
"""
        False ->
            case pattern of
                PLeaf ->
                    Markdown.toHtml [] """
Scoring Rule:

Each try doesn't consume hours.

One successful try earns you 10 GT points.
"""
                PApple ->
                    Markdown.toHtml [] """
Scoring Rule:

Each try doesn't consume hours.

One successful try doesn't gain you GT points.

Have fun exploring plot!
"""
                PBlueCloth ->
                    Markdown.toHtml [] """
Scoring Rule:

Each try doesn't consume hours.

One successful try doesn't earn you GT points.

Have fun exploring plot!
"""
                PGrassRing ->
                    Markdown.toHtml [] """
Scoring Rule:

Each try doesn't consume hours.

One successful try doesn't earn you GT points.

Have fun exploring plot!
"""
                _ ->
                    Markdown.toHtml [] """
Scoring Rule:

Each try doesn't consume hours.

One successful try doesn't earn you GT points.

Have fun exploring plot!
 """


getGameRuleText : Html Msg
getGameRuleText =
    Markdown.toHtml [] """
Game Rule:

Each time first click color in the color box and then click the color block in the pattern to change that block into that color.

You need to unify the color in all color blocks into one color within limited steps.

In each try, you can click RESTART button to init the pattern for three times.

Seize each chance to unify the color pattern!
"""

renderOtherInfo : CSubmodel -> Html Msg
renderOtherInfo cmodel =
    div
        [ style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "font-size" "50px"
        , style "line-height" "1.5"
        , style "padding" "0 15px"
        , style "position" "absolute"
        , style "display" "block"
        , style "z-index" "-5"
        , style "display"
            (if cmodel.result /= CUndetermined then
                "none"

             else
                "block"
            )
        ]
        [ getTextBlock 80 1450 250 200 (renderChancePanel cmodel)
        , getTextBlock 300 1450 250 200 (renderStepPanel cmodel)
        ]

title : Html Msg
title =
        Svg.image
                    [ SvgAttr.width "900px"
                    , SvgAttr.x "200px"
                    , SvgAttr.y "80px"
                    , SvgAttr.xlinkHref "assets/colorunion.png"
                    ]
                    []