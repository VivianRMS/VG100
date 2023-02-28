module View exposing (view)

{-| This module is the main view module

# Main View Function
@docs view
-}

import Basis exposing (TEState(..), Phase(..), Building(..), CharacterIdentity(..), Content(..), GameKind(..), Item(..), LibraryBuilding, Line(..), Page(..), PhotographerModel, SchoolBuilding(..), StoryLine(..), TxtState(..), checkNumberInList)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import ItemBoard exposing (viewItems)
import Model exposing (Model)
import Msg exposing (Msg(..), UserMsg(..))
import ViewEndingMap exposing (viewEnd,viewPhotoAlbum,albumButton)

import ViewObjects exposing (viewCharacter, renderInfoBoard, exhaustedWords,viewFragment,viewAllItems, viewTextField)

import ViewSecondBuild exposing (viewLibraryBuild, viewSchoolBuild)
import ViewBuildings exposing (viewback, viewRoadMap,viewAllbuilding,isChurchThree)
import ViewFrameObjects exposing (viewLogoPage)
import ViewFrame exposing (viewGame)
import HintPage exposing (viewHintPage)
import ViewButton exposing (displayButton ,backButton, viewPersonUI, bagButton, thanksButton, viewGSGameUI)
import InstructionPage exposing (viewInstructionPage)
import ThanksPage exposing (viewThanksPage)
import GameTransitionView exposing (gamebackground)
pixelWidth : Float
pixelWidth = 1920 

pixelHeight: Float
pixelHeight = 1080 

{-|
    This function puts the correct images to the screen.
-}

view : Model -> Html Msg
view model =
    let
        ( w, h ) =
            model.size

        r =
            if w / h > pixelWidth / pixelHeight then
                Basics.min 1 (h / pixelHeight)

            else
                Basics.min 1 (w / pixelWidth)
    in
    div
        [
         style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        ]
        [
          div
            [ style "width" (String.fromFloat pixelWidth ++ "px")
            , style "height" (String.fromFloat pixelHeight ++ "px")
            , style "position" "absolute"
            , style "left" (String.fromFloat ((w - pixelWidth * r) / 2) ++ "px")
            , style "top" (String.fromFloat ((h - pixelHeight * r) / 2) ++ "px")
            , style "transform-origin" "0 0"
            , style "transform" ("scale(" ++ String.fromFloat r ++ ")")
            ]
            [
                viewModel model
            ]
        ]
viewModel : Model -> Html Msg
viewModel model =
    case model.currentPage of
        Map ->
            viewMap model

        BuildingPage building ->
            viewBuilding model building

        PersonPage chara _ _ ->
            viewPersonPage model chara

        GamePage gamekind ->
            div
            []
            [ viewGame gamekind model
            ]

        EndingPage ->
            viewEnd model

        NonePage ->
            viewNone

        ExhaustedPage ->
            viewExhaustedPage

        ItemPage ->
            viewItems model
        LogoPage ->
            viewLogoPage model.time

        HintPage ->
          viewHintPage

        AlbumPage ->
            viewPhotoAlbum model 
        InstructionPage ->
            viewInstructionPage model
        ThanksPage ->
            viewThanksPage



viewPersonPage : Model -> CharacterIdentity -> Html Msg
viewPersonPage model chara = 
    div
    []
    [viewCharacter chara model]





viewNone : Html Msg
viewNone =
    div
        []
        []


viewExhaustedPage :  Html Msg
viewExhaustedPage  =
    div
        []
        [ 
         displayButton "Next Day" Map
        , exhaustedWords,
        gamebackground,viewback "assets/Title.jpg"
        ] 


viewMap : Model -> Html Msg
viewMap model =
    div
        []
        (  List.concat [(viewAllbuilding model),

            [ bagButton
            , albumButton
            , thanksButton    
            ]
            , [viewRoadMap]
            , [renderInfoBoard model] ]
        )

viewBuilding : Model -> Building -> Html Msg
viewBuilding model building =
    case building of
        PhotoStudio ->
            viewPhotoStudio model

        Library librarybuild ->
            viewLibrary model librarybuild

        School schoolbuild ->
            viewSchool model schoolbuild

        Church ->
            viewChurch model

        Apartment ->
            viewApartment model

        Lawn ->
            viewLawn model

        ArtMuseum ->
            viewArtMuseum model

        Square ->
            viewSquare model


viewPhotoStudio : Model -> Html Msg
viewPhotoStudio model =
    div
        []
        [ viewback "assets/photostudio.jpg"
        , viewPhotoGrapherAtPhoto model 
        , backButton  Map
        ]


viewPhotoGrapherAtPhoto : Model ->  Html Msg
viewPhotoGrapherAtPhoto model =
    let
        leftlist =
            model.photographerModel.leftFragments
        getFrag = List.length model.photographerModel.getFragments
        getAlbum = checkNumberInList model.photographerModel.getItems AlbumClue
    in
    div
        []
        [ if model.day > 1 then
            viewFragment leftlist 2
         else div [] []
        , if model.startTE == TEInProg then
            viewPersonUI (PersonPage Photographer P3 A)
        else 
            if model.day > 4 then
                if model.storyline == Determined (CharacterLine Photographer) then
                    viewPersonUI model.nextPersonPage
                else 
                    viewPersonUI (PersonPage Photographer P1 D)
            else 
                if model.day == 1 then
                    viewPersonUI (PersonPage Photographer P1 A)
                else
                    if getFrag == 8  then
                        if not getAlbum then
                            viewPersonUI (PersonPage Photographer P1 C)
                        else 
                            viewPersonUI (PersonPage Photographer P1 D)
                    else viewPersonUI (PersonPage Photographer P1 B)
        ]





viewLibrary : Model -> LibraryBuilding -> Html Msg
viewLibrary model librarybuild =
    div
        []
        [  viewback "assets/library.jpg"
        ,  viewLibraryBuild model librarybuild
        ]


viewSchool : Model -> SchoolBuilding -> Html Msg
viewSchool model schoolbuild =
    div
        []
        [ viewSchoolBuild model schoolbuild
        ]


viewApartment : Model -> Html Msg
viewApartment model =
    div
        []
        [ viewback "assets/apartment.jpg"
        , viewPhotoGrapherAtApartment model.photographerModel
        , viewGSGameUI Color
        , backButton  Map
        , renderTextApartment
        ]

renderTextApartment :  Html Msg
renderTextApartment  =
    div
        [  style "color" "#4e486d"
        , style "font-weight" "300"
        , style "line-height" "1"
        , style "margin" "30px 0 0"
        , style "top" "300px"
        , style "font-size" "30px"
        , style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "height" "120px"
        , style "left" "300px"
        , style "line-height" "500px"
        , style "position" "absolute"
        ]
        [ 
            text "The pool seems dirty..."
        ]



viewPhotoGrapherAtApartment : PhotographerModel -> Html Msg
viewPhotoGrapherAtApartment pmodel =
    let
        leftlist =
            pmodel.leftFragments
    in
    div
        []
        [ viewFragment leftlist 6
        ]


viewChurch : Model -> Html Msg
viewChurch model =
    div
        []
        [ 
          viewback "assets/Church1.jpg"
        , backButton Map 
        , viewWeaverAtChurch model]


viewSquare : Model -> Html Msg
viewSquare model =
    div
        []
        [ viewback "assets/square.jpg"
        , viewPhotoGrapherAtSquare model.photographerModel
        , viewWeaverAtSquare
        , backButton  Map
        , viewGSGameUI BallOne
        ]



--judge gs points


viewWeaverAtChurch : Model -> Html Msg
viewWeaverAtChurch model  =
    let

        renderview1 =
            case ( checkcaseone model, isChurchThree model ) of
                ( True, False ) ->
                    viewTextField model.weaverModel

                ( True, True ) ->
                    viewPersonUI (PersonPage Weaver P1 E)

                ( False, _ ) ->
                    viewPersonUI (PersonPage Weaver P1 A)

    in
    div
        []
        [ if model.startTE == TEInProg then
            viewPersonUI (PersonPage Weaver P3 A)
          else
            if model.day <5 then
                div []
                [renderview1]

            else
                div []
                [viewTextField model.weaverModel]
        ]





checkcaseone : Model -> Bool
checkcaseone model =
    checkNumberInList model.weaverModel.getTxtClues A
        && model.weaverModel.nextday


viewPhotoGrapherAtSquare : PhotographerModel -> Html Msg
viewPhotoGrapherAtSquare pmodel =
    let
        leftlist =
            pmodel.leftFragments
    in
    div
        []
        [ viewFragment leftlist 3
        ]


viewWeaverAtSquare : Html Msg
viewWeaverAtSquare =
    div []
        [ viewGSGameUI BallOne
        ]


viewLawn : Model -> Html Msg
viewLawn model =
    div
        []
        [ viewback "assets/lawn0.jpg"
        , viewPhotoGrapherAtLawn model.photographerModel
        , viewDrawerAtLawn model
        , viewWeaverAtLawn
        , backButton Map
        ]


viewWeaverAtLawn : Html Msg
viewWeaverAtLawn =
    div [] []


viewPhotoGrapherAtLawn : PhotographerModel -> Html Msg
viewPhotoGrapherAtLawn pmodel =
    let
        leftlist =
            pmodel.leftFragments
    in
    div
        []
        [ viewFragment leftlist 8
        ]


viewDrawerAtLawn : Model -> Html Msg
viewDrawerAtLawn model =
    div [] [ viewAllItems GrassRing model ]


viewArtMuseum : Model -> Html Msg
viewArtMuseum model =
    div
        []
        [ viewback "assets/artmuseum.jpg"
        , viewPhotoGrapherAtMuseum model.photographerModel
        , backButton Map
        , viewAllItems (Drawing 1) model
        , viewAllItems (Drawing 2) model
        , viewAllItems (Drawing 3) model
        ]


viewPhotoGrapherAtMuseum : PhotographerModel -> Html Msg
viewPhotoGrapherAtMuseum pmodel =
    let
        leftlist =
            pmodel.leftFragments
    in
    div
        []
        [ viewFragment leftlist 1
        ]

