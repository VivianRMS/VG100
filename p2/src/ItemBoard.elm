module ItemBoard exposing (viewItems)
{-|
    This module presents the itemboard page for the player.

# Main ItemboardView Module
@docs viewItems
-}
import Basis exposing (Page(..), PhotographerModel,Item(..))
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Model exposing (Model)
import Msg exposing (Msg(..))
import String exposing (fromFloat, fromInt)
import ViewButton exposing (backButton)
import Basis exposing (LaterName(..))
import Svg
import Svg.Attributes as SvgAttr
import ViewBuildings exposing (viewback)
import GameTransitionView exposing (gamebackground)


{-|
    This function presents the itemboard page for the player.   
-}
viewItems : Model -> Html Msg
viewItems model =
    let
        photoframe =
            model.photographerModel
    in
    div
        []
        [ viewback "assets/bag_inside.jpg",
        gamebackground,
        viewPhotoitems photoframe,
        viewLeftItem model ]


viewPhotoitems : PhotographerModel -> Html Msg
viewPhotoitems pmodel =
    div
        []
        (viewStaticFragements pmodel.getFragments
            |> List.append [ backButton Map ]
        )


viewStaticFragment : Int -> Html Msg
viewStaticFragment num =
    let
        dist =
            toFloat num * 10 - 15
        link = getFragmentLink num
    in
    div
        (List.append
            [ style "cursor" "pointer"
            , style "display" "block"
            ]
            [ style "height" "300px"
            , style "left" "20%"
            , style "top" (fromFloat dist ++ "%")
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" "300px"
           
            ]
        )
        [ Svg.svg
            [SvgAttr.width "100%"
             ,SvgAttr.height "100%"]
            [Svg.image
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.xlinkHref link
            ]
            []] ]

getFragmentLink : Int -> String
getFragmentLink num = 
    let
        frag = modBy 3 num
            + 1
    
    in
        if frag == 1 then
            "assets/photofrag1.png"
        else if frag == 2 then
            "assets/photofrag2.png"
        else if frag == 3 then
            "assets/photofrag3.png"
        else
            ""

viewStaticFragements : List Int -> List (Html Msg)
viewStaticFragements list =
    List.map viewStaticFragment list




combineItems : Model -> List Item
combineItems model = 
    let
        drawerItems = model.drawerModel.getItems
        weaverItems = model.weaverModel.getItems
        photoItems  = model.photographerModel.getItems
        
    in
        List.append drawerItems weaverItems
            |> List.append photoItems

itemLocateMap : List (Item,(Float,Float)) 
itemLocateMap = 
    [(Apple,(300,300)),(Pencil,(300,500)),(BlueCloth,(300,700)),(BlueClothFrag,(500,400)),(GrassRing,(500,600)),(DrawingLater Portrait,(650,400)),(DrawingLater Pastmemory
    ,(650,600)),(Drawing 1,(800,300)),(Drawing 2,(800,500)),(Drawing 3,(800,700)),(AlbumClue,(500,800))]
 
checkOneItem : List Item -> (Item,(Float,Float)) -> Html Msg
checkOneItem hasItem (item,(xlocate,ylocate)) = 
    let
        exist = List.filter (\x -> x== item) hasItem
                    |> List.length
    in
        if exist >= 1 then
            div
            []
            [viewOneItem item (xlocate,ylocate)]
        else
            div
            []
            []

viewOneItem : Item -> (Float,Float) -> Html Msg
viewOneItem item (xlocate,ylocate) = 
    let
       link = getItemlink item 
    in
    div
        (List.append
            [
             style "border" "0"
            , style "bottom" "50%"
           
            , style "cursor" "pointer"
            , style "font-family" "Comic Sans MS, Comic Sans, cursive"
            
          
            ]
            [ 
              style "height" "200px"
            , style "left" (fromFloat xlocate++"px")
            , style "top" (fromFloat ylocate ++ "px")
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" "250px"
           
            ]
        )
        [Svg.svg
            [SvgAttr.width "100%"
             ,SvgAttr.height "100%"]
            [Svg.image
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.xlinkHref link
            ]
            []]]

viewLeftItem : Model -> Html Msg
viewLeftItem model = 
    let
        hadItems = combineItems model
    in
        div
        [
        ]
        (List.map (checkOneItem hadItems) itemLocateMap)



getItemlink : Item -> String
getItemlink item =
    case item of
        AlbumClue ->
            "assets/album.png"
        Apple ->
            "assets/apple.png"
        Pencil ->
            "assets/paintbrush.png"
        Drawing num ->
            "assets/drawing" ++ fromInt(num) ++".png"
        DrawingLater Portrait ->
            "assets/portrait2.jpg"
        DrawingLater Pastmemory ->
            "assets/badending.jpg"
        BlueCloth -> 
            "assets/BlueCloth.png"
        BlueClothFrag ->
            "assets/BlueClothFrag.png"
        GrassRing ->
            "assets/grasscross.png"

