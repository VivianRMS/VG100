module ViewSecondBuild exposing (viewLibraryBuild, viewSchoolBuild)
{-|
    This module provides view foo some buildings in the buildings.
# View Buidlings in the buildings
@docs viewLibraryBuild, viewSchoolBuild
-}
import Basis exposing (HistoryBuilding(..),BirthBuilding(..), TxtState(..),ClassBuilding(..), MemoryBuilding(..),TEState(..), Phase(..), Building(..), CharacterIdentity(..), Content(..), DrawerModel, GameKind(..), Item(..), LaterName(..), LibraryBuilding(..), Line(..), Page(..), PhotographerModel, SchoolBuilding(..), StoryLine(..), checkNumberInList)
import Html exposing (Html, div, text, textarea)
import Html.Attributes exposing (style,placeholder,value)
import Html.Events exposing (onInput)
import Model exposing (Model)
import Msg exposing (Msg(..), UserMsg(..), Photographermsg(..))
import ViewBuildings exposing (clickBuildItem, clickBuilding, viewback,viewLockBuilding)
import ViewObjects exposing (viewAllItems, rendertext, viewFragment)
import ViewButton exposing (backButton, enterButton)
import ViewButton exposing (viewPersonUI, viewGSGameUI)



--school
{-|
    This function provides view for the buildings in the school.
-}

viewSchoolBuild : Model -> SchoolBuilding -> Html Msg
viewSchoolBuild model schoolbuild =
    case schoolbuild of
        Classroom build->
            case build of 
                BrushBuild -> viewBrushPage model
                ClassNone -> viewClassroom model

        Artroom ->
            viewArtroom model

        Historyroom ->
            viewHistoryroom model

        SchoolNone ->
            viewSchoolNone model


viewSchoolNone : Model -> Html Msg
viewSchoolNone model =
    div []
        [ viewback "assets/schoolnone.jpg"
        , viewPhotoGrapherAtSchool model.photographerModel
        , viewSchoolMap model
        , backButton Map

        ]


viewPhotoGrapherAtSchool : PhotographerModel -> Html Msg
viewPhotoGrapherAtSchool pmodel =
    let
        leftlist =
            pmodel.leftFragments
    in
    div
        []
        [ viewFragment leftlist 4
        ]


viewClassroom : Model -> Html Msg
viewClassroom model =
    div
        []
        [ viewback "assets/classroom.jpg"
        ,  viewDrawerAtClassroom model
        , viewWeaverAtClassroom
        , backButton (BuildingPage (School SchoolNone))
        , viewAllItems Pencil model
         
        ]


viewArtroom : Model -> Html Msg
viewArtroom model =
    div
        []
        [ if checkNumberInList model.drawerModel.getItems Pencil then
            viewback "assets/artroombrush.jpg"
          else
            viewback "assets/artroom.jpg"
        , viewDrawerAtArtroom model
        , backButton (BuildingPage (School SchoolNone))
        ]



viewHistoryroom : Model -> Html Msg
viewHistoryroom model =
    div
        []
        [ viewback "assets/historyroom.jpg"
        , viewDrawerAtHistory model
        , viewWeaverAtHistory model
        , backButton (BuildingPage (School SchoolNone))
        ]


viewDrawerAtClassroom : Model -> Html Msg
viewDrawerAtClassroom model =
    div
        []
        [ viewAllItems Pencil model
        ]


viewDrawerAtArtroom : Model -> Html Msg
viewDrawerAtArtroom model  =
    let 
        checkPencil = checkNumberInList model.drawerModel.getItems Pencil
        checkPigments = checkNumberInList model.drawerModel.getItems Apple
         && checkNumberInList model.drawerModel.getItems GrassRing
         && checkNumberInList model.drawerModel.getItems BlueCloth

        viewpersonpage =
            case (checkPencil, checkPigments) of
                (False, _) -> viewPersonUI (PersonPage Drawer P1 A)
                (True, False) -> viewPersonUI (PersonPage Drawer P1 B)
                (True, True) -> viewPersonUI (PersonPage Drawer P1 C)
    in
    if model.startTE == TEInProg then
            viewPersonUI (PersonPage Drawer P3 A)
    else  
        if model.day < 5 then
            div []
            [
                viewpersonpage
            ]
        else
            div
            []
            [ 
                viewPersonUI model.nextPersonPage
            ]


viewDrawerAtHistory : Model -> Html Msg
viewDrawerAtHistory model =
    div
        []
        [ viewAllItems BlueCloth model
        ]


viewWeaverAtHistory : Model -> Html Msg
viewWeaverAtHistory model =
    let wmodel = model.weaverModel
    in
    div []
        [ if checkNumberInList wmodel.getTxtClues D then
            viewAllItems BlueClothFrag model

          else
            div [] []
        ]


viewWeaverAtClassroom : Html Msg
viewWeaverAtClassroom =
    div []
        [ viewGSGameUI BallTwo ]


viewSchoolMap : Model -> Html Msg
viewSchoolMap model =
    div
        []
        (viewAllScoolBuild model)


viewAllScoolBuild : Model -> List (Html Msg)
viewAllScoolBuild model =
    if model.day < 5 then
        if
            (checkNumberInList model.drawerModel.getTxtClues A
                && not (checkNumberInList model.drawerModel.getItems Pencil)
            )
                || checkNumberInList model.drawerModel.getTxtClues B
        then
            if model.storyline == Determined (CharacterLine Drawer) then
                List.map clickBuilding allSchoolBuilding

            else
                [ clickBuilding classroom, clickBuilding historyroom, viewLockBuilding lockartroom ]

        else if checkNumberInList model.drawerModel.getItems Pencil then
            List.map clickBuilding allSchoolBuilding

        else
            List.map clickBuilding allSchoolBuilding
    else 
        if model.storyline /= Determined (CharacterLine Drawer) then
            [ clickBuilding classroom, clickBuilding historyroom, viewLockBuilding lockartroom ]
        else List.map clickBuilding allSchoolBuilding


classroom : ( Building, ( Float, Float ), ( Float, Float ) )
classroom =
    ( School (Classroom ClassNone), ( 81, 18 ) ,(350,600))


historyroom : ( Building, ( Float, Float ), ( Float, Float ) )
historyroom =
    ( School Historyroom, ( 12, 30 ),(200,410) )


allSchoolBuilding : List ( Building, ( Float, Float ), ( Float, Float ) )
allSchoolBuilding =
    [ ( School (Classroom ClassNone), ( 81, 18 ) ,(350,600)),( School Artroom, ( 43, 28 ) ,(250,400) ), ( School Historyroom, ( 12, 30 ),(200,410) ) ]

lockartroom : ( Building, ( Float, Float ), ( Float, Float ) )
lockartroom =
    ( School Artroom, ( 35, 25 ) , (500,500))



--library

renderTextLibrary :  Html Msg
renderTextLibrary  =
    div
        [  style "color" "black"
        , style "font-weight" "300"
        , style "line-height" "1"
        , style "margin" "30px 0 0"
        , style "top" "150px"
        , style "font-size" "30px"
        , style "font-family" "Comic Sans MS, Comic Sans, cursive"
        , style "height" "120px"
        , style "right" "100px"
        , style "line-height" "100px"
        , style "position" "absolute"
        ]
        [ 
            text "Select floor here:"
        ]
{-|
    This function provides view for the buildings in the library.
-}

viewLibraryBuild : Model -> LibraryBuilding -> Html Msg
viewLibraryBuild model librarybuild =
    case librarybuild of
        History build->
            case build of 
                OtherHisAlbum -> viewOtherAlbum model.currentPage
                HistoryBuild -> viewHisAlbum 
                HistoryNone -> viewHistory

        Memory build->
            case build of 
                MemoryNone -> viewMemory model
                AlbumBuild -> viewAlbum model
                OtherAlbum -> viewOtherAlbum model.currentPage

        Birth build ->
            case build of 
                OtherBirAlbum -> viewOtherAlbum model.currentPage
                BirthBuild -> viewBirAlbum
                BirthNone -> viewBirth

        LibraryNone ->
            viewLibraryNone model
    
viewOtherAlbum : Page -> Html Msg
viewOtherAlbum page =
    let
        (msg, background) =
            case page of
                BuildingPage (Library place ) ->
                    case place of
                        Memory _ ->
                            (BuildingPage (Library (Memory MemoryNone)), "assets/goldmemory.jpg")
                        Birth _ ->
                            (BuildingPage (Library (Birth BirthNone)), "assets/birth.jpg")
                        History _ ->
                            (BuildingPage (Library (History HistoryNone)), "assets/history.jpg")
                        _ -> (Map,"assets/library.jpg")
                _ ->  (Map,"")

    in
    
    div [] 
        [ viewback background
        , viewback "assets/OtherAlbum.png"
        , backButton msg]

viewHistory :  Html Msg
viewHistory =
    div []
        [ viewback "assets/history.jpg"
        ,   div
            [ style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "font-size" "50px"
            , style "font-weight" "bold"
            , style "line-height" "60px"
            , style "position" "fixed"
            , style "top" "30%"
            , style "left" "30%"
            , style "width" "500px"
            , style "height" "180px"
            ]
            [ 
            ]
        , clickBuildItem (Library (History HistoryBuild ), (42,30), (200,300))
        , clickBuildItem (Library (History OtherHisAlbum), (15,30), (200,300))
        , backButton (BuildingPage (Library LibraryNone))
        ]
viewHisAlbum : Html Msg
viewHisAlbum =
    div [] [
        viewback "assets/HistoryAlbum.png"
    , backButton (BuildingPage (Library (History HistoryNone)))]

viewMemory : Model -> Html Msg
viewMemory model =
    div []
        [ 
         if model.day > 2 && model.day < 5 then 
            div [] [viewback "assets/goldmemory.jpg"
            , viewAllItems AlbumClue model]
          else viewback "assets/goldmemory0.jpg"
        , div
            [ style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "font-size" "50px"
            , style "font-weight" "bold"
            , style "line-height" "60px"
            , style "position" "fixed"
            , style "top" "30%"
            , style "left" "30%"
            , style "width" "500px"
            , style "height" "180px"
            ]
            [
            ]
        , viewWeaverAtMemory
        , clickBuilding (Library (Memory OtherAlbum), (15,30), (200,300))
        , backButton (BuildingPage (Library LibraryNone))
        ]





viewAlbum : Model -> Html Msg
viewAlbum model =
    div []
        [ div
            [ style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "font-size" "50px"
            , style "font-weight" "bold"
            , style "line-height" "60px"
            , style "position" "fixed"
            , style "top" "30%"
            , style "left" "30%"
            , style "width" "500px"
            , style "height" "180px"
            ]
            [ 
            ]
        , viewPhotographerAtAlbum model.photographerModel]


viewPhotographerAtAlbum : PhotographerModel -> Html Msg
viewPhotographerAtAlbum pmodel =
    div[]
    [ case pmodel.isTxtRight of
        No -> viewNo pmodel
        Right -> viewRight
        Wrong -> viewWrong pmodel
    ]

viewNo : PhotographerModel -> Html Msg
viewNo pmodel =
    div []
    [ viewback "assets/albumcover.png"
    , viewTextField pmodel
    , backButton (BuildingPage (Library (Memory MemoryNone)))]

viewRight : Html Msg
viewRight =
    div [][
     viewback "assets/album.png"
    , viewback "assets/sentence.png"
    , backButton (BuildingPage (Library (Memory MemoryNone)))]

viewWrong : PhotographerModel -> Html Msg
viewWrong pmodel =
    div [][rendertext "Wrong."
    , viewTextField pmodel
    , backButton (BuildingPage (Library (Memory MemoryNone)))]

--Drawer
viewBrushPage : Model -> Html Msg
viewBrushPage model =
    div []
        [ div
            [ style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "font-size" "50px"
            , style "font-weight" "bold"
            , style "line-height" "60px"
            , style "position" "fixed"
            , style "top" "30%"
            , style "left" "30%"
            , style "width" "500px"
            , style "height" "180px"
            ]
            [ 
            ]
        , viewDrawerAtBrush model.drawerModel]

viewDrawerAtBrush : DrawerModel -> Html Msg
viewDrawerAtBrush dmodel =
    div[]
    [ viewback "assets/classroom.jpg"
    ,    case dmodel.isTxtRight of
        No -> viewDrawerNo dmodel
        Right -> viewDrawerRight
        Wrong -> viewDrawerWrong dmodel
    ]

viewDrawerNo : DrawerModel -> Html Msg
viewDrawerNo dmodel =
    div []
    [ viewback "assets/classroom.jpg"
    , viewDrawerTextField dmodel
    , backButton (BuildingPage (School (Classroom ClassNone)))]

viewDrawerRight : Html Msg
viewDrawerRight =
    div [][
     viewback "assets/classroom.jpg"
    , rendertext "You get the paintbrush"
    , backButton (BuildingPage (School (Classroom ClassNone)))]

viewDrawerWrong : DrawerModel -> Html Msg
viewDrawerWrong dmodel =
    div [][ viewback "assets/classroom.jpg"
    , rendertext "Wrong"
    , viewDrawerTextField dmodel
    , backButton  (BuildingPage (School (Classroom ClassNone)))]


viewTextField : PhotographerModel -> Html Msg
viewTextField pmodel =
    div []
        [div 
            [style "top" "55%"
            , style "left" "46%"
            , style "width" "1000px"
            , style "height" "180px"
            , style "position" "fixed"]
            [ textarea
                [  placeholder "Input Key" 
                , onInput ChangePhoto
                , value pmodel.albumTxt
                ]
                []
            , div []
                [ text pmodel.albumTxt ]
            ]
        , div []
         [ enterButton (52, 65) (120, 60) Photographer]
            
        ]



viewDrawerTextField : DrawerModel -> Html Msg
viewDrawerTextField dmodel =
    div [style "top" "55%"
            , style "left" "46%"
            , style "width" "1000px"
            , style "height" "180px"
            , style "position" "fixed"]
        [div []
            [ textarea
                [ onInput ChangeDrawer
                , value dmodel.brushTxt
                ]
                []
            , div []
                [ text dmodel.brushTxt ]
            , enterButton (60, 70) (120, 60) Drawer
            ]
        ]

viewWeaverAtMemory : Html Msg
viewWeaverAtMemory =
    div []
        [ viewGSGameUI Klotski
        ]


viewBirth : Html Msg
viewBirth =
    div []
        [ viewback "assets/birth.jpg"
            , div
            [ style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "font-size" "50px"
            , style "font-weight" "bold"
            , style "line-height" "60px"
            , style "position" "fixed"
            , style "top" "30%"
            , style "left" "30%"
            , style "width" "500px"
            , style "height" "180px"
            ]
            [ 
            ]
        , clickBuilding (Library(Birth BirthBuild ), (42,30), (200,300))
        , clickBuilding (Library (Birth OtherBirAlbum), (15,30), (200,300))
        , backButton (BuildingPage (Library LibraryNone))
        ]

viewBirAlbum : Html Msg
viewBirAlbum =
    div [] [
        viewback "assets/BirthAlbum.png"
    , backButton (BuildingPage (Library (Birth BirthNone)))]


viewLibraryNone : Model -> Html Msg
viewLibraryNone model =
    div []
        [ viewPhotoGrapherAtLibrary model.photographerModel
        , viewLibraryMap
        , backButton Map
        , renderTextLibrary
        ]


viewPhotoGrapherAtLibrary : PhotographerModel -> Html Msg
viewPhotoGrapherAtLibrary pmodel =
    let
        leftlist =
            pmodel.leftFragments
    in
    div
        []
        [ viewFragment leftlist 5
        , viewFragment leftlist 7
        ]


viewLibraryMap : Html Msg
viewLibraryMap =
    div []
        (viewAllLibBuild
            |> List.append [viewGuide])

viewGuide : Html Msg
viewGuide =
    Html.button
        (List.append
            [ Html.Events.onClick (Usermsg (BacktoPlace HintPage))
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
            , style "height" "70px"
            , style "left" "85%"
            , style "top" "27%"
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" "200px"
            , style "border-radius" "10%"
            ]
        )
        [ ]
viewAllLibBuild : List (Html Msg)
viewAllLibBuild =
    List.map clickBuilding allLibraryBuilding


history : ( Building, ( Float, Float ), (Float,Float)  )
history =
    ( Library (History HistoryNone), ( 85, 43 ), (200,70) )


memory : ( Building, ( Float, Float ), (Float,Float)  )
memory =
    ( Library (Memory MemoryNone), ( 85, 50 ), (200,80) )


birth : ( Building, ( Float, Float ), (Float,Float)  )
birth =
    ( Library (Birth BirthNone), ( 85, 35 ), (200,70) )


allLibraryBuilding : List ( Building, ( Float, Float ), (Float,Float) )
allLibraryBuilding =
    [ history, memory, birth ]
