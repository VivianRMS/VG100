module Ball_Two.SubView exposing (renderEndText,displayMenuButton,showButton,viewPatternChoice,displayExitButton,getPlotText,getScoringText,getGameRuleText,colorblock,showIntroPageButton)
{-| This module controls the part of the view for the game Defend the fragile.

# Ball2 View Function of Button
@docs displayMenuButton, showButton, displayExitButton, showIntroPageButton

# Ball2 View Function of Scece
@docs colorblock

# Ball2 View Function of Text
@docs renderEndText, viewPatternChoice, getPlotText, getScoringText, getGameRuleText
-}

import Ball_Two.Ball_Two exposing (Dir(..),Scene(..),WinOrFail(..),BallState(..),GameStatus(..),Pattern(..),PatternValid(..))
import Ball_Two.Message exposing (BallTwoUserMsg(..))
import Ball_Two.Model exposing (BTwoModel)
import Basis exposing (CharacterIdentity(..), Content(..), Page(..))
import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..),UserMsg(..))
import Svg.Attributes exposing (x, y)
import String exposing (fromFloat)
import Basis exposing (LibraryBuilding(..))
import Markdown
import GameTransitionView exposing (getTextBlock)

{-|
    This function is for the view of block under the text.

-}

colorblock : Html Msg -> String -> Float -> Float -> Float -> Float ->Html Msg
colorblock txt color top left width height =
    div
        (List.append[ style "background" color
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

{-|
    This function is for the view of text about the plot.

-}

getPlotText : Page -> BTwoModel ->Html Msg
getPlotText page b2model=
    case page of
        HintPage ->
          case b2model.scene of
            Scene1 ->
               Markdown.toHtml [] """
Intercept three scissors to keep the memory!  
                """
            Scene2 ->
                Markdown.toHtml [] """
Throw the dart at the target!
                """
        _ ->
             case b2model.scene of
            Scene1 ->
               Markdown.toHtml [] """
Intercept three scissors to keep the memory!  
                """
            Scene2 ->
                Markdown.toHtml [] """
Throw the dart at the target!
                """


{-|
    This function is for the view of text about scoring rules.

-}

getScoringText : BTwoModel -> Page -> Bool -> Html Msg
getScoringText b2model page te =
  case page of 
    HintPage ->
          case b2model.scene of
            Scene1 ->
               Markdown.toHtml [] """
Each try doesn't consume hours.

One successful try doesn't gain you GT points.

Intercept scissors to keep the memory! 
                """
            Scene2 ->
                Markdown.toHtml [] """
Each try doesn't consume hours.

One successful try doesn't gain you GT points.

Throw the dart at the target!
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

{-|
    This function is for the view of text about game rules.

-}

getGameRuleText : BTwoModel -> Html Msg
getGameRuleText b2model=
 case b2model.scene of
    Scene1 ->
      Markdown.toHtml [] """       
Game Rule:
There are 5 seconds for you to
adjust the shooting angle of the scissors.

The scissors will be automatically launched after 5 seconds.

The trajectory of the scissors is a straight line.

The scissors will bounce back when they hit the shield,
which means a successful interception. 

You only have five chances.
        
             """
    Scene2 ->
     Markdown.toHtml [] """       
Game Rule:

There are 5 seconds for you to press 
             
the left and rigth key to adjust the 
shooting angle of the dart. 

You have 5 chances to throw the dart.

You have to finish at least one shoot 
to get GT points.
             """
   
{-|
    This function is for the view of button on the intro page.

-}

showIntroPageButton : BTwoModel -> Html Msg
showIntroPageButton b2model =
    let
        info =
            case b2model.te of
                True ->
                    viewPatternChoice b2model
                False ->
                    div[][]
    in
    div
        [
          style "position" "fixed"
        , style "width" "100%"
        , style "height" "100%"
        , style "top" "0px"
        , style "left" "0px"
        ]
        [

          showButton b2model
        , info
        , displayExitButton
        
        ]

getEndText : BTwoModel -> Html Msg
getEndText b2model =
   case b2model.result.victory_or_fail of
                GameVictory ->
                 case b2model.scene of
                   Scene1 -> Markdown.toHtml [] """
You have successfully protected the photo. Memory saved. 
"""
                   Scene2 -> Markdown.toHtml [] """
Your darts hit the target, you successfully gain Guard of Time.
"""
                GameFail ->
                  case b2model.scene of
                   Scene1 -> Markdown.toHtml [] """
The photo is broken. Memory lost.
"""
                   Scene2 -> Markdown.toHtml [] """
Your darts missed the target 3 times, You failed to gain Guard of Time.
"""

                _ -> Markdown.toHtml [] """
Continue Playing!
"""

{-|
    This function is for the view of text on the ending page.

-}

renderEndText : BTwoModel ->  Html Msg
renderEndText b2model =
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
          getTextBlock 350 580 700 150 (getEndText b2model)
        ]


viewPatternButton : Pattern -> Float -> Float ->BTwoModel -> Html Msg
viewPatternButton pattern x y b1model=
    let
        old_pattern = b1model.pattern
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
        ( style "background" color
        :: style "border" "2"
        :: style "color" "white"
        :: style "cursor" "pointer"
        :: style "display" "block"
        :: style "font-family" "Comic Sans MS, Comic Sans, cursived"
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
        :: [onClick (Usermsg (BallTwoUserMsg ( B2ChoosePattern npattern ) ) )]
        )
        [ text txt
        ]
{-|
    This function is for the view of text about pattern choice.

-}

viewPatternChoice : BTwoModel -> Html Msg
viewPatternChoice b2model =
    div
        []
        [ viewPatternButton Pattern1 1550 180 b2model
        , viewPatternButton Pattern2 1550 330 b2model
        ]

{-|
    This function is for the view of some buttons.

-}

showButton : BTwoModel -> Html Msg
showButton b2model =
    let
        ( msg, txt ,txt2 ) =
            case b2model.game_status of
                Intro patterncheck ->
                    case patterncheck of
                        ValidPattern ->
                            ( Usermsg (BallTwoUserMsg Enter), "Start" , "")
                        InvalidPattern ->
                            ( Usermsg (BallTwoUserMsg Locked), "Lacking" , "")

                RoundPage ->
                    ( Usermsg (BallTwoUserMsg Nextstep), "Next" , "" )
                End -> 
                    ( (Usermsg (BallTwoUserMsg B2Game2Plot)), "Exit" ,"")

                _ ->
                    ( Usermsg (BallTwoUserMsg None), " ", "" )
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

{-|
    This function is for the view of exit button.

-} 

displayExitButton : Html Msg
displayExitButton =
    button
        (List.append displayExitButtonA displayExitButtonB)
        [ text "Exit" ]


{-|
    This function is for the view of menu button.

-}
displayMenuButton : Html Msg
displayMenuButton =
    button
        (List.append displayExitButtonA displayExitButtonB)

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
    , onClick (Usermsg (BallTwoUserMsg B2Game2Plot))
    ]
