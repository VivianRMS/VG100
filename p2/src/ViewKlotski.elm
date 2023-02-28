module ViewKlotski exposing (viewKlotski)

{-| This module controls the view for the game Klotski.

# Klotski View Function
@docs viewKlotski

-}

import Basis exposing (CharacterIdentity(..), Content(..), Page(..))
import Debug exposing (toString)
import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Klotski exposing (KState(..),KlotskiKind(..),KResult(..),Cell)
import Model exposing (Model)
import ModelKlotski exposing (KSubmodel)
import Msg exposing (Msg(..),UserMsg(..))
import MsgKlotski exposing (UserMsgKlotski(..))
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Markdown
import GameTransitionView exposing (gamebackground,introPage,framebackground,viewGameScene,getphoto,getTextBlock,winPage,failPage)
import ViewColor exposing (renderLabel,renderCount)

{-|
    This function is for the view of the game Klotski.

-}

viewKlotski : Model -> Html Msg
viewKlotski model =
    klotskiView model


klotskiView : Model -> Html Msg
klotskiView model =
    let
        kSubmodel =
            model.kmodel
    in
    div
        []
        [ klotskiPlayingView kSubmodel
        , renderKlotskiGameButton kSubmodel
        ]


klotskiPlayingView : KSubmodel -> Html Msg
klotskiPlayingView kmodel =
    case kmodel.state of
        KBefore ->
            div
                []
                [ scenepage kmodel
                , gamebackground
                , renderGameIntroPanel kmodel.nOrp
                ]

        KShow ->
            div
                [
                ]
                [ scenepage kmodel
                , gamebackground
                , introPage title
                , getfinal kmodel.nOrp
                , getFrame
                ]

        _ ->
            div
                []
                [ scenepage kmodel
                , gamebackground
                , introPage title
                , framebackground
                , getFrame
                , div []
                    (makeCells kmodel.nOrp kmodel.cells)
                , klotskiVFView kmodel
                , renderOtherInfo kmodel


                ]

scenepage : KSubmodel -> Html Msg
scenepage kmodel =
    viewGameScene kmodel.identity.page



getfinal : KlotskiKind -> Html Msg
getfinal kind =
    case kind of
        Photo ->
            getphoto "assets/operation.jpg" 50 50 480 280
        Number ->
            getphoto "assets/numberall.jpg" 50 50 480 280
        BookNumber ->
            getphoto "assets/numberall.jpg" 50 50 480 280
        Cloth ->
            getphoto "assets/numberall.jpg" 50 50 480 280
        _ ->
            getphoto "assets/numberall.jpg" 50 50 480 280


getFrame : Html Msg
getFrame =
    getphoto "assets/photo frame.png" 55 55 440 260


klotskiVFView : KSubmodel -> Html Msg
klotskiVFView kmodel =
    let
        resultpage =
            case kmodel.result of
                KVictory ->
                    winPage title
                KFailure ->
                    failPage title
                KUndetermined ->
                    div[][]
    in
    div
        [ style "display"
            (if kmodel.result == KUndetermined then
                "none"

             else
                "block"
            )
        ]
        [ resultpage
        ]

makeOneCellA : List (Attribute msg)
makeOneCellA =
    [ style "background-color" "transparent"
    , style "border" "0"
    , style "color" "#fff"
    , style "cursor" "pointer"
    , style "display" "block"
    , style "font-family" "Comic Sans MS, Comic Sans, cursive"
    , style "font-size" "18px"
    , style "font-weight" "600"
    ]


makeOneCellB : Cell -> List (Attribute msg)
makeOneCellB cell =
    [ style "height" "173px"
    , style "left" (toString (Tuple.first cell.pos) ++ "px")
    , style "top" (toString (Tuple.second cell.pos) ++ "px")
    , style "line-height" "60px"
    , style "outline" "none"
    , style "padding" "0"
    , style "position" "absolute"
    , style "width" "280px"
    ]

makeNCell : KlotskiKind -> Cell -> Html Msg
makeNCell kind cell =
    let
        link =
            int2link kind (Tuple.second cell.standardActualIndex)
        x =
            Tuple.first cell.pos
        y =
            Tuple.second cell.pos
    in
    button
        (List.append
            (List.append makeOneCellA (makeOneCellB cell))
            [ onClick ( Usermsg (KlotskiUserMsg (KMove cell)) ) ]
        )
    [ getphoto link 15 15 x y ]



int2link : KlotskiKind -> Int -> String
int2link kind index =
    case kind of
        Photo ->
            int2linkPhoto index
        BookNumber ->
            int2linkNumber index
        Number ->
            int2linkNumber index
        Cloth ->
            int2linkNumber index
        _ ->
            int2linkNumber index

int2linkNumber : Int -> String
int2linkNumber index =
    case index of
        1 ->
            "assets/number1.jpg"
        2 ->
            "assets/number2.jpg"
        3 ->
            "assets/number3.jpg"
        4 ->
            "assets/number4.jpg"
        5 ->
            "assets/number5.jpg"
        6 ->
            "assets/number6.jpg"
        7 ->
            "assets/number7.jpg"
        8 ->
            "assets/number8.jpg"
        _ ->
            "assets/number1.jpg"

int2linkPhoto : Int -> String
int2linkPhoto index =
    case index of
        1 ->
            "assets/fragment1.jpg"
        2 ->
            "assets/fragment2.jpg"
        3 ->
            "assets/fragment3.jpg"
        4 ->
            "assets/fragment4.jpg"
        5 ->
            "assets/fragment5.jpg"
        6 ->
            "assets/fragment6.jpg"
        7 ->
            "assets/fragment7.jpg"
        8 ->
            "assets/fragment8.jpg"
        _ ->
            "assets/fragment1.jpg"

makeCells : KlotskiKind -> List Cell -> List (Html Msg)
makeCells kind cells =
    List.filter (\x -> Tuple.second x.standardActualIndex /= 0) cells
        |> List.map ( makeNCell kind )


renderKlotskiGameButton : KSubmodel -> Html Msg
renderKlotskiGameButton kmodel =
    let
        ( txt, msg ) =
            case kmodel.state of
                KBefore ->
                    ( "Next", Usermsg (KlotskiUserMsg (KState KBefore)) )

                KShow ->
                    ( "Start" , Usermsg (KlotskiUserMsg (KState KShow)) )


                KEnd ->
                    ( "Exit", Usermsg (KlotskiUserMsg KGame2Plot) )

                _ ->
                    ( "Restart", Usermsg (KlotskiUserMsg ( KState KBefore )) )

        ( ntxt, nmsg ) =
            if kmodel.chance <= 0 && kmodel.state == KPlaying then
                ( "Give Up", Usermsg (KlotskiUserMsg (KState KGiveUp)) )

            else
                ( txt, msg )
    in
    button
        (List.append
            (List.append renderKlotskiGameButtonA renderKlotskiGameButtonB)
            [ onClick nmsg ]
        )
        [ text ntxt ]


renderKlotskiGameButtonA : List (Attribute msg)
renderKlotskiGameButtonA =
    [ style "background" "#34495f"
    , style "border" "0"
    , style "bottom" "100px"
    , style "color" "#fff"
    , style "cursor" "pointer"
    , style "display" "block"
    , style "font-family" "Comic Sans MS, Comic Sans, cursive"
    , style "font-size" "60px"
    ]


renderKlotskiGameButtonB : List (Attribute msg)
renderKlotskiGameButtonB =
    [ style "font-weight" "300"
    , style "height" "100px"
    , style "right" "200px"
    , style "line-height" "60px"
    , style "outline" "none"
    , style "padding" "0"
    , style "position" "absolute"
    , style "width" "300px"
    ]

renderOtherInfo : KSubmodel -> Html Msg
renderOtherInfo kmodel =
    div
        [ style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "font-size" "50px"
        , style "line-height" "1.5"
        , style "padding" "0 15px"
        , style "position" "absolute"
        , style "display" "block"
        , style "z-index" "-5"
        , style "display"
            (if kmodel.result /= KUndetermined then
                "none"

             else
                "block"
            )
        ]
        [
        getTextBlock 80 1450 250 200 (renderChancePanel kmodel)
        ]


renderGameIntroPanel : KlotskiKind -> Html Msg
renderGameIntroPanel kind =
    div

        []
        [ introPage title
        , renderalltext kind
        ]

title : Html Msg
title =
        Svg.image
        [ SvgAttr.width "700px"
        , SvgAttr.x "220px"
        , SvgAttr.y "80px"
        , SvgAttr.xlinkHref "assets/klotski.png"
        ]
        []


renderalltext : KlotskiKind -> Html Msg
renderalltext kind =
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
        [ getTextBlock 280 200 800 100 (getPlotText kind)
        , getTextBlock 80 1100 600 400 (getScoringText kind)
        , getTextBlock 440 200 800 550 getGameRuleText
        ]




getPlotText : KlotskiKind -> Html Msg
getPlotText kind =
    case kind of
        Number ->
            Markdown.toHtml [] """
Welcome to Klotski! Have a try!
"""
        BookNumber ->
            Markdown.toHtml [] """
Could you please help arrange books on the shelf?
"""
        Photo ->
            Markdown.toHtml [] """
Could you please help piece photo fragments back together?
"""
        Cloth ->
            Markdown.toHtml [] """
Could you please help piece the divine cloth fragments back together?
"""
        _ ->
            Markdown.toHtml [] """
"""

getScoringText : KlotskiKind -> Html Msg
getScoringText kind =
    case kind of
        Number ->
            Markdown.toHtml [] """
Scoring Rule:

Each try doesn't consume hours.

One successful try doesn't gain you GT points.

Have fun exploring plot!
"""

        BookNumber ->
            Markdown.toHtml [] """
Scoring Rule:

Each try doesn't consume hours.

One successful try gains you 30 GT points.
"""
        Photo ->
            Markdown.toHtml [] """
Scoring Rule:

Each try doesn't consume hours.

One successful try doesn't gain you GT points.

Have fun exploring plot!
"""
        Cloth ->
            Markdown.toHtml [] """
Scoring Rule:

Each try doesn't consume hours.

One successful try doesn't gain you GT points.

Have fun exploring plot!
"""

        _ ->
            Markdown.toHtml [] """
"""

getGameRuleText : Html Msg
getGameRuleText =
    Markdown.toHtml [] """
Game Rule:

Click to change order and try returning number back to its original pattern (shown in the next page)

In each try, You can click RESTART button to check the original pattern for three times.

After you recheck the pattern, the order will be shuffled again.

Seize each chance to return the pattern to normal!
"""

renderChancePanel : KSubmodel -> Html Msg
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