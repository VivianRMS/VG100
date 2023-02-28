module Ball_One.View exposing (ball_One)
{-| This module controls the view for the game Company and love.

# Ball1 View Function 
@docs ball_One

-}
import Ball_One.Msg exposing (BallOneUserMsg(..))
import Ball_One.Model exposing (B_OneSubmodel, State(..), PatternValid(..),Pattern(..), BallState(..), Goal)
import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes as HtmlAttr
import Html.Events exposing (onClick)
import Msg exposing (Msg(..), UserMsg(..))
import String exposing (fromFloat, fromInt)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Basis exposing (Page(..))
import Markdown
import GameTransitionView exposing (introPage, gamebackground,viewGameScene,viewATPNotenough)

{-|
    This function is for the view of the whole game Company and love.

-}

ball_One : B_OneSubmodel -> Html Msg
ball_One b_one =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        (viewall b_one)

viewall : B_OneSubmodel -> List (Html Msg)
viewall b_one =
    case b_one.state of
        State_Start patterncheck ->
            [ scenepage b_one
            , viewStart b_one patterncheck
            ]

        Interval ->
            [ scenepage b_one
            , viewInterval b_one ]

        Pass ->
            List.append [ scenepage b_one ] [ viewEnd b_one ]
            |> List.append [ viewButton "Menu" ]

        Fail ->
            List.append [ scenepage b_one ] [ viewEnd b_one ]
            |> List.append [ viewButton "Menu" ]

        State_Pause ->
            scenepage b_one :: viewButton "Resume" :: viewPlay b_one

        ActNotEnough ->
            [ scenepage b_one , viewOut]

        _ ->
            scenepage b_one :: viewButton "Pause" :: viewPlay b_one


title : Html Msg
title =
        Svg.image
                    [ SvgAttr.width "700px"
                    , SvgAttr.x "220px"
                    , SvgAttr.y "80px"
                    , SvgAttr.xlinkHref "assets/ball1.png"
                    ]
                    []


viewOut : Html Msg
viewOut =
    div
        []
        [ viewATPNotenough
        , displayExitButton
        ]

scenepage : B_OneSubmodel -> Html Msg
scenepage b1model =
    viewGameScene b1model.identity.page

renderGameIntroPanel : Page -> Bool -> Html Msg
renderGameIntroPanel page te =
    let
        scoringinfo =
            case te of
                True ->
                    getTextBlock 80 1100 600 780 (getScoringText page te)
                False ->
                    getTextBlock 80 1100 600 460 (getScoringText page te)
    in

    div
        [
        ]
        [ getTextBlock 280 200 800 100  (getPlotText page)
        , scoringinfo
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
        , HtmlAttr.style "height" ( float2str height False True )]
        --, HtmlAttr.style "color" "white"
        [ HtmlAttr.style "font-size" "30px"
        , HtmlAttr.style "line-height" "1.5"
        , HtmlAttr.style "padding" "0 15px"
        , HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "display" "block"
        , HtmlAttr.style "z-index" "-5"
        ]
        )
        [ txt ]

float2str : Float -> Bool -> Bool -> String
float2str x percent px =
    case percent of
        True ->
            ( String.fromFloat x ) ++ "%"
        False ->
            case px of
                True ->
                    ( String.fromFloat x ) ++ "px"
                False ->
                    ( String.fromFloat x )


getPlotText : Page -> Html Msg
getPlotText page =
    case page of
        HintPage ->
            Markdown.toHtml [] """
Welcome to Basketball Game! Have a try!
"""
        _ ->
            Markdown.toHtml [] """
Please help me finish the shoot!
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

Pattern 3 consumes 6 hours. 

One successful try gains 40 GT points.

Pattern 4 consumes 4 hours.

One successful try gains 45 GT points.

Have fun exploring plot!
"""
            else 
                Markdown.toHtml [] """
Scoring Rule:

Pattern 1 consumes 2 hours. 

One successful try gains 20 GT points.

Pattern 2 consumes 4 hours.

One successful try gains 30 GT points.

Have fun exploring plot!
"""

getGameRuleText : Html Msg
getGameRuleText =
    Markdown.toHtml [] """
Game Rule:

Long Press A to launch the ball into the basketball hoop. 

You have five chances.

You have to finish at least one shoot to get GT points.
"""


viewStart : B_OneSubmodel -> PatternValid -> Html Msg
viewStart b1model patterncheck =
    let
        patternchoice =
            case b1model.identity.page of
                HintPage ->
                    div [] []
                _ ->
                    case b1model.te of
                        True ->
                            viewPatternChoice b1model True
                        False ->
                            viewPatternChoice b1model False

        (str,info) =
            case patterncheck of
                ValidPattern ->
                    ("Start",div[][])
                InvalidPattern ->
                    ("Lacking",div[][])

    in
    div
        [ 
        ]
        [ gamebackground
        , introPage title
        , viewButton str
        , renderGameIntroPanel b1model.identity.page b1model.te
        , info
        , patternchoice
        , displayExitButton
        ]



viewPatternChoice : B_OneSubmodel -> Bool -> Html Msg
viewPatternChoice b1model te=
    case te of
        True ->
            div
                []
                [ viewPatternButton Pattern1 1550 180 b1model
                , viewPatternButton Pattern2 1550 330 b1model
                , viewPatternButton Pattern3 1550 480 b1model
                , viewPatternButton Pattern4 1550 630 b1model
                ]
        False ->
            div
                []
                [ viewPatternButton Pattern1 1550 180 b1model
                , viewPatternButton Pattern2 1550 330 b1model
                ]

viewPatternButton : Pattern -> Float -> Float -> B_OneSubmodel -> Html Msg
viewPatternButton pattern x y b1model=
    let
        old_pattern = b1model.pattern
        txt =
            case pattern of
                Pattern1 ->
                    "Pattern 1"
                Pattern2 ->
                    "Pattern 2"
                Pattern3 ->
                    "Pattern 3"
                Pattern4 ->
                    "Pattern 4"
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
        ]

        [
         HtmlAttr.style "top" ( ( fromFloat y )++ "px" )
        , HtmlAttr.style "left" ( ( fromFloat x )++ "px" )
        , HtmlAttr.style "font-weight" "300"
        , HtmlAttr.style "height" "60px"
        , HtmlAttr.style "bottom" "100px"
        , HtmlAttr.style "line-height" "50px"
        , HtmlAttr.style "outline" "none"
        , HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "width" "100px"
        , onClick (Usermsg (BallOneUserMsg ( B1ChoosePattern pattern ) ) )
        ])
        [ text txt
        ]


viewPlay : B_OneSubmodel -> List (Html Msg)
viewPlay b_one =
    [ 
    introPage title    
    , Svg.svg
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        ]
        [ 
         viewGoal b_one.goal
        , viewBall b_one
        ]
    , viewScore b_one
    , viewRoundEnd b_one
    , viewHint
    
    ]




viewBall : B_OneSubmodel -> Svg Msg
viewBall b_one =
    let
        ( x0, y0 ) =
            b_one.ball.anchor

        x =
            fromFloat x0

        y =
            fromFloat y0

        r =
            case b_one.ball.state of
                Stop ->
                    fromFloat b_one.ball.radius

                _ ->
                   case b_one.pattern of
                     Pattern3 ->
                        fromFloat b_one.ball.radius
                     Pattern4 ->
                        fromFloat b_one.ball.radius
                     _->
                          "90"
        link = "assets/basketball.png"
    in
    Svg.image
        [ SvgAttr.width (r ++ "px")
        , SvgAttr.height (r ++ "px")
        , SvgAttr.x (x ++ "px")
        , SvgAttr.y (y ++ "px")
        , SvgAttr.xlinkHref link
        ]
        []


viewGoal : Goal -> Svg Msg
viewGoal goal =
    let
        ( x0, y0 ) =
            goal.anchor

        x =
            fromFloat (x0 + 5 - 130 )

        y =
            fromFloat (y0 + goal.height / 2 + 40)

        link =
            "assets/basketballstand.png"
    in
    Svg.image
        [ SvgAttr.width "30%"
        , SvgAttr.height "30%"
        , SvgAttr.x (x ++ "px")
        , SvgAttr.y (y ++ "px")
        --,  SvgAttr.scale "100px"
        , SvgAttr.xlinkHref link
        ]
        []



viewRoundEnd : B_OneSubmodel -> Html Msg
viewRoundEnd b_one =
    case b_one.ball.state of
        Win _ ->
            div
                [HtmlAttr.style "font-size" "60px" ]
                [ 
                introPage title
                , getTextBlock 500 900 150 60 (div [] [text "Excellent"])
                ]        

        _ ->
            div [] []

    



viewInterval : B_OneSubmodel -> Html Msg
viewInterval b_one =
    let
        txt =
            case b_one.ball.state of
                Win _ ->
                    div [] [text "Excellent"]

                Lose ->
                    div [] [text "Bad"]

                _ ->
                    div [] []
    in
    div
        [HtmlAttr.style "font-size" "60px" ]
        [ 
         introPage title
        , getTextBlock 500 900 150 60 txt
        ]


viewEnd : B_OneSubmodel -> Html Msg
viewEnd b_one =
    div
        []
        [ introPage title
        , getTextBlock 400 650 600 100 (endText b_one)

        ]

endText : B_OneSubmodel ->  Html Msg
endText b_one =
    case b_one.state of
        Pass ->
            Markdown.toHtml [] """
You successfully gain Guard of Time."""
        _ ->
            Markdown.toHtml [] """
You failed to gain Guard of Time."""


viewScore : B_OneSubmodel -> Html Msg
viewScore b_one =
    div []
        [ getTextBlock 900 200 200 40 (getInfoTextA b_one)
        , getTextBlock 950 200 200 40 (getInfoTextB b_one)
        ]
viewHint : Html Msg
viewHint =
    div[]
        [getTextBlock 50 1300 400 100 hintText]

hintText : Html Msg 
hintText =
    div[]
        [text "Long Press A to Launch basketball into the basket"]

getInfoTextA : B_OneSubmodel -> Html Msg
getInfoTextA b_one =
    div[] [ text ("Chance : " ++ fromInt b_one.chance) ]
     
getInfoTextB :  B_OneSubmodel ->Html Msg
getInfoTextB b_one =
    div
        []
        [ text ("Score : " ++ fromInt b_one.score) ]



viewButton : String -> Html Msg
viewButton string =
    let
        (str,msg) =
            case string of
                "Start" ->
                    (string,Usermsg (BallOneUserMsg StartBallOne))

                "Pause" ->
                    (string,Usermsg (BallOneUserMsg PauseBallOne))

                "Resume" ->
                    (string,Usermsg (BallOneUserMsg ResumeBallOne))

                "FailtoStart" ->
                    (string,Usermsg (BallOneUserMsg Locked))
                    
                "Menu" ->
                    (string,Usermsg (BallOneUserMsg B1Game2Plot))

                _ ->
                    (string,Usermsg (BallOneUserMsg StartBallOne))

        --default
    in
    button
        (List.append
            (List.append viewButtonA viewButtonB)
            [ onClick msg ]
        )
        [ text str ]


viewButtonA : List (Attribute msg)
viewButtonA =
    [  HtmlAttr.style "background" "#34495f"
    , HtmlAttr.style "border" "0"
    , HtmlAttr.style "bottom" "100px" 
    , HtmlAttr.style "color" "#fff"
    , HtmlAttr.style "cursor" "pointer"
    , HtmlAttr.style "display" "block"
    , HtmlAttr.style "font-family" "Comic Sans MS, Comic Sans, cursive"
    , HtmlAttr.style "font-size" "60px"
    ]


viewButtonB : List (Attribute msg)
viewButtonB =
    [ HtmlAttr.style "font-weight" "300"
    , HtmlAttr.style "height" "100px"
    , HtmlAttr.style "right" "200px" 
    , HtmlAttr.style "line-height" "60px"
    , HtmlAttr.style "outline" "none"
    , HtmlAttr.style "padding" "0"
    , HtmlAttr.style "position" "absolute"
    , HtmlAttr.style "width" "250px"
    ]

displayExitButton : Html Msg
displayExitButton =
    button
        (List.append displayExitButtonA displayExitButtonB)
        [ text "Exit" ]


displayExitButtonA : List (Attribute msg)
displayExitButtonA =
    [ HtmlAttr.style "background" "#34495f"
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
    , onClick (Usermsg (BallOneUserMsg B1Game2Plot))
    ]
