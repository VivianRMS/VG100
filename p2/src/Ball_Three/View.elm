module Ball_Three.View exposing (ball_Thr)
{-| This module controls the part of the view for the game Seize the wanted.

# Ball2 View Function 
@docs ball_Thr

-}

import Ball_Three.Color exposing (blue, green, lightblue, purple, red, yellow)
import Ball_Three.Message exposing (BallThreeUserMsg(..), ColorType(..), ModelMsgBallThree(..))
import Ball_Three.Model exposing (GameState(..),B_ThrSubmodel,PatternValid(..),Pattern(..),Brick,Cloth)
import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes as HtmlAttr
import Html.Events exposing (onClick)
import Msg exposing (Msg(..), UserMsg(..))
import String exposing (fromFloat, fromInt)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Ball_Three.Color exposing (Color)
import Basis exposing (Page(..))
import Markdown
import GameTransitionView exposing (float2str, introPage, gamebackground,viewGameScene,viewATPNotenough)

title : Html Msg
title =
        Svg.image
                    [ SvgAttr.width "700px"
--                    , SvgAttr.height "800px"
                    , SvgAttr.x "220px"
                    , SvgAttr.y "50px"
                    , SvgAttr.xlinkHref "assets/ball3.png"
                    ]
                    []

{-|
    This function is for the view of the whole game Seize the wanted.

-}

ball_Thr : B_ThrSubmodel -> Html Msg
ball_Thr b_thr =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        (viewall b_thr
         --++[text (Debug.toString b_thr.gamestate),
         --text (Debug.toString b_thr.bricks)]
        )


viewall : B_ThrSubmodel -> List (Html Msg)
viewall b_thr =
    case b_thr.gamestate of
        State_Start patterncheck->
            [ scenepage b_thr , viewStart b_thr patterncheck]

        ActNotEnough ->
            [ scenepage b_thr, viewOut ]


        State_Play ->
             scenepage b_thr :: viewButton "Pause" :: viewplay b_thr

        State_Pause ->
             scenepage b_thr :: viewButton "Resume" :: viewplay b_thr

        Intervalb3 ->
             scenepage b_thr :: nextButton :: viewInterval b_thr

        Win ->
            let
                info =
                    case b_thr.te of
                        True ->
                            displayMenuButton
                        False ->
                            displayExitButton
            in
             scenepage b_thr :: info  :: (List.concat [viewInterval b_thr, [viewWin]] )

        Lose ->
            let
                info =
                    case b_thr.te of
                        True ->
                             displayMenuButton
                        False ->
                            displayExitButton
            in
             scenepage b_thr :: info  :: (List.concat [viewInterval b_thr, [viewLose]] )

scenepage : B_ThrSubmodel -> Html Msg
scenepage b3model =
    viewGameScene b3model.identity.page

viewStart : B_ThrSubmodel -> PatternValid -> Html Msg
viewStart b_thr patterncheck=
    let
        info =
            case b_thr.te of
                True ->
                    viewPatternChoice b_thr
                False ->
                    div [] []
    in
    div []
    [ gamebackground
    , introPage title
    , startButton patterncheck 
    , renderGameIntroPanel b_thr.identity.page b_thr.te
    , info 
    , displayExitButton
--   , text (Debug.toString b_thr.identity.page)
--    , text (Debug.toString b_thr.te)

    ]

renderGameIntroPanel : Page -> Bool -> Html Msg
renderGameIntroPanel page te =
    div
        [
        ]
        [ getTextBlock 280 200 800 100  (getPlotText page)
        , getTextBlock 80 1100 600 400 (getScoringText page te)
        , getTextBlock 440 200 800 550 getGameRuleText
        ]



getTextBlock : Float -> Float -> Float -> Float -> Html Msg -> Html Msg
getTextBlock top left width height text =
    colorblock text "#c0c045a8" top left width height

colorblock : Html Msg -> String -> Float -> Float -> Float -> Float ->Html Msg
colorblock txt color top left width height =
    div
        (List.append 
        [ HtmlAttr.style "background" color
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , HtmlAttr.style "top" ( float2str top False True )
        , HtmlAttr.style "left" ( float2str left False True )
        , HtmlAttr.style "width" ( float2str width False True )
        , HtmlAttr.style "height" ( float2str height False True )
        ]
        [HtmlAttr.style "font-size" "30px"
        , HtmlAttr.style "line-height" "1.5"
        , HtmlAttr.style "padding" "0 15px"
        , HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "display" "block"
        , HtmlAttr.style "z-index" "-5"
        ]
        )
        [ txt ]



getPlotText : Page -> Html Msg
getPlotText page =
    case page of
        HintPage ->
            Markdown.toHtml [] """
Welcome to Seize the wanted! Have a try!
"""
        _ ->
            Markdown.toHtml [] """
Please help me seize the color!
"""

getScoringText : Page -> Bool -> Html Msg
getScoringText page te =
    case page of
        HintPage ->
            Markdown.toHtml [] """
Scoring Rule:

Each try doesn't consume hours.

One successful try doesn't gain you GT points.

Have fun exploring plot!
"""
        _ ->
            if te then
                Markdown.toHtml [] """
Scoring Rule:

Pattern 1 consumes 2 hours. 

One successful try gains 20 GT points.

Pattern 2 consumes 4 hours.

One successful try gains 30 GT points.

Have fun exploring plot!
"""
            else 
                Markdown.toHtml [] """
Scoring Rule:

This game consumes 2 hours. 

One successful try gains 20 GT points.

Have fun exploring plot!
"""

getGameRuleText : Html Msg
getGameRuleText =
    Markdown.toHtml [] """
Game Rule:

Press Top Down Left Right arrow keys to move the white cloth.
In every round, the wanted color is shown on top left.
If the wanted color drops on the cloth, your score will be added.
If the unwanted color drops on the cloth, your score will be reduced.
The game has three rounds.
You have to get at least 10 score for each color.
"""



renderInstruA : Html Msg
renderInstruA =
    div
        [ HtmlAttr.style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , HtmlAttr.style "font-size" "40px"
        , HtmlAttr.style "font-weight" "bold"
        , HtmlAttr.style "line-height" "60px"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "top" "45%"
        , HtmlAttr.style "left" "28%"
        , HtmlAttr.style "width" "1500px"
        , HtmlAttr.style "height" "150px"
        ]
        [ text "Press key arrows to move the cloth, Catch the wanted colors!" ]

{-
viewOut : B_ThrSubmodel -> List (Html Msg )
viewOut b_thr =
    [ outButton , renderInstruA , viewPatternChoice b_thr , displayExitButton ]

outButton : Html Msg
outButton =
    div
        [ HtmlAttr.style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , HtmlAttr.style "font-size" "40px"
        , HtmlAttr.style "font-weight" "bold"
        , HtmlAttr.style "line-height" "60px"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "top" "80px"
        , HtmlAttr.style "left" "60px"
        , HtmlAttr.style "width" "1000px"
        , HtmlAttr.style "height" "150px"
        ]
        [ text "Not Enough Hours!"
        ]
-}
viewplay : B_ThrSubmodel -> List (Html Msg)
viewplay b_thr =
 case b_thr.pattern of
   Pattern1 ->
     [ introPage title
     , viewScoreBoard
       ,  Svg.svg
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.viewBox "0 0 160 90"
        ]
        (viewInfo_P1 b_thr.colorNeed_P1
            ++ [ viewCloth b_thr.cloth ]
            ++ List.map viewBrick b_thr.bricks
        )
      , renderScore_P1 b_thr
     ]
   Pattern2 ->
    [ introPage title
    , viewScoreBoard
        ,Svg.svg
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.viewBox "0 0 160 90"
        ]
        (viewInfo_P2 b_thr.colorNeed_P2
            ++ [ viewCloth b_thr.cloth ]
            ++ List.map viewBrick b_thr.bricks
        )
    , renderScore_P2 b_thr
    ]


viewBrick : Brick -> Svg Msg
viewBrick brick =
    let
        ( x0, y0 ) =
            brick.anchor

        x =
            fromFloat x0

        y =
            fromFloat y0

        h =
            fromFloat (brick.height*2.5)

        w =
            fromFloat (brick.width*2.5)

    in
    Svg.image
        [ SvgAttr.width (w ++ "px")
        , SvgAttr.height (h ++ "px")
        , SvgAttr.x (x ++ "px")
        , SvgAttr.y (y ++ "px")
        , SvgAttr.xlinkHref (blockImage brick.color.color)
        ]
        []


blockImage : Color -> String
blockImage color =
    if color == red then
        "assets/redblock2.png"
    else if color == lightblue then
        "assets/blueblock.png"
    else 
        if color == blue then
            "assets/darkblueblock.png"
        else if color == green then
            "assets/greenblock.png"
        else 
            if color == yellow then
                "assets/yellowblock.png"
            else "assets/purpleblock.png"


viewCloth : Cloth -> Svg Msg
viewCloth cloth =
    let
        ( x0, y0 ) =
            cloth.anchor

        x =
            fromFloat x0

        y =
            fromFloat y0

        link =
            "assets/whitecloth.png"
    in
    Svg.image
        [ SvgAttr.width "40px"
        , SvgAttr.height  "40px"
        , SvgAttr.x (x ++ "px")
        , SvgAttr.y (y ++ "px")
        , SvgAttr.xlinkHref link
        ]
        []


viewScoreBoard :  Html Msg
viewScoreBoard =
     getTextBlock 800 150 400 250  (div [] [])


viewInfo_P1 : ColorType -> List (Svg Msg)
viewInfo_P1 tp =
    case tp of
        Dark ->
            [ Svg.image
                [ SvgAttr.x "3px"
                , SvgAttr.y "67px"
                , SvgAttr.width "20%"
                , SvgAttr.height "20%"
                , SvgAttr.xlinkHref (blockImage red)
                ]
                []
            , Svg.image
                [ SvgAttr.x "15px"
                , SvgAttr.y "67px"
                , SvgAttr.width "20%"
                , SvgAttr.height "20%"
                , SvgAttr.xlinkHref (blockImage green)
                ]
                []
            , Svg.image
                [ SvgAttr.x "27px"
                , SvgAttr.y "67px"
                , SvgAttr.width "20%"
                , SvgAttr.height "20%"
                , SvgAttr.xlinkHref (blockImage blue)
                ]
                []
            ]

        Light ->
            [ Svg.image
                [ SvgAttr.x "3px"
                , SvgAttr.y "67px"
                , SvgAttr.width "20%"
                , SvgAttr.height "20%"
                , SvgAttr.xlinkHref (blockImage yellow)
                ]
                []
            , Svg.image
                [ SvgAttr.x "15px"
                , SvgAttr.y "67px"
                , SvgAttr.width "20%"
                , SvgAttr.height "20%"
                , SvgAttr.xlinkHref (blockImage lightblue)
                ]
                []
            , Svg.image
                [ SvgAttr.x "27px"
                , SvgAttr.y "67px"
                , SvgAttr.width "20%"
                , SvgAttr.height "20%"
                , SvgAttr.xlinkHref (blockImage purple)
                ]
                []
            ]

viewInfo_P2 : Color -> List (Svg Msg)
viewInfo_P2 color =
           [Svg.image
                [ SvgAttr.x "3px"
                , SvgAttr.y "67px"
                , SvgAttr.width "20%"
                , SvgAttr.height "20%"
                , SvgAttr.xlinkHref (blockImage color)
                ]
                []
           ]
    
setAttr : Float -> Float -> List (Html.Attribute Msg)
setAttr x y =
    [ HtmlAttr.style "font-family" "Comic Sans MS, Comic Sans, cursive"
    , HtmlAttr.style "font-size" "25px"
    
    , HtmlAttr.style "line-height" "60px"
    , HtmlAttr.style "position" "fixed"
    , HtmlAttr.style "top" (fromFloat y ++ "%")
    , HtmlAttr.style "left" (fromFloat x ++ "%")
    , HtmlAttr.style "width" "500px"
    , HtmlAttr.style "height" "80px"
    ]


renderScore_P1 : B_ThrSubmodel -> Html Msg
renderScore_P1 b_thr =
    let
        getTuple =
            case b_thr.colorNeed_P1 of
                Dark ->
                    Tuple.first

                Light ->
                    Tuple.second
    in
    div
        []
        [ div
            (setAttr 9 88)
            
            [ text "Score : "]
        , div
            (setAttr 11 90) 
            
            [ text (fromInt (getTuple b_thr.score.pair1)) ]
        , div
            (setAttr 19 90)
            
            [ text (fromInt (getTuple b_thr.score.pair2)) ]
        , div
            (setAttr 27 90)
            
            [ text (fromInt (getTuple b_thr.score.pair3)) ]
        , div
            (setAttr 9 75)
            
            [ text "Wanted Colors: " ]
        ]

renderScore_P2 : B_ThrSubmodel -> Html Msg
renderScore_P2 b_thr =
        div
        []
        [ div
            (setAttr 9 88)
            [ text ("Score : " ++ fromInt b_thr.total_score) ]
         ,  div
            (setAttr 9 75)
            [ text "Wanted Color: " ]
        ]


viewInterval : B_ThrSubmodel -> List (Html Msg)
viewInterval b_thr =
 case b_thr.pattern of
  Pattern1 ->
     [ introPage title
     , getTextBlock 330 630 650 550  (div [] [])
        , Svg.svg
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.viewBox "0 0 160 90"
        ]
        [ Svg.image
            [ SvgAttr.x "45px"
            , SvgAttr.y "25px"
            , SvgAttr.width "20%"
            , SvgAttr.height "20%"
            , SvgAttr.xlinkHref (blockImage red)
            ]
            []
        , Svg.image
            [ SvgAttr.x "65px"
            , SvgAttr.y "25px"
            , SvgAttr.width "20%"
            , SvgAttr.height "20%"
            , SvgAttr.xlinkHref (blockImage green)
            ]
            []
        , Svg.image
            [ SvgAttr.x "85px"
            , SvgAttr.y "25px"
            , SvgAttr.width "20%"
            , SvgAttr.height "20%"
            , SvgAttr.xlinkHref (blockImage blue)
            ]
            []
        , Svg.image
            [ SvgAttr.x "45px"
            , SvgAttr.y "45px"
            , SvgAttr.width "20%"
            , SvgAttr.height "20%"
            , SvgAttr.xlinkHref (blockImage yellow)
            ]
            []
        , Svg.image
            [ SvgAttr.x "65px"
            , SvgAttr.y "45px"
            , SvgAttr.width "20%"
            , SvgAttr.height "20%"
            , SvgAttr.xlinkHref (blockImage lightblue)
            ]
            []
        , Svg.image
            [ SvgAttr.x "85px"
            , SvgAttr.y "45px"
            , SvgAttr.width "20%"
            , SvgAttr.height "20%"
            , SvgAttr.xlinkHref (blockImage purple)
            ]
            []
        ]
    , div
        (setAttr 37 45)
        [ text (fromInt (Tuple.first b_thr.score.pair1)) ]
    , div
        (setAttr 50 45)
        [ text (fromInt (Tuple.first b_thr.score.pair2)) ]
    , div
        (setAttr 63 45)
        [ text (fromInt (Tuple.first b_thr.score.pair3)) ]
    , div
        (setAttr 37 68)
        [ text (fromInt (Tuple.second b_thr.score.pair1)) ]
    , div
        (setAttr 50 68)
        [ text (fromInt (Tuple.second b_thr.score.pair2)) ]
    , div
        (setAttr 63 68)
        [ text (fromInt (Tuple.second b_thr.score.pair3)) ]
    , div
        (setAttr 35 75)
        [ text "The score of each color must > 10." ]
    ]
  Pattern2 ->
     [ Svg.svg
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.viewBox "0 0 160 90"
        ]
        []
      , div
        (setAttr 50 45)
        [ text (fromInt b_thr.total_score) ]
      , div
        (setAttr 50 68)
        [ text "Your score:" ]
      , div
        (setAttr 35 75)
        [ text "Your total score must be over 50. " ]
    ]


viewWin : Html Msg
viewWin =
    div
        []
        [ 
         --introPage title
          getTextBlock 500 200 50 50 (div[] [ text "Victory!" ]) 
            
        ]


viewLose : Html Msg
viewLose =
    div
        []
        [ --introPage title
         getTextBlock 500 200 50 50 (div[] [ text "Lose!"]) 
        ]


startButton : PatternValid -> Html Msg
startButton patterncheck =
    let
        (str,msg) =
            case patterncheck of
                ValidPattern ->
                    ("Start",Usermsg (BallThreeUserMsg StartBallThree))
                InvalidPattern ->
                    ("Lacking",Usermsg (BallThreeUserMsg Locked))
    in
    button
        (List.append viewButtonA (viewButtonB msg))
        [ text str ]


startButtonA : List (Attribute msg)
startButtonA =
    [ HtmlAttr.style "background" "#34495f"
    , HtmlAttr.style "border" "0"
    , HtmlAttr.style "bottom" "100px" 
    , HtmlAttr.style "color" "#fff"
    , HtmlAttr.style "cursor" "pointer"
    , HtmlAttr.style "display" "block"
    , HtmlAttr.style "font-family" "Comic Sans MS, Comic Sans, cursive"
    , HtmlAttr.style "font-size" "60px"
    ]




displayExitButton : Html Msg
displayExitButton =
    button
        (List.append displayExitButtonA displayExitButtonB)
        [ text "Exit" ]


displayMenuButton : Html Msg
displayMenuButton =
    button
        (List.append displayExitButtonA displayExitButtonB)
        [ text "Menu" ]

displayExitButtonA : List (Attribute msg)
displayExitButtonA =
    [  HtmlAttr.style "background" "#34495f"
    , HtmlAttr.style "border" "0"
    , HtmlAttr.style "bottom" "100px" 
    , HtmlAttr.style "color" "#fff"
    , HtmlAttr.style "cursor" "pointer"
    , HtmlAttr.style "display" "block"
    , HtmlAttr.style "font-family" "Comic Sans MS, Comic Sans, cursive"
    , HtmlAttr.style "font-size" "60px"
    ]


displayExitButtonB : List (Attribute Msg)
displayExitButtonB =
    [ HtmlAttr.style "font-weight" "300"
    , HtmlAttr.style "height" "100px"
    , HtmlAttr.style "right" "600px" 
    , HtmlAttr.style "line-height" "60px"
    , HtmlAttr.style "outline" "none"
    , HtmlAttr.style "padding" "0"
    , HtmlAttr.style "position" "absolute"
    , HtmlAttr.style "width" "250px"
    , onClick (Usermsg (BallThreeUserMsg B3Game2Plot))
    ]


nextButton : Html Msg
nextButton =
    button
        (List.append startButtonA nextButtonB)
        [ text "Next" ]


nextButtonB : List (Attribute Msg)
nextButtonB =
    [  HtmlAttr.style "font-weight" "300"
    , HtmlAttr.style "height" "100px"
    , HtmlAttr.style "right" "200px" 
    , HtmlAttr.style "line-height" "60px"
    , HtmlAttr.style "outline" "none"
    , HtmlAttr.style "padding" "0"
    , HtmlAttr.style "position" "absolute"
    , HtmlAttr.style "width" "250px"
    , onClick (Usermsg (BallThreeUserMsg NextBallThree))
    ]


viewButton : String -> Html Msg
viewButton string =
    let
        msg =
            case string of
                "Start" ->
                    Usermsg (BallThreeUserMsg StartBallThree)

                "Pause" ->
                    Usermsg (BallThreeUserMsg Pause)

                "Resume" ->
                    Usermsg (BallThreeUserMsg Resume)

                _ ->
                    Usermsg (BallThreeUserMsg NextBallThree)

        --default
    in
    button
        (List.append viewButtonA (viewButtonB msg))
        [ text string ]


viewButtonA : List (Attribute msg)
viewButtonA =
    [ HtmlAttr.style "background" "#34495f"
    , HtmlAttr.style "border" "0"
    , HtmlAttr.style "bottom" "100px" 
    , HtmlAttr.style "color" "#fff"
    , HtmlAttr.style "cursor" "pointer"
    , HtmlAttr.style "display" "block"
    , HtmlAttr.style "font-family" "Comic Sans MS, Comic Sans, cursive"
    , HtmlAttr.style "font-size" "60px"
    ]


viewButtonB : Msg -> List (Attribute Msg)
viewButtonB msg =
    [HtmlAttr.style "font-weight" "300"
    , HtmlAttr.style "height" "100px"
    , HtmlAttr.style "right" "200px" 
    , HtmlAttr.style "line-height" "60px"
    , HtmlAttr.style "outline" "none"
    , HtmlAttr.style "padding" "0"
    , HtmlAttr.style "position" "absolute"
    , HtmlAttr.style "width" "250px"
    , onClick msg
    ]

viewPatternChoice : B_ThrSubmodel -> Html Msg
viewPatternChoice b3model =
    div
        []
        [ viewPatternButton Pattern1 1550 180 b3model
        , viewPatternButton Pattern2 1550 330 b3model
        ]

viewPatternButton : Pattern -> Float -> Float -> B_ThrSubmodel -> Html Msg
viewPatternButton pattern x y b3model=
    let
        old_pattern = b3model.pattern
        (txt,npattern) =
            case pattern of
                Pattern1 ->
                    ("Pattern 1",1)
                Pattern2 ->
                    ("Pattern 2",2)
        color =
           if old_pattern == pattern then
                "#bf99f8cc"
           else
                "#e5cc5c"
    in
    div
        (List.append [HtmlAttr.style "background" color
        , HtmlAttr.style "border" "2"
        , HtmlAttr.style "color" "white"
        , HtmlAttr.style "cursor" "pointer"
        , HtmlAttr.style "display" "block"
        , HtmlAttr.style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , HtmlAttr.style "font-size" "20px"
        , HtmlAttr.style "top" ( ( fromFloat y )++ "px" )
        , HtmlAttr.style "left" ( ( fromFloat x )++ "px" )
        ][
          HtmlAttr.style "font-weight" "300"
        , HtmlAttr.style "height" "60px"
        , HtmlAttr.style "bottom" "100px"
        , HtmlAttr.style "line-height" "50px"
        , HtmlAttr.style "outline" "none"
        , HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "width" "100px"
        , onClick (Usermsg (BallThreeUserMsg ( B3ChoosePattern npattern ) ) )
        ])
        [ text txt
        ]

viewOut : Html Msg
viewOut =
    div
        []
        [ viewATPNotenough
        , displayExitButton
        ]