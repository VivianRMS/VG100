module ViewObjects exposing (viewCharacter, exhaustedWords, renderInfoBoard, rendertext, viewAllItems, viewFragment, viewTextField)
{-|

    This module presents view of objects

# View Character
@docs viewCharacter

# View Items
@docs viewAllItems, viewFragment

# View Textfield
@docs viewTextField

# View Information Funtion
@docs renderInfoBoard

# Give Instructions
@docs exhaustedWords, rendertext

-}

import Basis exposing (Building(..), CharacterIdentity(..), ClassBuilding(..), Content(..), GameKind(..), Item(..), LaterName(..), LibraryBuilding(..), Line(..), Page(..), Phase(..), SchoolBuilding(..), StoryLine(..), TxtState(..), WeaverModel, checkNumberInList)
import Debug exposing (toString)
import Dialogues exposing (viewDialogueModule)
import Html exposing (Html, div, text, textarea)
import Html.Attributes exposing (style,placeholder,value)
import Html.Events exposing (onInput)
import Model exposing (Model)
import Msg exposing (Drawermsg(..), Msg(..), Photographermsg(..), UserMsg(..), Weavermsg(..))
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import ViewBuildings exposing (viewback)
import ViewButton exposing (enterButton, viewItem)


-- Items

{-|

    This function views the UI of photo fragments.

-}
viewFragment : List Int -> Int -> Html Msg
viewFragment list num =
    if checkNumberInList list num then
        div
            []
            [ viewFragementUI (modBy 3 num + 1) num ]

    else
        div
            []
            []


viewFragementUI : Int -> Int -> Html Msg
viewFragementUI x int =
    let
        ( left, top ) =
            case int of
                1 ->
                    ( 64, 20 )

                2 ->
                    ( 20, 47 )

                3 ->
                    ( 20, 10 )

                4 ->
                    ( 20, 20 )

                5 ->
                    ( 74, 91 )

                6 ->
                    ( 30, 58 )

                7 ->
                    ( 66, 48 )

                8 ->
                    ( 41, 26 )

                _ ->
                    ( 20, 20 )
    in
    Html.button
        (List.append
            [ Html.Events.onClick (Usermsg (PhotographerMsg (GetFragment int)))
            , style "background" "transparent"
            , style "display" "block"
            , style "border-style" "none"
            ]
            [
             style "height" "60px"
            , style "left"
                (String.fromFloat left
                    ++ "%"
                )
            , style "top"
                (String.fromFloat top
                    ++ "%"
                )
            , style "position" "absolute"
            , style "width" "100px"
            ]
        )
        [ viewFragImage x ]



viewFragImage : Int -> Svg Msg
viewFragImage int =
    let
        link =
            case int of
                1 ->
                    "assets/photofrag1.png"

                2 ->
                    "assets/photofrag2.png"

                3 ->
                    "assets/photofrag3.png"

                _ ->
                    ""
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

{-|

    This function views the UI of all small items.
    They should be found by users.

-}
viewAllItems : Item -> Model -> Html Msg
viewAllItems item model =
    case item of
        Pencil -> 
            viewBrush model
        Apple -> 
            viewApple model.drawerModel.getItems Apple (Drawing 2) model
        BlueCloth -> 
            viewBlueCloth model.drawerModel.getItems BlueCloth (Drawing 2) model
        BlueClothFrag -> 
            viewBlueClothFrag model.weaverModel.getItems BlueClothFrag model
        GrassRing ->
            viewGrassRing model.day model.drawerModel.getItems GrassRing (Drawing 2) model
        Drawing int ->
            viewPainting model.drawerModel.getItems model (Drawing int)
        AlbumClue ->
            viewItem AlbumClue model
        DrawingLater kind ->
            viewItem (DrawingLater kind) model 



viewBrush : Model -> Html Msg
viewBrush model =
    if judgeBrush model then
        Html.button
            (List.append
                [ Html.Events.onClick (Usermsg (BacktoPlace (BuildingPage (School (Classroom BrushBuild)))))
                , style "background" "transparent"
                , style "border-style" "none"
                , style "bottom" "50%"
                , style "cursor" "pointer"
                , style "display" "block"
                ]
                [ style "height" "140px"
                , style "left" "40%"
                , style "top" "70%"
                , style "line-height" "60px"
                , style "outline" "none"
                , style "position" "absolute"
                , style "width" "50"
                , style "border-radius" "10%"
                ]
            )
            [ Svg.svg
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                ]
                [ Svg.image
                    [ SvgAttr.width "100%"
                    , SvgAttr.height "100%"
                    , SvgAttr.x "0"
                    , SvgAttr.y "0"
                    , SvgAttr.xlinkHref "assets/paintbrush.png"
                    ]
                    []
                ]
            ]

    else
        div [] []


judgeBrush : Model -> Bool
judgeBrush model =
    not (checkNumberInList model.drawerModel.getItems Pencil)
        && checkNumberInList model.drawerModel.getTxtClues A


viewApple : List Item -> Item -> Item -> Model -> Html Msg
viewApple listitem item drawing model =
    if
        not (checkNumberInList listitem item)
            && checkNumberInList listitem drawing
    then
        div
            []
            [ viewItem Apple model ]

    else
        div [] []


viewBlueCloth : List Item -> Item -> Item -> Model -> Html Msg
viewBlueCloth listitem item drawing model =
    if
        not (checkNumberInList listitem item)
            && checkNumberInList listitem drawing
    then
        div
            []
            [ viewItem BlueCloth model ]

    else
        div [] []


viewBlueClothFrag : List Item -> Item -> Model -> Html Msg
viewBlueClothFrag listitem bluecloth model =
    if not (checkNumberInList listitem bluecloth) then
        div
            []
            [ viewItem BlueClothFrag model ]

    else
        div [] []


viewGrassRing : Int -> List Item -> Item -> Item -> Model -> Html Msg
viewGrassRing day listitem item drawing model =
    if
        not (checkNumberInList listitem item)
            && checkNumberInList listitem drawing
            && day
            == 4
    then
        div
            []
            [ viewItem GrassRing model ]

    else
        div [] []


viewPainting : List Item -> Model -> Item -> Html Msg
viewPainting listitem model item =
    if not (checkNumberInList listitem item) then
        div
            []
            [ viewItem item model
            ]

    else
        div [] []

{-|

    This function views the page of talking with characters.

-}
viewCharacter : CharacterIdentity -> Model -> Html Msg
viewCharacter chara model =
    case chara of 
        Photographer ->
            viewPhotographer model
        Drawer ->
            viewDrawer model
        Weaver ->
            viewWeaver model

viewPhotographer : Model -> Html Msg
viewPhotographer model =
    div []
        [ viewback "assets/photostudio.jpg"
        , viewPersonImage Photographer
        , viewDialogueModule model
        ]


viewDrawer : Model -> Html Msg
viewDrawer model =

    div []
        [ if checkNumberInList model.drawerModel.getItems Pencil then
            viewback "assets/artroombrush.jpg"
          else
            viewback "assets/artroom.jpg"
        , viewPersonImage Drawer
        , viewDialogueModule model]


viewWeaver : Model -> Html Msg
viewWeaver model =
    let
        viewbackground =
            case model.currentPage of
                PersonPage Weaver P1 D ->
                    viewBackCry

                PersonPage Weaver P1 _ ->
                    viewback "assets/Church1.jpg"

                PersonPage Weaver P2 _ ->
                    viewBackNotCry

                PersonPage Weaver P3 _ ->
                    viewBackNotCry

                _ ->
                    div [] []
    in
    div []
    [ viewbackground
    , viewPersonImage Weaver
    , viewDialogueModule model
    ]
        

viewPersonImage : CharacterIdentity -> Html Msg
viewPersonImage chara =
    let
        link =
            case chara of
                Photographer ->
                    "assets/photographer.png"

                Drawer ->
                    "assets/drawer.png"

                Weaver ->
                    "assets/weaver.png"
    in
    div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "fixed"
        , style "left" "0"
        , style "top" "0"
        , style "z-index" "-5"
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


viewBackCry : Html Msg
viewBackCry =
    viewback "assets/ChurchCry.jpg"


viewBackNotCry : Html Msg
viewBackNotCry =
    viewback "assets/ChurchNotCry.jpg"

{-|
    This function renders the text on the screen.
-}
rendertext : String -> Html Msg
rendertext content = 
        div
            [ style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "font-size" "50px"
            , style "font-weight" "bold"
            , style "line-height" "60px"
            , style "position" "fixed"
            , style "top" "30%"
            , style "left" "30%"
            , style "width" "1000px"
            , style "height" "180px"
            ]
            [ text content
            ]
{-|

    This function views the text field of the key to enter church.

-}
viewTextField : WeaverModel -> Html Msg
viewTextField wmodel =
    div []
        [ div
            [ style "top" "55%"
            , style "left" "46%"
            , style "width" "1000px"
            , style "height" "180px"
            , style "position" "fixed"
            ]
            [ textarea
                [ placeholder "Input Key"
                , onInput Change
                , placeholder "Input like 'GT50'"
                , value wmodel.churchTxt
                ]
                []
            , div []
                [ text wmodel.churchTxt ]
            ]
        , div [] [ enterButton ( 60, 70 ) ( 120, 60 ) Weaver ]
        ]

{-|
    This function provides the text hint when action points of a day is exhausted
-}
exhaustedWords : Html Msg
exhaustedWords =
    div
        (List.append
            [ style "color" "red"
            , style "cursor" "pointer"
            , style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "display" "block"
            , style "font-size" "40px"
            , style "font-weight" "bold"
            ]
            [ style "font-weight" "300"
            , style "left" "35%"
            , style "top" "45%"
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            ]
        )
        [ text "Time Exhausted. Day passed." ]

{-|

    This function views the information of the playing status in Map.

-}
renderInfoBoard : Model -> Html Msg
renderInfoBoard model =
    div []
        [ viewActionPoints model
        , viewMapBoard 
        , viewDate model
        , renderGTpoints model
        ]

viewActionPoints : Model -> Svg Msg
viewActionPoints model =
    div
        [ style "width" "300px"
        , style "height" "300px"
        , style "position" "fixed"
        , style "left" "40px"
        , style "top" "150px"
        , style "z-index" "-3"
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
                , SvgAttr.xlinkHref ("assets/apt" ++ toString model.actionpoints ++ ".png")
                ]
                []
            ]
        ]


viewMapBoard : Svg Msg
viewMapBoard =
    let
        link =
            "assets/mapBoard.jpg"
    in
    div
        [ style "width" "400px"
        , style "height" "864px"
        , style "position" "fixed"
        , style "left" "-10px"
        , style "top" "120px"
        , style "z-index" "-4"
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


viewDate : Model -> Svg Msg
viewDate model =
    let
        link =
            "assets/calender.png"
    in
    div
        [ style "width" "300px"
        , style "height" "300px"
        , style "position" "fixed"
        , style "left" "42px"
        , style "top" "400px"
        , style "z-index" "-2"
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
        , renderTextDate model
        ]


renderTextDate : Model -> Html Msg
renderTextDate model =
    div
        [ style "color" "red"
        , style "font-weight" "300"
        , style "line-height" "1"
        , style "margin" "30px 0 0"
        , style "top" "80px"
        , style "font-size" "60px"
        , style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "height" "120px"
        , style "left" "130px"
        , style "line-height" "100px"
        , style "position" "absolute"
        ]
        [ text (toString model.day)
        ]


renderGTpoints : Model -> Html Msg
renderGTpoints model =
    div
        [ style "color" "black"
        , style "font-weight" "300"
        , style "line-height" "1"
        , style "margin" "30px 0 0"
        , style "top" "650px"
        , style "font-size" "40px"
        , style "font-family" "fantasy"
        , style "height" "120px"
        , style "left" "80px"
        , style "line-height" "100px"
        , style "position" "absolute"
        ]
        [ text ("GT points: " ++ toString model.gsPoint)
        ]
