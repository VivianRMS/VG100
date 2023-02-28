module ViewButton exposing (viewItem, backButton, displayButton, enterButton, viewPersonUI, bagButton, thanksButton, viewGSGameUI)

{-|

    This module presents the basic UI buttons.

# View Button Module
@docs viewItem, backButton, displayButton, enterButton, viewPersonUI, bagButton, thanksButton, viewGSGameUI

-}



import Html exposing (Html, text, div)
import Html.Attributes exposing (style)
import Msg exposing (Msg(..), UserMsg(..),Weavermsg(..),Photographermsg(..),Drawermsg(..))
import Basis exposing (Page(..), CharacterIdentity(..),Item(..),LaterName(..),GameKind(..),Phase(..),Content(..),Line(..),checkNumberInList)
import Model exposing (Model)
import Html.Events exposing (onClick)
import String exposing (fromFloat, fromInt)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Debug exposing (toString)

import Svg exposing (image)


{-|

    This function views the button when go to a different page without 
    consuming action points.

-}
backButton :  Page ->Html Msg
backButton page=
    Html.button
        (List.append
            [ onClick (Usermsg (BacktoPlace page))
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
            , style "left" "50px"
            , style "top" "50px"
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
             [Svg.image
               [ SvgAttr.width "100%"
               , SvgAttr.height "100%"
               , SvgAttr.x "0"
               , SvgAttr.y "0"
              , SvgAttr.xlinkHref "assets/back_arrow.png"
        ]
        []]
        
        ]

{-|

    This function views the button when go to next day.

-}
displayButton : String -> Page -> Html Msg
displayButton txt page =
    Html.button
        (List.append
            [ onClick (Usermsg (BacktoPlace page))
            , style "background" "#34495f"
            , style "border" "0"
            , style "bottom" "50%"
            , style "color" "#fff"
            , style "cursor" "pointer"
            , style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "display" "block"
            , style "font-size" "60px"
            ]
            [ style "font-weight" "300"
            , style "height" "200px"
            , style "left" "15%"
            , style "top" "10%"
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" "250px"
            , style "border-radius" "10%"
            ]
        )
        [ text txt ]


{-|

    This function views the Enter button when texts in the textfield.

-}
enterButton : (Float ,Float) -> (Float, Float) -> CharacterIdentity ->  Html Msg
enterButton  (left, top) (width, height) chara=
    let
        msg =
            case chara of
                Photographer -> (Usermsg (PhotographerMsg JudgePhotoString))
                Weaver -> (Usermsg (WeaverMsg JudgeString))
                Drawer -> (Usermsg (DrawerMsg JudgeDrawerString))
                
    in
        Html.button
        (List.append
            [ onClick msg
            , style "background" "White"
            , style "border" "0"
            , style "bottom" "50%"
            , style "color" "black"
            , style "cursor" "pointer"
            , style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "display" "block"
            , style "font-size" "15px"
            ]
            [ style "font-weight" "300"
            , style "width" (fromFloat width ++ "px")
            , style "height" (fromFloat height ++ "px")
            , style "left" (fromFloat left ++ "%")
            , style "top" (fromFloat top ++ "%")
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            
            , style "border-radius" "10%"
            ]
        )
        [ text "Enter" ]



{-|

    This function views the button when go to the bag.

-}
bagButton : Html Msg
bagButton =
    Html.button
        (List.append
            [ onClick (Usermsg (BacktoPlace ItemPage))
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
            , style "left" "25px"
            , style "top" "800px"
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" "150px"
            , style "border-radius" "10%"
            ]
        )
        [ Svg.svg
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            ]
            [ viewBagImage ]
        ]

viewBagImage : Svg Msg
viewBagImage =
    let
        link =
            "assets/bag.png"
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

    This function views the button when go to thanks page.

-}
thanksButton : Html Msg
thanksButton =
    Html.button
        (List.append
            [ onClick (Usermsg (BacktoPlace ThanksPage))
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
            , style "left" "19%"
            , style "top" "850px"
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" "150px"
            , style "border-radius" "10%"
            ]
        )
        [ Svg.svg
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            ]
            [ viewThanksImage ]
        ]


viewThanksImage : Svg Msg
viewThanksImage =
    let
        link =
            "assets/thanks.png"
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

    This function views the item.

-}
viewItem : Item -> Model -> Html Msg
viewItem item model=
    case item of
        Pencil ->
            div [] []

        Drawing int ->
            viewItemUI (Drawing int) ( Usermsg (DrawerMsg (GetItem item)), "Drawing", 1 )

        BlueCloth ->
            viewItemUI BlueCloth ( Usermsg (BacktoPlace (GamePage Color)), "Blue Cloth", 5 )

        BlueClothFrag ->
            viewItemUI BlueClothFrag ( Usermsg (BacktoPlace (GamePage Klotski)), "Cloth Fragments", 5 )

        GrassRing ->
            viewItemUI GrassRing ( Usermsg (BacktoPlace (GamePage Color)), "Grass Ring", 0.1 )

        Apple ->
            viewItemUI Apple ( Usermsg (BacktoPlace (GamePage Color)), "Apple", 2 )

        DrawingLater Portrait ->
            viewDrawinglaterButton ( Usermsg (GotoPlace (PersonPage Drawer P2 B)), "Portrait", 2 )

        DrawingLater Pastmemory ->
            viewPastMemory model
        
        AlbumClue ->
            viewItemUI AlbumClue ( Usermsg (PhotographerMsg (GetPhotoItem item)), "AlbumClue", 2 )

viewItemUI: Item -> (Msg, String, Float) ->  Html Msg
viewItemUI item (msg,txt,top) =
 let
    (nwidth, nheight, ntop) =
      case item of
        Apple ->
          (150,100,70)
        Drawing _ ->
          (250,400,20)
        GrassRing ->
          (120,120,2)
        AlbumClue ->
          (120,120,22)
        BlueCloth ->
          (150,150,top * 12)
        BlueClothFrag ->
          (150,150,top * 12)
        DrawingLater Portrait ->
          (120,120,top * 12)
        _->
         (120,120,top * 12)
    nleft =
      case item of
        Apple ->
          40
        Drawing 1 ->
          16
        Drawing 2 ->
          29
        Drawing 3 ->
          41
        GrassRing ->
          47.8
        AlbumClue ->
          88
        BlueCloth ->
          8
        BlueClothFrag ->
          8
        DrawingLater Portrait ->
          20
        _->
          25
  in
   Html.button
        (List.append
            [ onClick msg
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
            , style "height" (toString nheight ++"px")
            , style "left" (toString nleft ++"%")
            , style "top" (fromFloat (ntop) ++ "%")
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" (toString nwidth ++"px")
            , style "border-radius" "10%"
            ]
        )
        [ viewItemImage item ]

viewItemImage : Item -> Svg Msg
viewItemImage item  =
    let
        link =
          case item of
            Apple ->
              "assets/apple.png"
            Drawing 2 ->
              "assets/drawing2.png"
            Drawing 1 ->
              "assets/drawing1.png"
            Drawing 3 ->
              "assets/drawing3.png"
            GrassRing ->
              "assets/grasscross.png"
            AlbumClue ->
              "assets/album.png"
            BlueCloth ->
              "assets/BlueCloth.png"
            BlueClothFrag ->
              "assets/BlueClothFrag.png"
            DrawingLater Portrait ->
              "assets/portrait1.jpg"
            _->
              ""
    in
        Svg.svg 
             [  SvgAttr.width "100%"
              , SvgAttr.height "100%"]
             [Svg.image
             [ SvgAttr.width "100%"
             , SvgAttr.height "100%"
             , SvgAttr.x "0"
             , SvgAttr.y "0"
             , SvgAttr.xlinkHref link
             ]
             []]
    

viewlockItemUI : Int -> Html Msg
viewlockItemUI top =
    Html.button
        (List.append
            [
              style "background" "black"
            , style "border" "0"
            , style "bottom" "50%"
            , style "color" "yellow"
            , style "cursor" "pointer"
            , style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "display" "block"
            , style "font-size" "15px"
            ]
            [ style "font-weight" "300"
            , style "height" "60px"
            , style "left" "25%"
            , style "top" (fromInt (top * 12) ++ "%")
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" "120px"
            , style "border-radius" "10%"
            ]
        )
        [ text "Past Memory" ]


viewPastMemory : Model -> Html Msg
viewPastMemory model =
    if checkNumberInList model.passedEnding {line = CharacterLine Photographer, result = True} then
        viewDrawinglaterButton ( Usermsg (GotoPlace (PersonPage Drawer P2 C)), "Past Memory", 3 )
    else
        viewlockItemUI 3 --no button, black


viewDrawinglaterButton : (Msg, String, Float) -> Html Msg
viewDrawinglaterButton (msg,txt,top) =
    Html.button
        (List.append
            [ onClick msg
            , style "background" "white"
            , style "border" "0"
            , style "bottom" "50%"
            , style "color" "black"
            , style "cursor" "pointer"
            , style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "display" "block"
            , style "font-size" "15px"
            ]
            [ style "font-weight" "300"
            , style "height" "60px"
            , style "left" "25%"
            , style "top" (fromFloat (top * 12) ++ "%")
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" "120px"
            , style "border-radius" "10%"
            ]
        )
        [ text txt ]



{-|

    This function views the button of talking with Characters.

-}
viewPersonUI : Page -> Html Msg
viewPersonUI page  =
    case page of
      PersonPage chara _ _->
        case chara of 
          Weaver -> 
            if page == PersonPage Weaver P1 A 
            || page == PersonPage Weaver P1 E 
            || page == PersonPage Weaver P3 A then
                viewCharaUI Weaver 29 45 230 270 page
            else if page == PersonPage Weaver P1 B then
                viewCharaUI Weaver 29 45 230 270  (PersonPage Weaver P1 D)
            else div [] []
          Photographer -> 
            viewCharaUI Photographer 15 65 400 600 page
          Drawer ->
            viewCharaUI Drawer 25 10 250 800 page
      _ -> div [] []




viewCharaUI : CharacterIdentity -> Float -> Float -> Float -> Float -> Page -> Html Msg
viewCharaUI chara top left width height page  =
    let
      image = 
        case chara of
          Weaver ->
            Svg.svg
              [SvgAttr.width "100%"
                ,SvgAttr.height "100%"]
              [Svg.image
                  [ SvgAttr.width "100%"
                  , SvgAttr.x "0"
                  , SvgAttr.y "0"
                  , SvgAttr.xlinkHref "assets/Church1CharaUI.png"
                  ]
                  []
              ]
            
          _ -> div [] []
    in
    Html.button
        (List.append
            [ onClick
                (Usermsg (BacktoPlace page))
            , style "background" "transparent"
            , style "border" "0"
            , style "bottom" "50%"
            , style "cursor" "pointer"
            , style "display" "block"
            ]
            [ style "width" ( ( String.fromFloat width )++ "px" )
            , style "height" ( ( String.fromFloat height )++ "px" )
            , style "left" ( ( String.fromFloat left )++ "%" )
            , style "top" ( ( String.fromFloat top )++ "%" )
            , style "outline" "none"
            , style "position" "absolute"
            
            , style "border-radius" "10%"
            ])
            [image]

{-|

    This function views the button of entering GS games.

-}
viewGSGameUI : GameKind -> Html Msg
viewGSGameUI kind =
    let
        ( nleft, ntop ) =
            case kind of
                Klotski ->
                    ( "55%", "55%" )

                BallTwo ->
                    ( "93%", "35%" )

                Color ->
                    ( "40%", "35%" )

                BallOne ->
                    ( "20%", "35%" )

                _ ->
                    ( "-1%", "-1%" )

        ( nwidth, nheight ) =
            case kind of
                Klotski ->
                    ( "150px", "150px" )

                BallTwo ->
                    ( "130px", "200px" )

                Color ->
                    ( "400px", "400px" )

                BallOne ->
                    ( "800px", "300px" )

                _ ->
                    ( "-1px", "-1px" )
    in
    Html.button
        (List.append
            [ onClick (Usermsg (BacktoPlace (GamePage kind)))
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
            , style "left" nleft
            , style "top" ntop
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" nwidth
            , style "border-radius" "10%"
            ]
        )
        []