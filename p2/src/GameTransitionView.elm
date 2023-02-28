module GameTransitionView exposing (introPage,getTextBlock,colorblock,winPage,failPage,viewATPNotenough,gamebackground,viewGameScene,float2str,getphoto,framebackground)
{-| This module defines some general view functions for games

# General View Functions
@docs introPage, getTextBlock, colorblock, winPage, failPage, viewATPNotenough, gamebackground, viewGameScene, float2str, getphoto, framebackground
-}
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Markdown
import Html exposing (Html,div, text)
import Html.Attributes exposing (style)
import Msg exposing (Msg(..))
import Basis exposing (Page(..),SchoolBuilding(..),ClassBuilding(..),Building(..),MemoryBuilding(..),LibraryBuilding(..),CharacterIdentity(..),Phase(..),Content(..))

{-|
    This function defines the intro page of each game and the input is the name of different games.

-}

introPage : Html Msg -> Html Msg
introPage title =
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
                    , title
                    ]
                 ]

{-|
    This function defines the transition from float to a string with either % or px.

-}

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
    This function defines how to insert a certain photo to a certain position with certain width, height.

-}
getphoto : String -> Float -> Float -> Float -> Float -> Html Msg
getphoto str width height x y =
                div
                 [ style "width" "100%"
                 , style "height" "100%"
                 , style "position" "fixed"
                 , style "left" "0"
                 , style "top" "0"
                 , style "z-index" "-5"
                 ]
                 [
                    Svg.svg
                    [SvgAttr.width "100%"
                     ,SvgAttr.height "100%"]
                    [Svg.image
                    [ SvgAttr.width (float2str width True False)
                    , SvgAttr.height (float2str height True False)
                    , SvgAttr.x (float2str x False False)
                    , SvgAttr.y (float2str y False False)
                    , SvgAttr.xlinkHref str
                    ]
                    []]
                 ]

{-|
    This function defines the brown color block to place below the frame.

-}
framebackground : Html Msg
framebackground =
    colorblock (div[][]) "#bf8d6a" 260 540 880 590

{-|
    This function defines the where the photo frame should be placed on the screen.

-}
getFrame : Html Msg
getFrame =
    getphoto "assets/photo frame.png" 55 55 440 260

{-|
    This function defines the victory page after the player has won a certain game.

-}
winPage : Html Msg -> Html Msg
winPage title =
    div
    []
    [ gamebackground
    , introPage title
    ,getFrame
    , getphoto "assets/success.jpg" 50 50 480 280
    ]

{-|
    This function defines the failure page after the player has failed in a certain game.

-}
failPage : Html Msg -> Html Msg
failPage title =
    div
    []
    [ gamebackground
    , introPage title
    , getFrame
    , getphoto "assets/fail.jpg" 50 50 480 280
    ]

{-|
    This function defines where to put a color block with certain word on it and specific width, height.

-}
colorblock : Html Msg -> String -> Float -> Float -> Float -> Float ->Html Msg
colorblock txt color top left width height =
    div
        [ style "background" color
        , style "position" "fixed"
        , style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "top" ( float2str top False True )
        , style "left" ( float2str left False True )
        , style "width" ( float2str width False True )
        , style "height" ( float2str height False True )
        , style "font-size" "30px"
        , style "line-height" "1.5"
        , style "display" "block"
        , style "z-index" "-5"
        ]
        [ txt ]

{-|
    This function defines the background to distinguish between different levels of photos and help players to see the borders of the game.

-}
gamebackground : Html Msg
gamebackground =
    colorblock (div[][]) "#ECF0F1A8" 10 70 1800 1050

{-|
    This function defines the where and what text should be put on the screen.

-}
getTextBlock : Float -> Float -> Float -> Float -> Html Msg -> Html Msg
getTextBlock top left width height text =
    colorblock text "#c0c045a8" top left width height

{-|
    This function gives the bottom layer of the game page, the previous page from which the player enters the game.

-}
viewGameScene :  Page -> Html Msg
viewGameScene page=
    let
        link =
            case page of
                BuildingPage ( School Historyroom ) ->
                    "assets/historyroom.jpg"
                BuildingPage ( Library (Memory MemoryNone )) ->
                    "assets/goldmemory.jpg"
                HintPage ->
                    "assets/library.jpg"
                PersonPage Photographer _ _ ->
                    "assets/photostudio.jpg"
                BuildingPage Square ->
                    "assets/square.jpg"
                PersonPage Drawer _ _ ->
                    "assets/artroombrush.jpg"
                PersonPage Weaver _ _ ->
                    "assets/ChurchNotCry.jpg"
                BuildingPage ( School (Classroom ClassNone)) ->
                    "assets/classroom.jpg"
                BuildingPage Lawn ->
                    "assets/lawn.jpg"
                BuildingPage Apartment ->
                    "assets/apartment.jpg"
                _ ->
                    ""
        image =
            case link of
                "" ->
                    div [] []
                _ ->
                    Svg.svg
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
    in
    div

        [     style "width" "100%"
            , style "height" "100%"
            , style "position" "fixed"
            , style "left" "0"
            , style "top" "0"
            , style "z-index" "-10"
        ]
        [image
        ]

{-|
    This function defines the view when the time is exhausted in the game page to prevent players from playing anymore.

-}
viewATPNotenough : Html Msg
viewATPNotenough =
    getTextBlock 700 500 500 100 (atplackinfo)

atplackinfo : Html Msg
atplackinfo =
    Markdown.toHtml [] """
Not enough time! Come next day!
"""
