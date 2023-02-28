module Ball_Four.View exposing (viewGameScene2,viewOut,viewPatternButton,viewPatternChoice,ballFourView)

{-| This module controls the part of the view for the game Break the loop.

# Ball4 View Function of Button
@docs viewPatternButton

# Ball4 View Function of Scece
@docs viewGameScene2, viewOut

# Ball4 View Function of Text
@docs viewPatternChoice

# Ball4 view function of the whole game
@docs ballFourView

-}

import Ball_Four.Ball_Four exposing (WinOrFail(..),BallState(..),GameStatus(..),Pattern(..),PatternValid(..))
import Ball_Four.Message exposing (BallFourUserMsg(..))
import Ball_Four.Model exposing (BFourModel)
import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Msg exposing (Msg(..),UserMsg(..))
import Svg 
import Svg.Attributes as SvgAttr exposing (x, y)
import String exposing (fromFloat)
import Markdown
import Basis exposing (CharacterIdentity(..), Content(..), Page(..))
import GameTransitionView exposing (failPage,winPage)
import GameTransitionView exposing (gamebackground)

import Ball_Four.SubView exposing (showRound,displayEndMenuButton, displayEndExitButton, displayExitButton,displayPause,scenepage,displayBFourBackground,renderRoundBlock,renderEndText)
import GameTransitionView exposing (getTextBlock,viewATPNotenough)



showButton : BFourModel -> Html Msg
showButton b4model =
    let
        ( msg, txt , txt2) =
            case b4model.game_status of
                Intro patterncheck ->
                    case patterncheck of
                        ValidPattern ->
                            ( Usermsg (BallFourUserMsg EnterBallFour), "Start" , "")
                        InvalidPattern ->
                            ( Usermsg (BallFourUserMsg Locked) , "Lacking" , "" )

                RoundPage ->
                    ( Usermsg (BallFourUserMsg NextBallFour), "Next" , "")

                End ->
                    ((Usermsg (BallFourUserMsg B4Game2Plot)) , "Exit" , "")

                _ ->
                    ( Usermsg (BallFourUserMsg None), "" , "")
    in
    button
        (List.append showButtonA (showButtonB msg))
        [ text txt
        , text txt2
        ]


showButtonA : List (Attribute msg)
showButtonA =
    [ style "background" "#34495f"
    , style "border" "0"
    , style "bottom" "100px" 
    , style "color" "#fff"
    , style "cursor" "pointer"
    , style "display" "block"
    , style "font-family" "Comic Sans MS, Comic Sans, cursive"
    , style "font-size" "60px"
    ]


showButtonB : Msg -> List (Attribute Msg)
showButtonB msg =
    [ style "font-weight" "300"
    , style "height" "100px"
    , style "right" "200px" 
    , style "line-height" "60px"
    , style "outline" "none"
    , style "padding" "0"
    , style "position" "absolute"
    , style "width" "250px"
    , onClick msg
    ]


renderalltext : BFourModel -> Page -> Bool -> Html Msg
renderalltext b4model page te =
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
        [ getTextBlock 280 150 800 100 (getPlotText page b4model)
        , getTextBlock 80 1050 540 400 (getScoringText page te)
        , getTextBlock 440 150 800 510 (getGameRuleText b4model)
        ]

getTextBlock : Float -> Float -> Float -> Float -> Html Msg -> Html Msg
getTextBlock top left width height text =
    colorblock text "#c0c045a8" top left width height

colorblock : Html Msg -> String -> Float -> Float -> Float -> Float ->Html Msg
colorblock txt color top left width height =
    div
        ( List.append
         [ style "background" color
        , style "position" "fixed"
        , style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "top" ( float2str top False True )
        , style "left" ( float2str left False True )
        , style "width" ( float2str width False True )
        , style "height" ( float2str height False True )]

        [ style "font-size" "30px"
        , style "line-height" "1.5"
        , style "padding" "0 15px"
        , style "position" "absolute"
        , style "display" "block"
        , style "z-index" "-5"
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


getPlotText : Page -> BFourModel -> Html Msg
getPlotText page b4model=
    case page of
        HintPage ->
               Markdown.toHtml [] 
               """
Shoot the ball towards the moving hole!
                """
        _ ->
          case b4model.pattern of
            Pattern1 ->
              Markdown.toHtml [] """
Shoot the ball to break the loop!
                """
            Pattern2 ->
               Markdown.toHtml [] """
Shoot the ball towards the moving hole! 
                """

getScoringText : Page -> Bool -> Html Msg
getScoringText page te =
  case page of 
    HintPage ->
                Markdown.toHtml [] """
Each try doesn't consume hours.

One successful try doesn't gain you GT points.

Shoot the ball towards the moving hole!
                """
    _ ->
            if te then
                Markdown.toHtml [] """
Scoring Rule:

Pattern 1 consumes 2 hours. 

One successful try gains 20 GT points.

Pattern 2 consumes 4 hours.

One successful try gains 30 GT points.
"""
            else 
                Markdown.toHtml [] """
Scoring Rule:

This game consumes 2 hours. 

One successful try gains 20 GT points.

Have fun exploring plot!
"""



getGameRuleText : BFourModel -> Html Msg
getGameRuleText b4model=
 case b4model.pattern of
    Pattern1 ->
      Markdown.toHtml [] """       
Game Rule:
You need to make the ball pass through the hole
without being struck and reflected. 

The hole's moving trajectory is the word "Loop".

You only have five chances! 
As long as the ball passes the hole once you'll win.

The ball's trajectory is straight line 
and when adjusting angle, 
a dotted line will be used to 
indicate the straight trajectory if released.
             """
    Pattern2 ->
     Markdown.toHtml [] """       
Game Rule:
You need to make the ball pass through the hole
without being struck and reflected. 

The hole's moving trajectory is the word "summer", 

You only have five chances!
As long as the ball passes the hole once you'll win. 

The ball's trajectory is straight line 
and when adjusting angle, 
a dotted line will be used to 
indicate the straight trajectory if released.
             """


renderInstruction :  Html Msg
renderInstruction =
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
        [ 
          getTextBlock 500 1 800 200 (getInstruction)
        ]


getInstruction :  Html Msg
getInstruction  =
  
                Markdown.toHtml [] """
Press left or right key and up and down key 
to control the shooting angle and range.
Then press the space key to release the ball. 
                """
    
getRoundText : BFourModel -> Html Msg
getRoundText b4model =
   case b4model.result.round_result of
                RoundVictory ->
                  Markdown.toHtml []"""
You win in this round! Continue playing.
                    """

                RoundFail ->
                  Markdown.toHtml []"""
The ball is out of the hole. Please try again.
                    """
                _ ->
                    Markdown.toHtml []"""
                    
                    """

renderRoundText : BFourModel ->  Html Msg
renderRoundText b4model =
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
        [ 
          getTextBlock 300 490 700 90 (getRoundText b4model)
        ]


showIntroPageButton : BFourModel -> Html Msg
showIntroPageButton b4model =
    let
        
        info =
            case b4model.te of
                True ->
                    viewPatternChoice b4model
                False ->
                    div[][]
    in
    div
        [ style "color" "#162723"
        , style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "font-size" "30px"
        , style "line-height" "100px"
        , style "position" "absolute"
        , style "width" "100%"
        , style "height" "100%"
        , style "text-align" "center"
        , style "display" "block"
        ]
        [ showButton b4model
        , info
        , displayExitButton
        ]

title : Html Msg
title =
        Svg.image
                    [ SvgAttr.width "700px"
                    , SvgAttr.x "220px"
                    , SvgAttr.y "80px"
                    , SvgAttr.xlinkHref "assets/ball4.png"
                    ]
                    []
{-|
    This function is for the view of the game scene when action point is not enough.

-}

viewOut : Html Msg
viewOut =
    div
        []
        [ viewATPNotenough
        , displayExitButton
        ]



introPage : Html Msg -> Html Msg
introPage gamename =
                div
                 [ style "width" "100%"
                 , style "height" "100%"
                 , style "position" "fixed"
                 , style "left" "0px"
                 , style "top" "0px"
                 , style "z-index" "-5"
                 ]
                 [
                    Svg.svg
                    [SvgAttr.width "100%"
                     ,SvgAttr.height "100%"]
                    [ Svg.image
                    [ SvgAttr.width "1600px"
                    , SvgAttr.x "150px"
                    , SvgAttr.y "30px"
                    , SvgAttr.xlinkHref "assets/intro.jpg"
                    ]
                    []
                    , gamename
                    ]
                 ]


{-|
    This function is for the game background scene in the church.

-}

viewGameScene2 :  Html Msg
viewGameScene2 =
    div

        [     style "width" "100%"
            , style "height" "100%"
            , style "position" "fixed"
            , style "left" "0"
            , style "top" "0"
            , style "z-index" "-10"
        ]
        [
            Svg.svg
            [SvgAttr.width "100%"
             ,SvgAttr.height "100%"]
            [Svg.image
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.xlinkHref "assets/ChurchNotCry.jpg"
            ]
            []]
        ]

{-|
    This function is for the view of the whole game Break the loop.

-}

ballFourView : BFourModel -> Html Msg
ballFourView b4model =
    case b4model.game_status of
        Intro _ ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b4model
                , gamebackground
                , introPage title
                , showIntroPageButton b4model
                , renderalltext b4model b4model.identity.page b4model.te 
                ]

        Prepare ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b4model
                , displayBFourBackground b4model
                , renderInstruction
                , renderRoundBlock b4model
                , displayPause b4model
                ]

        Playing ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b4model
                , renderRoundBlock b4model
                , displayBFourBackground b4model
                , displayPause b4model
                ]

        Paused_prepare ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b4model
                , renderRoundBlock b4model
                , displayBFourBackground b4model
                , displayPause b4model
                ]

        Paused_playing ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b4model
                , renderRoundBlock b4model
                , displayBFourBackground b4model
                , displayPause b4model
                ]

        Interval ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b4model
                , renderRoundBlock b4model
                , displayBFourBackground b4model
                ]

        RoundPage ->
          let
              background = 
                case b4model.result.victory_or_fail of
                    RoundFail ->
                        failPage title
                    RoundVictory ->
                        winPage title
                    _ ->
                        failPage title
                  
          in
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b4model
                , showButton b4model
                , background
                , renderRoundBlock b4model
                , renderRoundText b4model
                ]

        End ->
            let
                info =
                    case b4model.te of
                        True ->
                            displayEndMenuButton
                        False ->
                            displayEndExitButton
                background = 
                  case b4model.result.victory_or_fail of
                   RoundFail ->
                     failPage title
                   RoundVictory ->
                     winPage title
                   _->
                    failPage title
            in
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b4model
                , background
                , renderRoundBlock b4model
                , renderEndText b4model
                , info
                ]

        ActNotEnough ->
            div
            [     style "width" "100%"
                , style "height" "100%"
                , style "position" "absolute"
                , style "left" "0"
                , style "top" "0"]
            [ viewOut ]
        _ ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b4model
                , displayBFourBackground b4model
                , showRound b4model
                ]
{-|
    This function is for the view of text of pattern choice.

-}

viewPatternChoice : BFourModel -> Html Msg
viewPatternChoice b4model =
    div
        []
        [ viewPatternButton Pattern1 1550 180 b4model
        , viewPatternButton Pattern2 1550 330 b4model
        ]

{-|
    This function is for the view of pattern button.

-}

viewPatternButton : Pattern -> Float -> Float -> BFourModel -> Html Msg
viewPatternButton pattern x y b4model=
    let
        old_pattern = b4model.pattern
        (txt,npattern) =
            case pattern of
                Pattern1 ->
                    ( "Pattern 1" , 1 )
                Pattern2 ->
                    ( "Pattern 2" , 2 )
        color =
           if old_pattern == pattern then
                "#bf99f8cc"
           else
                "#e5cc5c"
    in
    div
        ( style "background" color
        :: style "border" "2"
        :: style "color" "white"
        :: style "cursor" "pointer"
        :: style "display" "block"
        :: style "font-family" "Comic Sans MS, Comic Sans, cursive"
        :: style "font-size" "20px"
        :: style "top" ( ( fromFloat y )++ "px" )
        :: style "left" ( ( fromFloat x )++ "px" )
        :: style "font-weight" "300"
        :: style "height" "60px"
        :: style "bottom" "100px"
        :: style "line-height" "50px"
        :: style "outline" "none"
        :: style "position" "absolute"
        :: style "width" "100px"
        :: [onClick (Usermsg (BallFourUserMsg ( B4ChoosePattern npattern ) ) )]
        )
        [ text txt
        ]

