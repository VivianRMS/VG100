module Action exposing (backtoPlace, changePlace, goToBuilding, textClue)
{-| This module controls the actions after the player choose to go to another place

# Location Change Functions
@docs backtoPlace, changePlace, goToBuilding

# Convey Message of Personpage Function
@docs textClue

-}
import Basis exposing (Building(..), CharacterIdentity(..), Content(..), GameKind(..), Page(..),LibraryBuilding(..))
import Judgement exposing (judgeExhaustPoint)
import Model exposing (Model)
import Msg exposing (ModelMsg(..), Msg(..), UserMsg(..), sendMsg)
import UpdateKlotski exposing (klotskiInit)
import UpdateColor exposing (colorInit)
import Basis exposing (Item(..))
import Ball_Two.Update exposing (b2Init)
import Ball_Three.Update exposing (b3Init)
import Ball_Four.Update exposing (b4Init)
import Ball_One.Update exposing (b1Init)

{-|
    This function changes the current page according to the page the player chooses.
    It is different from backtoPlace, as when this function is called, player's action uses action points
    So we judge whether the point of that day is exhausted.
    
-}
changePlace : Model -> Page -> ( Model, Cmd Msg )
changePlace model place =
    if judgeExhaustPoint model then
        case place of
            BuildingPage building ->
                ( goToBuilding model building, sendMsg (Modelmsg DeductActionPoint) )

            PersonPage char phase cont ->
                ( goToPage model (PersonPage char phase cont ), Cmd.none )

            GamePage kind ->
                ( gotoGame model kind, Cmd.none )

            _ ->
                ( model, Cmd.none )

    else
        ( model, sendMsg (Modelmsg ToExhaustPage) )

{-|
    This function changes the current page according to the page the player chooses,
    and load the model correspondingly.
-}

backtoPlace : Model -> Page -> ( Model, Cmd Msg )
backtoPlace model page =
    case page of
        GamePage kind ->
            case kind of
                Klotski ->
                    ( klotskiInit model , Cmd.none )
                Color ->
                    ( colorInit model , Cmd.none )
                BallOne ->
                    ( b1Init model , Cmd.none )
                BallTwo ->
                    ( b2Init model , Cmd.none )
                BallThree ->
                    ( b3Init model , Cmd.none )
                BallFour ->
                    ( b4Init model , Cmd.none )
        _ ->
            ( { model | currentPage = page,lastPage = model.currentPage }, Cmd.none )


{-|
    This function sends messages of recording the experienced dialogue when the user exits 
    the person dialogue in person page.
    
-}
textClue : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
textClue ( model, cmd ) =
    case model.currentPage of
        PersonPage Drawer _ content ->
            ( model, Cmd.batch [ cmd, Msg.sendMsg (Msg.Usermsg (DrawerMsg (Msg.GetClue content))) ] )

        PersonPage Weaver _ content ->
            ( model, Cmd.batch [ cmd, Msg.sendMsg (Msg.Usermsg (WeaverMsg (Msg.GetWeavClue content))) ] )

        PersonPage Photographer _ content ->
            (model, Cmd.batch [cmd, Msg.sendMsg (Msg.Usermsg (PhotographerMsg (Msg.GetPhotoClue content)))])

        _ ->
            ( model, cmd )

{-|
    This function changes the current page to a building.
-}
goToBuilding : Model -> Building -> Model
goToBuilding model building =
    { model | currentPage = BuildingPage building }


goToPage : Model -> Page -> Model
goToPage model page =
    { model | currentPage = page }


gotoGame : Model -> GameKind -> Model
gotoGame model kind =
    { model | currentPage = GamePage kind }


