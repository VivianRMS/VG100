module HintPage exposing (viewHintPage)
{-|
    This module creates the hintPage for players.
# Main ViewHint Module
@docs viewHintPage

-}

import Html exposing (Html,div)
import Html.Events
import Html.Attributes as HtmlAttr exposing (style)
import Msg exposing (Msg)
import Basis exposing (GameKind)
import ViewButton exposing (backButton)
import Basis exposing (Page(..))
import Basis exposing (Building(..),LibraryBuilding(..),allGames)
import Msg exposing (UserMsg(..),Msg(..))
import Basis exposing (GameKind(..))
import ViewBuildings exposing (viewback)

{-|
    This function presents the hint page for players
-}

viewHintPage : Html Msg
viewHintPage  = 
    let
        page = Library LibraryNone
            |> BuildingPage
    in
    
    div
    [HtmlAttr.style "position" "absolute"
    ]
        (List.map gameHintEntrance allGames
            |> List.append [
                viewback "assets/library.jpg"
                , viewback "assets/guide.png"
                , backButton page])

gameHintEntrance : GameKind -> Html Msg
gameHintEntrance  gamekind = 
    let
        ((xlocate,ylocate),(nwidth,nheight)) =
                giveGameHintEntranceLocation gamekind
        msg = GamePage gamekind
            |> BacktoPlace
            |> Usermsg
    in       
        Html.button
        (List.append
            [ Html.Events.onClick msg
            , style "background" "transparent"
            , style "border-style" "none"
            , style "bottom" "50%"
            , style "color" "yellow"
            , style "cursor" "pointer"
            , style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "display" "block"
            , style "font-size" "15px"
            ]
            [ style "font-weight" "300"
            , style "height" nheight
            , style "left" xlocate
            , style "top"  ylocate
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "fixed"
            , style "width" nwidth
            , style "border-radius" "10%"
            ]
        )
        [ ]

giveGameHintEntranceLocation : GameKind -> ((String,String),(String,String))
giveGameHintEntranceLocation gamekind =
    case gamekind of
        Klotski ->
            (("600px","300px"),("200px","60px"))
        Color ->
            (("610px","374px"),("200px","60px"))
        BallOne ->
            (("610px","440px"),("300px","60px"))
        BallTwo ->
            (("1050px","620px"),("300px","70px"))
        BallThree ->
            (("1100px","450px"),("300px","60px"))
        BallFour ->
            (("1000px","530px"),("300px","60px"))
