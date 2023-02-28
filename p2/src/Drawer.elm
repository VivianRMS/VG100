module Drawer exposing (getDrawerString, getItem, updateDrawer)
{-| This module controls update related to Drawer.

# Update String in Textfield
@docs getDrawerString

# Update Model Funtion
@docs updateDrawer

# Update Found Item
@docs getItem

-}

import Basis exposing (Content(..), TxtState(..), GameKind(..), Item(..), Page(..))
import Model exposing (Model)
import Msg exposing (Drawermsg(..), Msg(..), Photographermsg(..))

{-|

    This function update the model after receiving drawer msg.

-}
updateDrawer : Model -> Drawermsg -> ( Model, Cmd Msg )
updateDrawer model drawermsg =
    case drawermsg of
        GetItem item ->
            -- save item
            ( getItem model item, Cmd.none )

        GetClue content ->
            ( getContent model content, Cmd.none )
        
        JudgeDrawerString ->
            ( checkString model, Cmd.none )
        
        
checkString : Model -> Model
checkString model =
    let
        dmodel =
            model.drawerModel

        flag =
            dmodel.brushTxt == "7142"
    in
        if flag then
            { model | drawerModel = { dmodel | isTxtRight = Right, getItems = Pencil::dmodel.getItems  } }

        else
            { model | drawerModel = { dmodel | isTxtRight = Wrong, getItems = dmodel.getItems  } }
    
{-|

    This function update the items found in model.

-}
getItem : Model -> Item -> Model
getItem model item =
    let
        dmodel =
            model.drawerModel
    in
    { model | drawerModel = { dmodel | getItems = item :: dmodel.getItems } }


getContent : Model -> Content -> Model
getContent model cont =
    let
        dmodel =
            model.drawerModel
    in
    { model | drawerModel = { dmodel | getTxtClues = cont :: dmodel.getTxtClues } }


{-|

    This function update the model after texting in the textfield of paintbrush.

-}
getDrawerString : Model -> String -> Model
getDrawerString model string =
    let
        dmodel =
            model.drawerModel
    in
    { model | drawerModel = { dmodel | brushTxt = string } }
