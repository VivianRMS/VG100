module Judgement exposing (determinePass, judgeExhaustPoint)

{-|
    This module does different judgements for the game.
# Judge The Game Situation
@docs determinePass, judgeExhaustPoint
-}

import Basis exposing (GamePF(..), CharacterIdentity(..), Ending, Line(..), LineEnding(..), Page(..), StoryLine(..))
import Model exposing (Model)
import Basis exposing (TEState(..))

{-|
    This function judges whether a storyline of the game passes.
-}
determinePass : Model -> Line -> Model
determinePass model line =
    (case line of
        BadLine ->
            giveBadEnding model

        CharacterLine identity ->
            judgeCharacterEnding model identity

        TrueLine ->
            judgeTrueLinePass model
    )
        |> changeToEndPage


changeToEndPage : Model -> Model
changeToEndPage model =
    { model | currentPage = EndingPage }


giveBadEnding : Model -> Model
giveBadEnding model =
    let
        badEnding =
            Ending BadLine False
    in
    { model | currentEnding = Reached badEnding }


judgeCharacterEnding : Model -> CharacterIdentity -> Model
judgeCharacterEnding model identity =
    case identity of
        Weaver ->
            judgeWeaverEnding model

        Photographer ->
            judgePhotographerEnding model

        Drawer ->
            judgeDrawerEnding model


-- Three identities are judged seperately because they have really different judgement.

judgeWeaverEnding : Model -> Model
judgeWeaverEnding model =
    if model.weaverModel.gamestatusb4.pOf == Pass  then
        { model | currentEnding = Reached (Ending (CharacterLine Weaver) True ) 
        }
    else
        { model | currentEnding = Reached (Ending (CharacterLine Weaver) False) }


judgeDrawerEnding : Model -> Model
judgeDrawerEnding model =
    if model.drawerModel.gamestatusb3.pOf == Pass then
        { model | currentEnding = Reached (Ending (CharacterLine Drawer) True) }

    else
        { model | currentEnding = Reached (Ending (CharacterLine Drawer) False) }


judgePhotographerEnding : Model -> Model
judgePhotographerEnding model =
    if model.photographerModel.gamestatusk.pOf == Pass && model.photographerModel.gamestatusb2.pOf == Pass then
        { model | currentEnding = Reached (Ending (CharacterLine Photographer) True) }

    else
        { model | currentEnding = Reached (Ending (CharacterLine Photographer) False) }

judgeTrueLinePass : Model -> Model
judgeTrueLinePass model =
    if  model.startTE == TEInProg then
        if model.gsPoint > 30 then
            { model | currentEnding = Reached (Ending TrueLine True) }
        else 
            { model | currentEnding = Reached (Ending TrueLine False) }
    else
        model


{-|
    This function judges whether all action points of a day are exhausted.
-}
judgeExhaustPoint : Model -> Bool
judgeExhaustPoint model =
    model.actionpoints > 0
