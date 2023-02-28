module Ball_Two.UpdatePlot exposing(updateBallTwoByPlot,checkVictoryBTwo)
{-| This module controls part of the update for the game Break the loop.

# Ball2 Update Function
@docs updateBallTwoByPlot,checkVictoryBTwo

-}

import Ball_Two.Ball_Two exposing (Dir(..),Scene(..),WinOrFail(..),BallState(..),GameStatus(..),Pattern(..),PatternValid(..))
import Ball_Two.Model exposing (initBTwoModel_S1P1,initBTwoModel_S2P1,BTwoModel)
import Basis exposing (Building(..), CharacterIdentity(..), ClassBuilding(..), Content(..),GameKind(..), GamePF(..), GameStatus, Item(..), Page(..), Phase(..), SchoolBuilding(..))
import Model exposing (Model)

{-|
    This function is for the update for the game Defend the fragile by plot.

-}

updateBallTwoByPlot : Model -> Model
updateBallTwoByPlot model =
    let
        result =
            model.b2model.result.victory_or_fail

        { page, item } =
            model.b2model.identity

        pattern =
            model.b2model.pattern

        ( npage, nmodel ) =
            case page of
                PersonPage Photographer P2 D ->
                    case result of
                        GameVictory ->
                            let
                                pmodel =
                                    model.photographerModel

                                npmodel =
                                    { pmodel | gamestatusb2 = GameStatus Pass BallTwo }
                            in
                            ( PersonPage Photographer P2 E, { model | photographerModel = npmodel } )

                        GameFail ->
                            let
                                pmodel =
                                    model.photographerModel

                                npmodel =
                                    { pmodel | gamestatusb2 = GameStatus Fail BallTwo }
                            in
                            ( PersonPage Photographer P2 F, { model | photographerModel = npmodel } )

                        _ ->
                            ( BuildingPage PhotoStudio, model )

                PersonPage Photographer P3 A ->
                    case model.b2model.game_status of
                        ActNotEnough ->
                            ( BuildingPage PhotoStudio, { model | b2model = initBTwoModel_S1P1 page Apple False } )

                        Intro _ ->
                            ( BuildingPage PhotoStudio, { model | b2model = initBTwoModel_S1P1 page Apple False } )

                        _ ->
                            if result == GameVictory then
                                ( GamePage BallTwo, { model | b2model = initBTwoModel_S1P1 page Apple True } |> addGSpt pattern )

                            else
                                ( GamePage BallTwo, { model | b2model = initBTwoModel_S1P1 page Apple True } )

                BuildingPage (School (Classroom ClassNone)) ->
                    if result == GameVictory then
                        ( page, { model | b2model = initBTwoModel_S2P1 page Apple False } |> addGSpt pattern )

                    else
                        ( page, { model | b2model = initBTwoModel_S2P1 page Apple False } )

                _ ->
                    ( page, model )
    in
    { nmodel | currentPage = npage }

{-|
    This function is for the update of judging whether the player wins or loses the game Defend the fragile.

-}

checkVictoryBTwo : BTwoModel -> BTwoModel
checkVictoryBTwo b2model =
    let
        num =
            case b2model.scene of
                Scene1 ->
                    3

                Scene2 ->
                    1
    in
    if b2model.result.win_num >= num then
        let
            tmp_victory =
                b2model.result

            nvictory =
                { tmp_victory | victory_or_fail = GameVictory }
        in
        { b2model | result = nvictory, game_status = End }

    else if b2model.result.lose_num >= 3 then
        let
            tmp_victory =
                b2model.result

            nvictory =
                { tmp_victory | victory_or_fail = GameFail }
        in
        { b2model | result = nvictory, game_status = End }

    else if b2model.round > 5 then
        let
            tmp_victory =
                b2model.result

            nvictory =
                { tmp_victory | victory_or_fail = GameFail }
        in
        { b2model | result = nvictory, game_status = End }

    else
        b2model

addGSpt : Pattern -> Model -> Model
addGSpt pattern model =
    let
        pts =
            case pattern of
                Pattern1 ->
                    20

                Pattern2 ->
                    30
    in
    { model | gsPoint = model.gsPoint + pts }
