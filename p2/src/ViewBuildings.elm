module ViewBuildings exposing( viewback, clickBuildItem, clickBuilding, isChurchThree, viewAllbuilding, viewLockBuilding, viewRoadMap)

{-|

    This module presents the buildings on the screen.

# View Building Module
@docs viewAllbuilding, viewLockBuilding

# View Background Image
@docs viewback, viewRoadMap

# Judge Building State
@docs isChurchThree

# Button for changing pages to building
@docs clickBuildItem, clickBuilding
-}

import Ball_Four.Ball_Four exposing (WinOrFail(..))
import Basis exposing (Building(..), CharacterIdentity(..), Content(..), GameKind(..), Item(..), LaterName(..), LibraryBuilding(..), Line(..), Page(..), Phase(..), SchoolBuilding(..), StoryLine(..), TxtState(..), checkNumberInList)
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Html.Events
import Model exposing (Model)
import Msg exposing (Drawermsg(..), Msg(..), Photographermsg(..), UserMsg(..), Weavermsg(..))
import String exposing (fromFloat)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr


{-|

    This function views the background of scenes.

-}
viewback : String -> Html Msg
viewback link =
    div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "fixed"
        , style "left" "0"
        , style "top" "0"
        , style "z-index" "-10"
        ]
        [ Svg.svg
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            ]
            [ Svg.image
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.xlinkHref link
                ]
                []
            ]
        ]


{-|

    This function views the road map of the map.

-}
viewRoadMap : Html Msg
viewRoadMap =
    let
        link =
            "assets/map.jpg"
    in
    div
        [ style "width" "1536px"
        , style "height" "864px"
        , style "position" "fixed"
        , style "left" "370px"
        , style "top" "120px"
        , style "z-index" "-5"
        , style "background" "#7232bc"
        ]
        [ Svg.svg
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            ]
            [ Svg.image
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.xlinkHref link
                ]
                []
            ]
        ]

{-|
    This function provides a button to change the page with an action point deducted.
-}
clickBuilding : ( Building, ( Float, Float ), ( Float, Float ) ) -> Html Msg
clickBuilding ( building, ( x, y ), ( a, b ) ) =
    Html.button
        (List.append
            [ Html.Events.onClick (Usermsg (GotoPlace (BuildingPage building)))
            , style "background" "transparent"
            , style "border-style" "none"
            , style "bottom" "50%"
            , style "cursor" "pointer"
            , style "display" "block"
            ]
            [ style "height" (fromFloat b ++ "px")
            , style "left" (fromFloat x ++ "%")
            , style "top" (fromFloat y ++ "%")
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" (fromFloat a ++ "px")
            , style "border-radius" "10%"
            ]
        )
        []

{-|
    This function provides a button to go to a building without losing action point.
-}
clickBuildItem : ( Building, ( Float, Float ), ( Float, Float ) ) -> Html Msg
clickBuildItem ( building, ( x, y ), ( a, b ) ) =
    Html.button
        (List.append
            [ Html.Events.onClick (Usermsg (BacktoPlace (BuildingPage building)))
            , style "background" "transparent"
            , style "border-style" "none"
            , style "bottom" "50%"
            , style "cursor" "pointer"
            , style "display" "block"
            ]
            [ style "height" (fromFloat b ++ "px")
            , style "left" (fromFloat x ++ "%")
            , style "top" (fromFloat y ++ "%")
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" (fromFloat a ++ "px")
            , style "border-radius" "10%"
            ]
        )
        []

{-|
    This function gives the view of a building locked.
-}
viewLockBuilding : ( Building, ( Float, Float ), ( Float, Float ) ) -> Html Msg
viewLockBuilding ( building, ( x, y ), ( width, height ) ) =
    div
        (List.append
            [ style "background" "transparent"
            , style "border" "0"
            , style "bottom" "50%"
            , style "cursor" "pointer"
            , style "display" "block"
            , style "font-size" "15px"
            ]
            [ style "font-weight" "300"
            , style "height" (fromFloat height ++ "px")
            , style "left" (fromFloat x ++ "%")
            , style "top" (fromFloat y ++ "%")
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" (fromFloat width ++ "px")
            , style "border-radius" "10%"
            ]
        )
        [ viewLock ]


viewLock : Html Msg
viewLock =
    let
        link =
            "assets/lock.png"
    in
    Svg.svg
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        ]
        [ Svg.image
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.xlinkHref link
            ]
            []
        ]


allBuilding : List ( Building, ( Float, Float ), ( Float, Float ) )
allBuilding =
    [ ( PhotoStudio, ( 25, 70 ), ( 300, 120 ) ), ( Library LibraryNone, ( 72, 18 ), ( 350, 180 ) ), ( School SchoolNone, ( 28, 15 ), ( 400, 250 ) ), ( Church, ( 63, 70 ), ( 250, 200 ) ), ( Apartment, ( 22, 48 ), ( 400, 100 ) ), ( Lawn, ( 55, 38 ), ( 600, 90 ) ), artmuseum, square ]


photoStudio : ( Building, ( Float, Float ), ( Float, Float ) )
photoStudio =
    ( PhotoStudio, ( 25, 70 ), ( 300, 120 ) )


library : ( Building, ( Float, Float ), ( Float, Float ) )
library =
    ( Library LibraryNone, ( 72, 18 ), ( 350, 180 ) )


school : ( Building, ( Float, Float ), ( Float, Float ) )
school =
    ( School SchoolNone, ( 28, 15 ), ( 400, 250 ) )


church : ( Building, ( Float, Float ), ( Float, Float ) )
church =
    ( Church, ( 63, 70 ), ( 250, 200 ) )


apartment : ( Building, ( Float, Float ), ( Float, Float ) )
apartment =
    ( Apartment, ( 22, 48 ), ( 400, 100 ) )


lawn : ( Building, ( Float, Float ), ( Float, Float ) )
lawn =
    ( Lawn, ( 55, 38 ), ( 600, 90 ) )


artmuseum : ( Building, ( Float, Float ), ( Float, Float ) )
artmuseum =
    ( ArtMuseum, ( 77, 57 ), ( 420, 180 ) )


square : ( Building, ( Float, Float ), ( Float, Float ) )
square =
    ( Square, ( 67, 47 ), ( 120, 120 ) )


lockphotostudio : ( Building, ( Float, Float ), ( Float, Float ) )
lockphotostudio =
    ( PhotoStudio, ( 22, 50 ), ( 500, 500 ) )


lockchurch : ( Building, ( Float, Float ), ( Float, Float ) )
lockchurch =
    ( Church, ( 56, 55 ), ( 500, 500 ) )


{-|

    This function views all buildings in the game under different circumstances.

-}
viewAllbuilding : Model -> List (Html Msg)
viewAllbuilding model =
    if model.day > 4 then
        case model.storyline of
            Determined (CharacterLine Weaver) ->
                case model.b4model.result.victory_or_fail of
                    GameFail ->
                        List.map clickBuilding [ school, library, lawn, artmuseum, apartment, square ]
                            |> List.append [ viewLockBuilding lockchurch ]
                            |> List.append [ viewLockBuilding lockphotostudio ]

                    _ ->
                        List.map clickBuilding [ school, library, lawn, artmuseum, apartment, square, church ]
                            |> List.append [ viewLockBuilding lockphotostudio ]

            Determined (CharacterLine Photographer) ->
                List.map clickBuilding [ school, library, lawn, photoStudio, artmuseum, apartment, square ]
                    |> List.append [ viewLockBuilding lockchurch ]

            Determined (CharacterLine Drawer) ->
                List.map clickBuilding [ school, library, lawn, artmuseum, apartment, square ]
                    |> List.append [ viewLockBuilding lockchurch ]
                    |> List.append [ viewLockBuilding lockphotostudio ]

            _ ->
                List.map clickBuilding allBuilding

    else
        case ( isChurchOne model, isChurchTwo model, isChurchThree model ) of
            ( True, _, _ ) ->
                viewBlockChurch

            ( False, True, False ) ->
                viewBlockChurch

            ( False, True, True ) ->
                if isChurchFour model then
                    viewBlockChurch

                else
                    List.map clickBuilding allBuilding

            ( False, False, _ ) ->
                List.map clickBuilding allBuilding


viewBlockChurch : List (Html Msg)
viewBlockChurch =
    List.map clickBuilding [ school, library, lawn, photoStudio, artmuseum, apartment, square ]
        |> List.append [ viewLockBuilding lockchurch ]


isChurchOne : Model -> Bool
isChurchOne model =
    checkNumberInList model.weaverModel.getTxtClues A
        && not model.weaverModel.nextday


isChurchTwo : Model -> Bool
isChurchTwo model =
    checkNumberInList model.weaverModel.getTxtClues D

{-|

    This function judges the state of church after getting bluecloth fragments.

-}
isChurchThree : Model -> Bool
isChurchThree model =
    checkNumberInList model.weaverModel.getItems BlueClothFrag


isChurchFour : Model -> Bool
isChurchFour model =
    checkNumberInList model.weaverModel.getTxtClues E

