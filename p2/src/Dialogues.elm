module Dialogues exposing (removeDialogue,viewDialogueModule)
{-|
    This module present dialogues at correct time on the screen.

# View a dialogue
@docs viewDialogueModule

# Remove a dialogue after showing
@docs removeDialogue
-}
import Basis exposing (Phase(..),Content(..),CharacterIdentity(..),Dialogue,DialogueChunk,DialogueIndex,Page(..))
import Msg exposing (Msg(..))
import Model exposing (Model)
import Html exposing (Html,div)
import Html exposing (text)
import Msg exposing (UserMsg(..))
import Html.Events 
import Html.Attributes as HtmlAttr exposing (style)

import Basis exposing (Building(..),Item(..),LaterName(..))
import ViewButton exposing (displayButton,backButton,viewItem, viewPersonUI)
import Basis exposing (SchoolBuilding(..))
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr

searchDialogue : List DialogueChunk -> DialogueIndex -> Maybe DialogueChunk
searchDialogue list index=
    List.filter (dialogueJudge index) list
        |>List.head

dialogueJudge : DialogueIndex -> DialogueChunk -> Bool
dialogueJudge index dialogue  =
    let
        dialogueIndex = dialogue.index
    in
        dialogueIndex == index

renderText : Model -> (Html Msg, Bool)
renderText model = 
    case model.currentPage of
        PersonPage chara phase content ->
            let
                index = DialogueIndex chara phase content
                gotDialogue = searchDialogue model.texts index
            in
                case gotDialogue of
                    Nothing ->
                        (div
                        []
                        []
                        , False)
                    Just dialogueChunk ->
                        renderSentence dialogueChunk
        _ ->
            (div
            []
            []
            ,False)


renderFrame : Html Msg
renderFrame  = 
        
   let
        link =
           "assets/Personpage_dialogue.png"
   in
     div
        [     style "width" "100%"
            , style "height" "100%"
            , style "position" "fixed"
            , style "left" "0"
            , style "top" "0"
            , style "z-index" "-3"
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
       
        ]

renderName : Html Msg
renderName  = 
        
   let
        link =
           "assets/Personpage_name.png"
   in
     div
        [     style "width" "100%"
            , style "height" "100%"
            , style "position" "fixed"
            , style "left" "0"
            , style "top" "0"
            , style "z-index" "-3"
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
       
        ]

renderSentence : DialogueChunk -> (Html Msg,Bool)
renderSentence dialogueChunk =
    let
        sentences = dialogueChunk.contents
    in
        case List.head sentences of
            Nothing ->
                (div
                [HtmlAttr.style "position" "fixed"
                , HtmlAttr.style "left" "550px"
                , HtmlAttr.style "top" "700px"
                , HtmlAttr.style  "font-family" "Comic Sans MS, Comic Sans, cursive"
                , HtmlAttr.style "font-size" "20px"
                , HtmlAttr.style "font-weight" "bold"]
                [text "(End)"],False)
            Just sentence ->
                (renderSentenceParts sentence ,True)

renderSentenceParts : Dialogue -> Html Msg
renderSentenceParts sentence = 
    let
        chara = sentence.character
        words = sentence.content
    in
        div
        []
        [renderCharacter chara,
        renderWords words]

renderCharacter : String -> Html Msg
renderCharacter character = 
    div
    [HtmlAttr.style "position" "fixed"
                , HtmlAttr.style "left" "280px"
                , HtmlAttr.style "top" "590px"
                , HtmlAttr.style  "font-family" "Comic Sans MS, Comic Sans, cursive"
                , HtmlAttr.style "font-size" "24px"
                , HtmlAttr.style "font-weight" "bold"]
    [text character]

renderWords : String -> Html Msg
renderWords words =
    div
    [HtmlAttr.style "position" "fixed"
                , HtmlAttr.style "left" "600px"
                , HtmlAttr.style "top" "750px"
                , HtmlAttr.style  "font-family" "Comic Sans MS, Comic Sans, cursive"
                , HtmlAttr.style "font-size" "24px"
                , HtmlAttr.style "font-weight" "bold"]
    [text words]

{-|
    This function removes a dialogue from the list after showing it,
    so that the next dialogue can be shown.
-}
removeDialogue : Model -> Model
removeDialogue model = 
    let
        page = model.currentPage
    in
    case page of
        PersonPage chara phase content ->
             let
                index = DialogueIndex chara phase content
                (gotDialogues,others) = List.partition (dialogueJudge index) model.texts
                gotDialogue = List.head gotDialogues
            in
                case gotDialogue of
                    Nothing ->
                        model
                    Just dialogue ->
                       let
                            contents = dialogue.contents
                                        |>List.tail
                                        |> Maybe.withDefault []
                            newDialogue = DialogueChunk  dialogue.index contents
                       in
                        {model| texts = List.append [newDialogue] others}
        _ ->
            model

renderNextButton : Bool -> Page -> Page -> Model -> Html Msg
renderNextButton jugde page crtpage model=
    if jugde == True then
         Html.button
        (List.append
            [ Html.Events.onClick
                (Usermsg TextNext)
            , style "background" "white"
            , style "border" "0"
            , style "bottom" "50%"
            , style "color" "black"
            , style "cursor" "pointer"
            , style "font-family" "Comic Sans MS, Comic Sans, cursive"
            , style "display" "block"
            , style "font-size" "22px"
            , style "font-weight" "bold"
            ]
            [ style "font-weight" "300"
            , style "height" "60px"
            , style "left" "75%"
            , style "top" "85%"
            , style "line-height" "60px"
            , style "outline" "none"
            , style "position" "absolute"
            , style "width" "120px"
            , style "border-radius" "10%"
            ]
        )
        [ text "Next" ]
    else
        renderButton model page crtpage 
    
renderButton : Model -> Page -> Page -> Html Msg
renderButton model page crtpage=
    case crtpage of
        PersonPage Photographer P2 A ->
            displayButton "Start Game" (GamePage Basis.Klotski)
        PersonPage Photographer P2 D ->
            displayButton "Start Game" (GamePage Basis.BallTwo)
        PersonPage Photographer P3 A ->
            displayButton "Start Game" (GamePage Basis.BallTwo)
            
        PersonPage Drawer P1 B ->
            div [] [viewPortrait True, backButton page]
        PersonPage Drawer P2 A ->
            div [] [viewChoosePaint model, backButton page]

        PersonPage Drawer P2 B ->
            div [] [viewPortrait False, backButton page]

        PersonPage Drawer P2 C ->
            displayButton "Start Game" (GamePage Basis.BallThree)

        PersonPage Drawer P3 A ->
            div [] [displayButton "Start Game" (GamePage Basis.BallThree)
            , backButton (BuildingPage (School Artroom))]

        PersonPage Weaver P1 B ->
            viewPersonUI (PersonPage Weaver P1 B)
        PersonPage Weaver P1 D ->
            backButton  Map
        PersonPage Weaver P2 E ->
            backButton  Map
        PersonPage Weaver P2 A ->
            displayButton "Start Game" (GamePage Basis.BallFour)
        PersonPage Weaver P3 A ->
            displayButton "Start Game" (GamePage Basis.BallFour)
        _ ->
            backButton page

viewPortrait : Bool ->  Html Msg
viewPortrait blank =
    let
        link = 
            if blank then
                "assets/portrait1.jpg"
            else  
                "assets/portrait2.jpg"
    in
    div [
          style "height" "600px"
        , style "left" "65%"
        , style "top" "5%"
        , style "width" "400px"
        , style "position" "absolute"
        ] 
        [Svg.svg 
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
        ]

viewChoosePaint : Model ->  Html Msg
viewChoosePaint model =
    div []
        [ viewItem (DrawingLater Portrait) model
        , viewItem (DrawingLater Pastmemory) model
        ]

{-|
    This function presents a dialogue on screen
-}
viewDialogueModule : Model -> Html Msg
viewDialogueModule model = 
    let
        (viewText,judge) = renderText model
        page = 
            case model.currentPage of
                PersonPage chara _ _ ->
                    case chara of
                        Photographer ->
                            BuildingPage PhotoStudio
                        Drawer ->
                            BuildingPage (School Artroom)
                        Weaver ->
                            BuildingPage Church
                _ -> Map
    in
        div
        []
        [viewText,
          renderNextButton judge page model.currentPage model
        , renderFrame
        , renderName
        ]
    
    