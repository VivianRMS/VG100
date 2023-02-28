module Ball_Four.SubView exposing (showRound,displayEndMenuButton, displayEndExitButton, displayExitButton,displayPause,scenepage,displayBFourBackground,renderRoundBlock,renderEndText)

{-| This module controls the part of the view for the game Break the loop.

# Ball4 View Function of Button
@docs displayEndMenuButton, displayEndExitButton, displayExitButton,displayPause

# Ball4 View Function of Scece
@docs scenepage, displayBFourBackground, renderRoundBlock

# Ball4 View Function of Text
@docs showRound, renderEndText

-}


import Ball_Four.Model exposing (BFourModel)
import Ball_Four.Ball_Four exposing (GameStatus(..),Pattern(..),BallState(..),Ball,WinOrFail(..))
import Ball_Four.Message exposing (BallFourUserMsg(..))
import Ball_Four.Model exposing (BFourModel)
import Debug exposing (toString)
import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..),UserMsg(..))
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (cx,cy,r,fill)
import Basis exposing (CharacterIdentity(..), Content(..), Page(..))
import GameTransitionView exposing (viewGameScene,getTextBlock)
import Svg
import Markdown


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

displayBall : BFourModel -> Svg Msg
displayBall b4model =
    let
        link =
          case b4model.pattern of
            Pattern1 ->
              "assets/ball4_S1.png"
            Pattern2 ->
              "assets/ball4_S2.png "
              
    in
    Svg.image
        [ SvgAttr.width (toString (b4model.ball.ball_radius*2))
        , SvgAttr.height (toString (b4model.ball.ball_radius*2))
        , SvgAttr.x (toString b4model.ball.ball_posx)
        , SvgAttr.y (toString b4model.ball.ball_posy)
        , SvgAttr.xlinkHref link
        ]
        []


displayBoard : BFourModel -> Svg Msg
displayBoard b4model =
    let
        link =
          case b4model.pattern of
            Pattern1 ->
              "assets/loop_board.jpg"
            Pattern2 ->
              "assets/summer_board.jpg" 
    in
    Svg.image
        [ SvgAttr.width "100"
        , SvgAttr.height "42"
        , SvgAttr.x "40"
        , SvgAttr.y "2"
        , SvgAttr.xlinkHref link
        ]
        []



displayHole : BFourModel -> Svg Msg
displayHole b4model =
    let
        link =
          case b4model.pattern of
            Pattern1 ->
              "assets/loop_hole.png"
            Pattern2 ->
              "assets/summer_hole.png"
              
    in
    Svg.image
        [ SvgAttr.width (toString (b4model.hole.hole_radius*3))
        , SvgAttr.height (toString (b4model.hole.hole_radius*3))
        , SvgAttr.x (toString b4model.hole.hole_posx)
        , SvgAttr.y (toString b4model.hole.hole_posy)
        , SvgAttr.xlinkHref link
        ]
        []

{-|
    This function is for the view of game background.

-}

displayBFourBackground : BFourModel -> Html Msg
displayBFourBackground b4model =
    case b4model.ball.ball_state of
        NotLaunched ->
            Svg.svg
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.viewBox "0 0 180 90"
                ]
                (   displayBoard b4model
                    :: displayHole b4model
                    :: displayBall b4model
                    :: displayDots b4model.ball
                )

        Launched ->
            Svg.svg
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.viewBox "0 0 180 90"
                ]
                [ displayBoard b4model
                , displayHole b4model
                , displayBall b4model
                ]

        Judge ->
            Svg.svg
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.viewBox "0 0 180 90"
                ]
                [ displayBoard b4model
                , displayHole b4model
                , displayBall b4model
                ]

        Bounce ->
            Svg.svg
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.viewBox "0 0 180 90"
                ]
                [ displayBoard b4model
                , displayHole b4model
                , displayBall b4model
                ]

        Over ->
            Svg.svg
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.viewBox "0 0 180 90"
                ]
                [ displayBoard b4model
                , displayHole b4model
                , displayBall b4model
                ]

        _ ->
            Svg.svg
                []
                []

{-|
    This function is for the view of scene on the game page.

-}


scenepage : BFourModel -> Html Msg
scenepage b4model =
    viewGameScene b4model.identity.page


{-|
    This function is for the view of round text showing on the round page.

-}


showRound : BFourModel -> Html Msg
showRound b4model =
    div
        [ style "bottom" "50px"
        , style "font-size" "30px"
        , style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "height" "150px"
        , style "left" "10px"
        , style "line-height" "100px"
        , style "position" "absolute"
        ]
        [ renderText b4model ("Round:" ++ toString b4model.round)
        , renderText b4model ("Win:" ++ toString b4model.result.win_num)
        , renderText b4model ("Lose:" ++ toString b4model.result.lose_num)
        ]

{-|
    This function is for the view of the block under the round text.

-}

renderRoundBlock : BFourModel -> Html Msg
renderRoundBlock b4model =
  getTextBlock 850 170 150 170 (showRound b4model)

{-|
    This function is for the view of pause button.

-}

displayPause : BFourModel -> Html Msg
displayPause b4model =
    let
        ( msg, txt ) =
            case b4model.game_status of
                Prepare ->
                    ( Usermsg (BallFourUserMsg Pause_prepare), "Pause" )

                Playing ->
                    ( Usermsg (BallFourUserMsg Pause_playing), "Pause" )

                Paused_prepare ->
                    ( Usermsg (BallFourUserMsg Start_prepare), "Resume" )

                Paused_playing ->
                    ( Usermsg (BallFourUserMsg Start_playing), "Resume" )

                _ ->
                    ( Usermsg (BallFourUserMsg None), " " )
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

{-|
    This function is for the view of exit button.

-}


displayExitButton : Html Msg
displayExitButton =
    button
        (List.append displayExitButtonA displayExitButtonB)
        [ text "Exit" ]

{-|
    This function is for the view of exit button on the ending page.

-}


displayEndExitButton : Html Msg
displayEndExitButton =
    button
        (List.append displayExitButtonA (showButtonB (Usermsg (BallFourUserMsg B4Game2Plot))))
        [ text "Exit" ]

{-|
    This function is for the view of menu button on the ending page.

-}


displayEndMenuButton : Html Msg
displayEndMenuButton =
    button
        (List.append displayExitButtonA (showButtonB (Usermsg (BallFourUserMsg B4Game2Plot))))
        [ text "Menu" ]

displayExitButtonA : List (Attribute msg)
displayExitButtonA =
    [ style "background" "#34495f"
    , style "border" "0"
    , style "bottom" "100px" 
    , style "color" "#fff"
    , style "cursor" "pointer"
    , style "display" "block"
    , style "font-family" "Comic Sans MS, Comic Sans, cursive"
    , style "font-size" "60px"
    ]


displayExitButtonB : List (Attribute Msg)
displayExitButtonB =
    [ style "font-weight" "300"
    , style "height" "100px"
    , style "right" "500px" 
    , style "line-height" "60px"
    , style "outline" "none"
    , style "padding" "0"
    , style "position" "absolute"
    , style "width" "250px"
    , onClick (Usermsg (BallFourUserMsg B4Game2Plot))
    ]

displayDots : Ball -> List (Svg Msg)
displayDots ball =
    let
        tmp_list =
            List.repeat ball.ball_distance ball.ball_angle
    in
    List.map makeOneDot (List.indexedMap Tuple.pair tmp_list)
makeOneDot : ( Int, Float ) -> Svg Msg
makeOneDot ( num, angle ) =
    Svg.circle
        [ cx (toString (90 - (toFloat num * cos angle)))
        , cy (toString (90 - (toFloat num * sin angle)))
        , r "0.2"
        , fill "#0f100f"
        ]
        []
renderText : BFourModel -> String -> Html Msg
renderText b4model txt =
   let
       color =
         if b4model.game_status == RoundPage || b4model.game_status == End then
            "black"
         else
            "white"
  in
    div
        [ style "color" color
        , style "font-weight" "300"
        , style "line-height" "1"
        , style "margin" "30px 0 0"
        ]
        [ text txt ]


getEndText : BFourModel -> Html Msg
getEndText b4model =
   case b4model.result.victory_or_fail of
                GameVictory ->
                 case b4model.pattern of
                   Pattern1 -> Markdown.toHtml [] """
You win! Ribbon fixed, samsara ends! 
"""
                   Pattern2 -> Markdown.toHtml [] """
Congratulations, you win!
"""
                GameFail ->
                  case b4model.pattern of
                   Pattern1 -> Markdown.toHtml [] """
You lose! Loop continues...
"""
                   Pattern2 -> Markdown.toHtml [] """
You lose:(
"""

                _ -> Markdown.toHtml [] """
Continue Playing!
"""

{-|
    This function is for the view of text on the ending page.

-}

renderEndText : BFourModel ->  Html Msg
renderEndText b4model =
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
          getTextBlock 350 570 700 90 (getEndText b4model)
        ]