module Photographer exposing (getPhotoString, updatePhotographer)
{-| This module controls update related to Photographer.

# Update String in Textfield
@docs getPhotoString

# Update Model Funtion
@docs updatePhotographer

-}


import Model exposing (Model)
import Msg exposing (Msg(..), Photographermsg(..))
import Basis exposing (TxtState(..), Content(..), GameKind(..), Item(..), Page(..))

{-|

    This function update the model after receiving photographer msg.

-}
updatePhotographer : Model -> Photographermsg -> ( Model, Cmd Msg )
updatePhotographer model photomsg =
    case photomsg of
        GetPhotoItem item ->
            -- save item
            ( getItem model item, Cmd.none )

        GetPhotoClue content ->
            ( getContent model content, Cmd.none )

        GetFragment num ->
            giveFragment model num

        JudgePhotoString ->
            ( checkString model, Cmd.none )

checkString : Model -> Model
checkString model =
    let
        pmodel =
            model.photographerModel

        flag =
            pmodel.albumTxt == "5936"

    in

        if flag then
             { model | photographerModel = { pmodel | isTxtRight = Right, getItems = AlbumClue::pmodel.getItems  } }

        else
             { model | photographerModel = { pmodel | isTxtRight = Wrong, getItems = pmodel.getItems  } }

   



getItem : Model -> Item -> Model
getItem model item =
    let
        pmodel =
            model.photographerModel
    in
    { model | photographerModel = { pmodel | getItems = item :: pmodel.getItems } }


getContent : Model -> Content -> Model
getContent model cont =
    let
        pmodel =
            model.photographerModel
    in
    { model | photographerModel = { pmodel | getTxtClues = cont :: pmodel.getTxtClues } }


giveFragment : Model -> Int -> ( Model, Cmd Msg )
giveFragment model num =
    let
        photomodel =
            model.photographerModel

        nleft =
            removeFragment photomodel.leftFragments num

        ngotten =
            getFragment photomodel.getFragments num

        nphotomodel =
            { photomodel | leftFragments = nleft, getFragments = ngotten }
    in
    ( { model | photographerModel = nphotomodel }, Cmd.none )


removeFragment : List Int -> Int -> List Int
removeFragment list num =
    List.filter (\x -> x /= num) list


getFragment : List Int -> Int -> List Int
getFragment list num =
    List.append list [ num ]

{-|

    This function update the model after texting in the textfield of album.

-}
getPhotoString : Model -> String -> Model
getPhotoString model string =
    let
        pmodel =
            model.photographerModel
    in
    { model | photographerModel = { pmodel | albumTxt = string } }