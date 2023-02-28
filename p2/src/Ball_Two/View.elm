module Ball_Two.View exposing (ballTwoView)
{-| This module controls the part of the view for the game Defeng the fragile.

# Ball2 View Function 
@docs ballTwoView

-}

import Ball_Two.Ball_Two exposing (Dir(..),Scene(..),WinOrFail(..),BallState(..),Ball,Basket,GameStatus(..),Pattern(..),PatternValid(..))
import Ball_Two.Message exposing (BallTwoUserMsg(..))
import Ball_Two.Model exposing (BTwoModel)
import Basis exposing (CharacterIdentity(..), Content(..), Page(..))
import Debug exposing (toString)
import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List exposing (indexedMap)
import Msg exposing (Msg(..),UserMsg(..))
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (cx, cy, fill, r)
import Basis exposing (LibraryBuilding(..))
import Markdown
import GameTransitionView exposing (introPage,failPage,winPage,gamebackground,viewGameScene,viewATPNotenough)
import Ball_Two.SubView exposing(renderEndText,displayMenuButton,showButton,displayExitButton,getPlotText,getScoringText,getGameRuleText,colorblock,showIntroPageButton)

title : Html Msg
title =
        Svg.image
                    [ SvgAttr.width "700px"
                    , SvgAttr.x "220px"
                    , SvgAttr.y "80px"
                    , SvgAttr.xlinkHref "assets/ball2.png"
                    ]
                    []


displayFort : Svg Msg
displayFort  =
    let
        link =
              "assets/fort.png"
              
    in
    Svg.image
        [ SvgAttr.width "25"
        , SvgAttr.height "20"
        , SvgAttr.x "75"
        , SvgAttr.y "80"
        , SvgAttr.xlinkHref link
        ]
        []


displayBall_S2 : Ball -> Svg Msg
displayBall_S2 ball =
    let
        link =
           if ball.ball_angle >= 0 && ball.ball_angle < pi/2 then
              "assets/dart_left.png"
           else if ball.ball_angle > pi/2 && ball.ball_angle <= pi then
              "assets/dart_right.png"
           else 
              "assets/dart_middle.png"
              
    in
    Svg.image
        [ SvgAttr.width (toString (ball.ball_radius*3))
        , SvgAttr.height (toString (ball.ball_radius*3))
        , SvgAttr.x (toString ball.ball_posx)
        , SvgAttr.y (toString ball.ball_posy)
        , SvgAttr.xlinkHref link
        ]
        []

displayBall_S1 : Ball -> Svg Msg
displayBall_S1 ball =
    let
        link =
              "assets/scissors.png"
              
    in
    Svg.image
        [ SvgAttr.width (toString (ball.ball_radius*3))
        , SvgAttr.height (toString (ball.ball_radius*3))
        , SvgAttr.x (toString ball.ball_posx)
        , SvgAttr.y (toString ball.ball_posy)
        , SvgAttr.xlinkHref link
        ]
        []


displayOneBasket_S1  :Basket ->  Svg Msg
displayOneBasket_S1 { basket_posx, basket_posy, basket_radius} =
    let
        link =
            "assets/shield.png"
    in
    Svg.image
        [ SvgAttr.width (toString (basket_radius*3))
        , SvgAttr.height (toString (basket_radius*3))
        , SvgAttr.x (toString basket_posx)
        , SvgAttr.y (toString basket_posy)
        , SvgAttr.xlinkHref link
        ]
        []
        
displayOneBasket_S2  :Basket ->  Svg Msg
displayOneBasket_S2 { basket_posx, basket_posy, basket_radius} =
    let
        link =
            "assets/target.png"
    in
    Svg.image
        [ SvgAttr.width (toString (basket_radius*3))
        , SvgAttr.height (toString (basket_radius*3))
        , SvgAttr.x (toString basket_posx)
        , SvgAttr.y (toString basket_posy)
        , SvgAttr.xlinkHref link
        ]
        []

scenepage : BTwoModel -> Html Msg
scenepage b2model =
    viewGameScene b2model.identity.page

displayBTwoBackground : BTwoModel -> Html Msg
displayBTwoBackground b2model =
    let
        link =
            "assets/badending.jpg"
        nbasket = 
          case b2model.scene of
            Scene1 ->
              List.map displayOneBasket_S1 b2model.basket
            Scene2 ->
              List.map displayOneBasket_S2 b2model.basket
        nball =
           case b2model.scene of
            Scene1 ->
              displayBall_S1 b2model.ball
            Scene2 ->
              displayBall_S2 b2model.ball
        nfort = 
           case b2model.scene of
            Scene1 ->
              displayFort
            Scene2 ->
              Svg.svg [][]
    in 
    case b2model.ball.ball_state of
        NotLaunched ->
            Svg.svg
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.viewBox "0 0 180 90"
                , SvgAttr.xlinkHref link
                ]
                (   List.append (displayDots b2model.ball)  ( nball:: [nfort] )
                    ++  nbasket
                )
                
          
        Launched ->
            Svg.svg
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.viewBox "0 0 180 90"
                , SvgAttr.xlinkHref link
                ]
                (   
                     nbasket ++ ( nball:: [nfort] )
                )

        Judge ->
            Svg.svg
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.viewBox "0 0 180 90"
                , SvgAttr.xlinkHref link
                ]
                (   
                    nbasket  ++ ( nball:: [nfort] )
                )

        Bounce ->
            Svg.svg
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.viewBox "0 0 180 90"
                ]
                (   
                   nbasket ++ ( nball:: [nfort] )
                )

        Over ->
            Svg.svg
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.viewBox "0 0 180 90"
                ]
                (   
                    nbasket ++ ( nball:: [nfort] )
                )

        GameOver ->
            Svg.svg
                []
                []


renderText : String -> Html Msg
renderText txt =
    div
        [ style "color" "black"
        , style "font-weight" "300"
        , style "line-height" "1"
        , style "margin" "30px 0 0"
        ]
        [ text txt ]


showRound : BTwoModel -> Html Msg
showRound b2model =
    div
        [ style "bottom" "50px"
        , style "font-size" "30px"
        , style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "height" "150px"
        , style "left" "10px"
        , style "line-height" "100px"
        , style "position" "absolute"
        ]
        [ renderText ("Round:" ++ toString b2model.round)
        , renderText ("Win:" ++ toString b2model.result.win_num)
        , renderText ("Lose:" ++ toString b2model.result.lose_num)
        ]

renderRoundBlock : BTwoModel -> Html Msg
renderRoundBlock b2model =
  getTextBlock 850 170 150 170 (showRound b2model)

renderTimer : BTwoModel -> Html Msg
renderTimer b2model =
    let
        time =
            round (5 - b2model.time)
    in
    div
        [ style "color" "red"
        , style "bottom" "350px"
        , style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "font-size" "40px"
        , style "height" "150px"
        , style "left" "70px"
        , style "line-height" "100px"
        , style "position" "absolute"
        ]
        [ text ("countdown:" ++ toString time)
        ]


displayPause : BTwoModel -> Html Msg
displayPause b2model =
    let
        ( msg, txt ) =
            case b2model.game_status of
                Prepare ->
                    ( Usermsg (BallTwoUserMsg Pause_prepare), "Pause" )

                Playing ->
                    ( Usermsg (BallTwoUserMsg Pause_playing), "Pause" )

                Paused_prepare ->
                    ( Usermsg (BallTwoUserMsg Start_prepare), "Resume" )

                Paused_playing ->
                    ( Usermsg (BallTwoUserMsg Start_playing), "Resume" )

                _ ->
                    ( Usermsg (BallTwoUserMsg None), " " )
    in
    button
        (List.append displayPauseA (displayPauseB msg))
        [ text txt ]


displayPauseA : List (Attribute msg)
displayPauseA =
    [ style "background" "#34495f"
    , style "border" "0"
    , style "bottom" "100px" 
    , style "color" "#fff"
    , style "cursor" "pointer"
    , style "display" "block"
    , style "font-family" "Comic Sans MS, Comic Sans, cursive"
    , style "font-size" "60px"
    ]


displayPauseB : Msg -> List (Attribute Msg)
displayPauseB msg =
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





-- make an auxiliary line


makeOneDot : ( Int, Float ) -> Svg Msg
makeOneDot ( num, angle ) =
    Svg.circle
        [ cx (toString (88 - (toFloat num * cos angle)))
        , cy (toString (95 - (toFloat num * sin angle)))
        , r "0.2"
        , fill "0f100f"
        ]
        []


displayDots : Ball -> List (Svg Msg)
displayDots ball =
    let
        tmp_list =
            List.repeat 100 ball.ball_angle
    in
    List.map makeOneDot (indexedMap Tuple.pair tmp_list)

getRoundText : BTwoModel -> Html Msg
getRoundText b2model =
   case b2model.result.victory_or_fail of
                RoundVictory ->
                  case b2model.scene of 
                    Scene1 ->
                     Markdown.toHtml [] """
You successfully intercepted the scissors! Continue playing.
 """
                    Scene2 ->  Markdown.toHtml [] """
Your darts hit the target in this round! Continue playing.
"""
                RoundFail ->
                  case b2model.scene of
                    Scene1 ->  Markdown.toHtml [] """
Photos are being destroyed. Please try again to intercept the scissors!
"""
                    Scene2 -> Markdown.toHtml [] """
You darts missed the target in this round. Please try again.
"""
                _ ->
                    Markdown.toHtml [] """
                    """
renderRoundText : BTwoModel ->  Html Msg
renderRoundText b2model =
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
          getTextBlock 300 490 700 150 (getRoundText b2model)
        ]

{-
viewOut : BTwoModel -> Html Msg
viewOut b2model =
    let
        txt =
            "Welcome to ball game 2!"
        info =
            case b2model.te of
                True ->
                    viewPatternChoice b2model
                False ->
                    div[][]

    in
    div
        [ style "color" "#162723"
        , style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "font-size" "30px"
        , style "line-height" "500px"
        , style "position" "fixed"
        , style "width" "100%"
        , style "height" "100%"
        , style "top" "0px"
        , style "left" "0px"
        , style "text-align" "center"
        , style "display" "block"
        ]
        [ text txt
        , text "Not Enough Action points!"
        , info
        , displayExitButton
        ]
-}

renderalltext : BTwoModel -> Page -> Bool -> Html Msg
renderalltext b2model page te =
    div
        [ 
        ]
        [ getTextBlock 280 200 800 100 (getPlotText page b2model)
        , getTextBlock 80 1100 600 400 (getScoringText b2model page te)
        , getTextBlock 440 200 800 550 (getGameRuleText b2model)
        ]


getTextBlock : Float -> Float -> Float -> Float -> Html Msg -> Html Msg
getTextBlock top left width height text =
    colorblock text "#c0c045a8" top left width height


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
          getTextBlock 600 1 800 100 (getInstruction)
        ]


getInstruction :  Html Msg
getInstruction  =
  
                Markdown.toHtml [] """
Press left and right key to 
control the shooting angle.
                """


{-|
    This function is for the view of the whole game Defend the fragile.

-}

ballTwoView : BTwoModel -> Html Msg
ballTwoView b2model =
    case b2model.game_status of
        Intro _ ->
           div
           [     style "width" "100%"
                , style "height" "100%"
                , style "position" "absolute"
                , style "left" "0"
                , style "top" "0"]
            [ scenepage b2model
            , gamebackground
                , introPage title
                , showIntroPageButton b2model
                , renderalltext b2model b2model.identity.page b2model.te
            ]

        ActNotEnough ->
            div
            [     style "width" "100%"
                , style "height" "100%"
                , style "position" "absolute"
                , style "left" "0"
                , style "top" "0"]
            [ scenepage b2model
             ,   viewOut
            ]
        Prepare ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "absolute"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b2model
                , displayBTwoBackground b2model
                , renderRoundBlock b2model
                , renderTimer b2model
                , displayPause b2model
                , renderInstruction
                ]

        Paused_prepare ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b2model
                , displayBTwoBackground b2model
                , renderRoundBlock b2model
                , renderTimer b2model
                , displayPause b2model
                ]

        Playing ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b2model
                , displayBTwoBackground b2model
                , renderRoundBlock b2model
                , displayPause b2model
                ]

        Paused_playing ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b2model
                , displayBTwoBackground b2model
                , renderRoundBlock b2model
                , displayPause b2model
                ]

        JudgeResult ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b2model
                , displayBTwoBackground b2model
                , renderRoundBlock b2model
                ]

        Interval ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b2model
                , displayBTwoBackground b2model
                , renderRoundBlock b2model
                ]

        RoundPage ->
          let
              background = 
                case b2model.result.victory_or_fail of
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
                [ scenepage b2model
                , background
                , renderRoundBlock b2model
                , renderRoundText b2model
                , showButton b2model
                ]

        End ->
            let
                background = 
                 case b2model.result.victory_or_fail of
                   RoundFail ->
                     failPage title
                   RoundVictory ->
                     winPage title
                   _->
                    failPage title
                info =
                    case b2model.te of
                        True ->
                            displayMenuButton
                        False ->
                            showButton b2model
            in
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "fixed"
                , style "left" "0"
                , style "top" "0"
                ]
                [ scenepage b2model
                , background
                , renderEndText b2model
                , info
                ]


viewOut : Html Msg
viewOut =
    div
        []
        [ viewATPNotenough
        , displayExitButton
        ]