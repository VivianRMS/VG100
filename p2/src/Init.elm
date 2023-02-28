module Init exposing (init, initAPts, initFragments, initLimit, reinitModel, reinitTEModel)
{-|
    This module inits the game at the beginning, and reinit some specific modules when neccesary.

# Initial Loading
@docs init

# Reload The Game 
@docs reinitModel, reinitTEModel

# Setting of some parameters
@docs initAPts, initFragments, initLimit

-}
import Ball_Four.Model exposing (initBFourModel_P1)
import Ball_One.Init exposing (initB_OneSubmodel)
import Ball_Three.Init exposing (initB_ThrSubmodel)
import Ball_Two.Model exposing (initBTwoModel_S1P1)
import Basis exposing (GameStatus,GamePF(..),DrawerModel, GameKind(..), Item(..), LineEnding(..), Page(..), PhotographerModel, StoryLine(..), TxtState(..), WeaverModel,CharacterIdentity(..))
import Color exposing (CState(..),Pattern(..))
import Klotski exposing (KState(..), KlotskiKind(..))
import Model exposing (Model)
import ModelColor exposing (initCmodel)
import ModelKlotski exposing (initKmodel)
import Msg exposing (Msg(..))
import Ball_One.Model exposing (Pattern(..))
import Basis exposing (Line(..))
import Basis exposing (LaterName(..))
import Basis exposing (TEState(..))

import Basis exposing (CharacterIdentity(..))
import Browser.Dom exposing (getViewport)
import InitScripts exposing (initScript)
import Task
import Browser.Dom exposing (getViewport)

{-|
    This function initializes the game.
-}
init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel,Task.perform GetViewport getViewport) --initModel
          

initModel : Model
initModel =
    let
        modelA =
            Model 1 initAPts Undetermined [] NotReached LogoPage
        modelB =
            modelA NonePage NonePage initPhotographerModel initDrawerModel initWeaverModel

        modelC =
            modelB (initKmodel Undecided [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] KBefore 4 Map Apple)

        modelD =
            modelC ( initBTwoModel_S1P1 Map Apple False) (initCmodel Map BlueClothFrag CBefore PHint False)
    in

    modelD ( initB_ThrSubmodel Map Apple False) ( initBFourModel_P1 Map Apple False) ( initB_OneSubmodel Map Apple Pattern1 False) 50 TENotReach 0 (1080,720) initScript


{-|
    This function sets the action points that can be used one day.
-}
initAPts : Int
initAPts =
    6


initPhotographerModel : PhotographerModel
initPhotographerModel =
    let
        ini =
            List.range 1 initFragments
        gamestatusk =
            GameStatus Before Klotski
        gamestatusb2 =
            GameStatus Before BallTwo
    in
    PhotographerModel ini [] [] [] "" No False gamestatusk gamestatusb2

{-|
    This function sets the number of photo fragments.
-}
initFragments : Int
initFragments =
    8


initDrawerModel : DrawerModel
initDrawerModel =
    DrawerModel [] [] False (GameStatus Before BallThree)  No ""


initWeaverModel : WeaverModel
initWeaverModel =
    WeaverModel [] [] False "" No False (GameStatus Before BallFour)

initTEPhotographerModel : PhotographerModel
initTEPhotographerModel =
    let
        ini =
            List.range 1 initFragments
        gamestatusk =
            GameStatus Before Klotski
        gamestatusb2 =
            GameStatus Before BallTwo
    in
    PhotographerModel [] ini [AlbumClue] [] "" No False gamestatusk gamestatusb2

initTEDrawerModel : DrawerModel
initTEDrawerModel =
    DrawerModel [Apple, Pencil, Drawing 2, DrawingLater Pastmemory, BlueCloth,  GrassRing] 
    [] False (GameStatus Before BallThree) No ""


initTEWeaverModel : WeaverModel
initTEWeaverModel =
    WeaverModel [BlueClothFrag] [] False "" No False (GameStatus Before BallFour)



{-|
    This function initializes the GT points needed to enter church.
-}
initLimit : Float
initLimit =
    30

{-|
    This function reinits the game after a round is passed.
-}
reinitModel : Model -> Model
reinitModel model =
    let

        modelA =
            Model  1 initAPts Undetermined model.passedEnding NotReached Map

        modelB =
            modelA NonePage NonePage initPhotographerModel initDrawerModel initWeaverModel

        modelC =
            modelB (initKmodel Undecided [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] KBefore 4 Map Apple)

        modelD =
            modelC ( initBTwoModel_S1P1 Map Apple False) (initCmodel Map BlueClothFrag CBefore PHint False)
    in
    modelD ( initB_ThrSubmodel Map Apple False) ( initBFourModel_P1 Map Apple False) ( initB_OneSubmodel Map Apple Pattern1 False) model.gsPoint model.startTE 0 (model.size) initScript


{-|
    This function reinits the game after the TE line is reached.
-}
reinitTEModel : Model -> Model
reinitTEModel model =
    let

        modelA =
            Model  1 initAPts (Determined TrueLine) model.passedEnding NotReached Map

        modelB =
            modelA NonePage NonePage initTEPhotographerModel initTEDrawerModel initTEWeaverModel

        modelC =
            modelB (initKmodel Undecided [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] KBefore 4 Map Apple)

        modelD =
            modelC ( initBTwoModel_S1P1 Map Apple False) (initCmodel Map BlueClothFrag CBefore PHint False)
    in
    modelD ( initB_ThrSubmodel Map Apple False) ( initBFourModel_P1 Map Apple False) ( initB_OneSubmodel Map Apple Pattern1 False) model.gsPoint TEJudge 0 (model.size) initScript



