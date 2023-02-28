module ViewEndingMap exposing (viewEnd,viewPhotoAlbum,albumButton,albumBackButton)
{-|
    This module presents the ending of the game, and an album collecting all endings.
# View Ending Module
@docs viewEnd
# View Ending Album Module
@docs viewPhotoAlbum, albumButton, albumBackButton
-}
import Basis exposing (CharacterIdentity(..), Ending, Line(..), LineEnding(..))
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events
import Model exposing (Model)
import Msg exposing (Msg(..), UserMsg(..))
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr 
import ViewBuildings exposing (viewback)

import Basis exposing (Page(..))
import ViewButton exposing (backButton)
import String exposing (fromFloat)
import GameTransitionView exposing(gamebackground)

--from wksp 6


type alias ViewEndMap =
    ( Line, Bool ) -> Maybe (Html Msg)


endingViewChunk : List ( Html Msg, ( Line, Bool ) )
endingViewChunk =
    [ ( viewBadEnd, ( BadLine, False ) )
    , ( viewPhotoGoodEnd, ( CharacterLine Photographer, True ) )
    , ( viewPhotoBadEnd, ( CharacterLine Photographer, False ) )
    , ( viewDrawerGoodEnd, ( CharacterLine Drawer, True ) )
    , ( viewDrawerBadEnd, ( CharacterLine Drawer, False ) )
    , ( viewWeaverGoodEnd, ( CharacterLine Weaver, True ) )
    , ( viewWeaverBadEnd, ( CharacterLine Weaver, False ) )
    , ( viewTrueEnd, ( TrueLine, True ) )
    , (viewTrueEnd, ( TrueLine, False ) )
    ]


endingMapview : ( Html Msg, ( Line, Bool ) ) -> ViewEndMap
endingMapview ( seen, ( line, bool ) ) r =
    if ( line, bool ) == r then
        Just seen

    else
        Nothing


seekEndtable : List ViewEndMap -> ( Line, Bool ) -> List (Html Msg)
seekEndtable table_maps r =
    List.filterMap (\map -> map r) table_maps


endingMapViews : List ( Html Msg, ( Line, Bool ) ) -> List ViewEndMap
endingMapViews =
    List.map endingMapview


seekEnd : List ( Html Msg, ( Line, Bool ) ) -> ( Line, Bool ) -> List (Html Msg)
seekEnd =
    endingMapViews >> seekEndtable


{-|
    This module presents a single ending.
-}
viewEnd : Model -> Html Msg
viewEnd model =
    let
        ending =
            model.currentEnding
        trueEnd1 = Ending TrueLine True
        trueEnd2 = Ending TrueLine False

    in
    case ending of
        NotReached ->
            div
                []
                []

        Reached oneending ->
           if oneending == trueEnd1 then
                viewTrueLastEnd model.time oneending
           else if oneending == trueEnd2 then 
                viewTrueLastEnd model.time oneending
            else
                div[][dealViewEnding model.time oneending]

viewTrueLastEnd : Float -> Ending -> Html Msg
viewTrueLastEnd time  ending =
    let
        line =
            ending.line

        pass =
            ending.result
    in
    div
        [style "opacity" (getEndingOpacity time)]
        (seekEnd endingViewChunk ( line, pass )
            

        )

dealViewEnding : Float -> Ending -> Html Msg
dealViewEnding time  ending =
    let
        line =
            ending.line

        pass =
            ending.result
    in
    div
        [style "opacity" (getEndingOpacity time)]
        (seekEnd endingViewChunk ( line, pass )
            |> List.append [ viewSamsarabutton time]

        )

getEndingOpacity : Float -> String
getEndingOpacity time = 
    if time <= 2000 then
        time * ( 4000 - time ) / 2000 / 2000
            |>fromFloat
    else
        "1"
viewBadEnd : Html Msg
viewBadEnd =
   let
        link =
            "assets/badending.jpg"
   in
    div

        [     style "width" "100%"
            , style "height" "100%"
            , style "position" "fixed"
            , style "left" "0"
            , style "top" "0"
            , style "z-index" "-5"
            , style "background" "#020202"
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
            , SvgAttr.xlinkHref link
            ]
            []]
       , viewBadLineWords
        ]

viewBadLineWords : Html Msg
viewBadLineWords = 
    div
    [ style "position" "fixed"
       ,style "left" "120px"
       , style "color" "white"
        , style "top" "150px"
        , style  "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "font-size" "33px"
        , style "font-weight" "bold"
    ]
    [  text "World Ends, SummerSara TO BE CONTINUED ..."]

viewPhotoGoodEnd : Html Msg
viewPhotoGoodEnd =
    let
        link =
            "assets/PhotographerHE.jpg"
   in
    div
        [     style "width" "100%"
            , style "height" "100%"
            , style "position" "fixed"
            , style "left" "0"
            , style "top" "0"
            , style "z-index" "-5"
            , style "background" "#8a0e11"
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
            , SvgAttr.xlinkHref link
            ]
            []]
        , viewPhotoGoodEndWords]

viewPhotoGoodEndWords : Html Msg
viewPhotoGoodEndWords = 
    div
    [ style "position" "fixed"
       ,style "left" "120px"
       , style "color" "white"
        , style "top" "150px"
        , style  "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "font-size" "33px"
        , style "font-weight" "bold"
    ]
    [  text "Dear traveler, memories are precious. Please always remember..."
       ]

viewPhotoBadEnd : Html Msg
viewPhotoBadEnd =
    viewBadEnd

viewDrawerBadEnd : Html Msg
viewDrawerBadEnd =
   viewBadEnd


viewDrawerGoodEnd : Html Msg
viewDrawerGoodEnd =
   let
        link =
            "assets/PainterHE.jpg"
   in
    div
        [     style "width" "100%"
            , style "height" "100%"
            , style "position" "fixed"
            , style "left" "0"
            , style "top" "0"
            , style "z-index" "-5"
            , style "background" "#040301"
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
            , SvgAttr.xlinkHref link
            ]
            []]
         ,viewDrawerGoodEndWords
        ]
viewDrawerGoodEndWords : Html Msg
viewDrawerGoodEndWords = 
    div
    [ style "position" "fixed"
       ,style "left" "120px"
       , style "color" "white"
        , style "top" "150px"
        , style  "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "font-size" "33px"
        , style "font-weight" "bold"
    ]
    [  text "Dear traveler, real-life paintings are invaluable. Please always protect ..."
        ]

viewWeaverGoodEnd : Html Msg
viewWeaverGoodEnd =
   let
        link =
            "assets/WeaverHE.jpg"
   in
    div
        [     style "width" "100%"
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
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.xlinkHref link
            ]
            []]
        ,viewWeaverGoodEndWords
        ]
viewWeaverGoodEndWords : Html Msg
viewWeaverGoodEndWords = 
    div
    [ style "position" "fixed"
       ,style "left" "120px"
       , style "color" "black"
        , style "top" "150px"
        , style  "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "font-size" "33px"
        , style "font-weight" "bold"
    ]
    [  text "Dear traveler, you make a difference to the world. Please be always proud ... " ]

viewTrueEndWords : Html Msg
viewTrueEndWords = 
    div
    [ style "position" "fixed"
       ,style "left" "120px"
       , style "color" "yellow"
        , style "top" "150px"
        , style  "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "font-size" "33px"
        , style "font-weight" "bold"
    ]
    [  text "You leave the peaceful town, and your journey in this town will always be remembered." ]


viewWeaverBadEnd : Html Msg
viewWeaverBadEnd =
    viewBadEnd



viewTrueEnd : Html Msg
viewTrueEnd =
   let
        link =
            "assets/Title.jpg"
   in
    div

        [     style "width" "100%"
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
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.xlinkHref link
            ]
            []]
        ,viewTrueEndWords
        ]


viewSamsarabutton : Float -> Html Msg
viewSamsarabutton time =
    Html.button
        (List.append
            [ Html.Events.onClick (Usermsg Samsara)
            , style "background" "none"
            , style "color" "red"
            , style "cursor" "pointer"
            , style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "font-size" "30px"
            , style "font-weight" "bold"
            , style "opacity" (getSamsaraOpacity time)
            ]
            [ style "font-weight" "300"
            , style "height" "60px"
            , style "left" "47%"
            , style "top" "60%"
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" "140px"
            , style "border-radius" "10%"
            ]
        )
        [ text "Samsara" ]

getSamsaraOpacity : Float -> String
getSamsaraOpacity time =
    if time <= 4000 then
        "0"
    else if time <= 5000 then
        (time - 4000)*( 6000 - time )/1000/1000
            |>fromFloat
    else
        "1"




viewBadEndPic : Html Msg
viewBadEndPic =
    div
    [style "position" "absolute",
    style "left" "300px",
    style "top" "250px"]
    [ Svg.svg
            [SvgAttr.width "100%"
             ,SvgAttr.height "100%"]
            [Svg.image
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.xlinkHref "assets/badending.jpg"
            ]
            []]

    ]

viewPhotoGoodEndPic : Html msg
viewPhotoGoodEndPic =
    div
    [style "position" "absolute",
    style "left" "750px",
    style "top" "250px"]
    [ Svg.svg
            [SvgAttr.width "100%"
             ,SvgAttr.height "100%"]
            [Svg.image
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.xlinkHref "assets/PhotographerHE.jpg"
            ]
            []]

    ]

viewPhotoBadEndPic : Html Msg
viewPhotoBadEndPic =
    div
    [style "position" "absolute",
    style "left" "1200px",
    style "top" "250px"]
    [ Svg.svg
            [SvgAttr.width "100%"
             ,SvgAttr.height "100%"]
            [Svg.image
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.xlinkHref "assets/badending.jpg"
            ]
            []]

    ]

viewDrawerGoodEndPic : Html Msg
viewDrawerGoodEndPic = 
    div
    [style "position" "absolute",
    style "left" "300px",
    style "top" "500px"]
    [ Svg.svg
            [SvgAttr.width "100%"
             ,SvgAttr.height "100%"]
            [Svg.image
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.xlinkHref "assets/PainterHE.jpg"
            ]
            []]

    ]
viewDrawerBadEndPic : Html Msg
viewDrawerBadEndPic =
    div
    [style "position" "absolute",
    style "left" "750px",
    style "top" "500px"]
    [ Svg.svg
            [SvgAttr.width "100%"
             ,SvgAttr.height "100%"]
            [Svg.image
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.xlinkHref "assets/badending.jpg"
            ]
            []]

    ]


viewWeaverGoodEndPic : Html Msg
viewWeaverGoodEndPic = 
    div
    [style "position" "absolute",
    style "left" "1200px",
    style "top" "500px"]
    [ Svg.svg
            [SvgAttr.width "100%"
             ,SvgAttr.height "100%"]
            [Svg.image
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.xlinkHref "assets/WeaverHE.jpg"
            ]
            []]

    ]
viewWeaverBadEndPic : Html Msg
viewWeaverBadEndPic =
    div
    [style "position" "absolute",
    style "left" "300px",
    style "top" "750px"]
    [ Svg.svg
            [SvgAttr.width "100%"
             ,SvgAttr.height "100%"]
            [Svg.image
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.xlinkHref "assets/badending.jpg"
            ]
            []]

    ]

viewTrueEndPic : Html Msg 
viewTrueEndPic =
    div
    []
    []

photosViewChunk : List ( Html Msg, ( Line, Bool ) )
photosViewChunk =
    [ ( viewBadEndPic, ( BadLine, False ) )
    , ( viewPhotoGoodEndPic, ( CharacterLine Photographer, True ) )
    , ( viewPhotoBadEndPic, ( CharacterLine Photographer, False ) )
    , ( viewDrawerGoodEndPic, ( CharacterLine Drawer, True ) )
    , ( viewDrawerBadEndPic, ( CharacterLine Drawer, False ) )
    , ( viewWeaverGoodEndPic, ( CharacterLine Weaver, True ) )
    , ( viewWeaverBadEndPic, ( CharacterLine Weaver, False ) )
    , ( viewTrueEndPic, ( TrueLine, True ) )
    ]

photoView :  List Ending -> (Html Msg, (Line , Bool)) -> Html Msg
photoView pastEndings (photo,(line, bool))  =
    let
        thisEnd = Ending line bool
        exist = List.filter (\x -> x == thisEnd) pastEndings
            |> List.length
    in
        if exist>= 1 then
            photo
        else
            emptyEnding

emptyEnding : Html Msg
emptyEnding =
    div
    []
    []

{-|
    This function presents the album of endings.
-}
viewPhotoAlbum : Model -> Html Msg
viewPhotoAlbum model = 
    let
        pastEndings = model.passedEnding
    in
        div
        []
        (List.map (photoView pastEndings) photosViewChunk
            |> List.append [albumBackButton,gamebackground,viewback "assets/Title.jpg"])

{-|
    This function allow players to go back to the map from the album page.
-}
albumBackButton : Html Msg
albumBackButton =
    backButton Map

viewAlbumImage : Svg Msg
viewAlbumImage  =
    let
        link =
            "assets/album_ending.png"
    in
    Svg.image
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.xlinkHref link
        ]
        []
{-|
    This function provides a button to see the album.
-}
albumButton : Html Msg
albumButton =
    Html.button
        (List.append
            [ Html.Events.onClick (Usermsg (BacktoPlace AlbumPage))
            , style "background-color" "transparent"
            , style "border-style" "none"
            , style "bottom" "50%"
            , style "color" "yellow"
            , style "cursor" "pointer"
            , style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "display" "block"
            , style "font-size" "15px"
            ]
            [ style "font-weight" "300"
            , style "height" "150px"
            , style "left" "200px"
            , style "top" "800px"
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" "150px"
            , style "border-radius" "10%"
            ]
        )

        [   
            Svg.svg 
             [  SvgAttr.width "100%"
              , SvgAttr.height "100%"]
             [viewAlbumImage]
        ]
        




