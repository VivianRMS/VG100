module Weaver exposing (getString, updateWeaver)
{-| This module controls update related to Weaver.

# Update String in Textfield
@docs getString

# Update Model Funtion
@docs updateWeaver

-}

import Basis exposing (CharacterIdentity(..), Phase(..),Content(..), GameKind(..), Item(..), Page(..), TxtState(..))
import Model exposing (Model)
import Init exposing (initLimit)
import Msg exposing (Msg(..), Photographermsg(..), Weavermsg(..))
import Basis exposing (checkNumberInList, Ending, Line(..))


{-|

    This function update the model after receiving weaver msg.

-}
updateWeaver : Model -> Weavermsg -> ( Model, Cmd Msg )
updateWeaver model weavermsg =
    case weavermsg of
        GetWeavItem item ->
            -- save item
            ( getItem model item, Cmd.none )

        GetWeavClue content ->
            ( getContent model content, Cmd.none )

        JudgeString ->
            ( checkString model
            |> uptGSpt
            |> updPersonPage, Cmd.none )


updPersonPage : Model -> Model
updPersonPage model =
    if model.day < 5 then
        case model.weaverModel.isTxtRight of
            Right -> {model | currentPage  = PersonPage Weaver P1 B}
            Wrong -> {model | currentPage  = PersonPage Weaver P1 C}
            No -> model
    else
        case (model.weaverModel.isTxtRight, checkEnding model)  of
            (Right, True) -> 
                    {model | currentPage  = PersonPage Weaver P2 A}
            (Right, False) ->
                    {model | currentPage  = PersonPage Weaver P2 E}
            (Wrong, _)  -> {model | currentPage  = PersonPage Weaver P1 C}
            (No,_) -> model

checkEnding : Model -> Bool
checkEnding model =
    checkNumberInList model.passedEnding (Ending (CharacterLine Drawer) True)

checkString : Model -> Model
checkString model =
    let
        wmodel =
            model.weaverModel

        flag =
            wmodel.churchTxt == "GT" ++ String.fromFloat model.gsPoint
            && model.gsPoint >= initLimit

        state =
            if flag then
                Right

            else
                Wrong
    in
    { model | weaverModel = { wmodel | isTxtRight = state } }

uptGSpt : Model -> Model
uptGSpt model =
    if model.weaverModel.isTxtRight == Right && model.gsPoint >= initLimit then
        {model | gsPoint = model.gsPoint - initLimit }
    else
        model

getItem : Model -> Item -> Model
getItem model item =
    let
        wmodel =
            model.weaverModel
    in
    { model | weaverModel = { wmodel | getItems = item :: wmodel.getItems } }


getContent : Model -> Content -> Model
getContent model cont =
    let
        wmodel =
            model.weaverModel
    in
    { model | weaverModel = { wmodel | getTxtClues = cont :: wmodel.getTxtClues } }

{-|

    This function update the model after texting in the textfield of church.

-}
getString : Model -> String -> Model
getString model string =
    let
        wmodel =
            model.weaverModel
    in
    { model | weaverModel = { wmodel | churchTxt = string } }
