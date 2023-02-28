module UpdateKlotski exposing (updateMoveKlotski, updateStateKlotski, klotskiInit)

{-| This module controls the update for the game Klotski.

# Klotski Update Function
@docs updateMoveKlotski, updateStateKlotski, klotskiInit

-}

import Basis exposing (ClassBuilding(..), MemoryBuilding(..), GamePF(..),GameStatus,Phase(..),Building(..), CharacterIdentity(..), Content(..), GameKind(..), Item(..), LibraryBuilding(..), Page(..), SchoolBuilding(..))
import Klotski exposing (KState(..),KResult(..),initRandomOrderIndex,initRandomOrder,moveCell,KlotskiKind(..))
import Model exposing (Model)
import ModelKlotski exposing (initKmodel)
import Msg exposing (Msg(..),ModelMsg(..))
import MsgKlotski exposing (ModelMsgKlotski(..),UserMsgKlotski(..))
import Random

{-|
    This function is for the update of the game Klotski not controlled by the player.

-}

updateStateKlotski : ModelMsgKlotski -> Model -> ( Model, Cmd Msg )
updateStateKlotski msg model =
    case msg of
        KlotskiAutomatic ->
            let
                nmodel =
                    checkVictoryK model

                kSubmodel =
                    nmodel.kmodel
            in
            case kSubmodel.state of
                KPrepare ->
                            let
                                getInt : Int -> Msg
                                getInt x =
                                    KInitRO x
                                        |> KlotskiModelMsg
                                        |> Modelmsg
                            in
                            if List.length (List.filter (\x -> Tuple.second x.standardActualIndex == 0) kSubmodel.cells) == 9 then
                                ( nmodel, Random.generate getInt initRandomOrderIndex )

                            else
                                ( nmodel, Cmd.none )

                _ ->
                    ( nmodel, Cmd.none )

        KInitRO x ->
            let
                chance =
                    model.kmodel.chance

                orderList =
                    initRandomOrder x

                kind =
                    model.kmodel.nOrp

                {page,item} =
                    model.kmodel.identity

                kSubmodel =
                    initKmodel kind orderList KPlaying chance page item
            in
            ( { model | kmodel = kSubmodel }, Cmd.none )

{-|
    This function is for the update of the game Klotski controlled by the player.

-}

updateMoveKlotski : UserMsgKlotski -> Model -> ( Model, Cmd Msg )
updateMoveKlotski msg model =
    case msg of
        KMove cell ->
            let
                kSubmodel =
                    model.kmodel
            in
            case kSubmodel.result of
                KUndetermined ->
                    let
                        nkSubmodel =
                            { kSubmodel | cells = moveCell kSubmodel.cells cell }
                    in
                    ( { model | kmodel = nkSubmodel }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        KState x ->
            case x of
                KBefore ->
                    let
                        {page,item} =
                            model.kmodel.identity

                        kind = model.kmodel.nOrp

                        chance =
                            model.kmodel.chance - 1

                        kSubmodel =
                            initKmodel kind [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] KShow chance page item
                    in
                    ( { model | kmodel = kSubmodel }, Cmd.none )

                KShow ->
                    let
                        kmodel = model.kmodel
                    in
                    ( { model | kmodel = { kmodel | state = KPrepare } }, Cmd.none )



                KGiveUp ->
                    let
                        kSubmodel =
                            model.kmodel
                    in
                    ( { model | kmodel = { kSubmodel | state = KEnd, result = KFailure } }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        KGame2Plot ->
                kgame2plot model

kgame2plot : Model -> ( Model, Cmd Msg )
kgame2plot model =
            let
                kSubmodel = model.kmodel
                result = kSubmodel.result

                wmodel = model.weaverModel

                {page,item}=kSubmodel.identity

                nmodel =
                    case item of
                        BlueClothFrag ->
                            case result of
                                KVictory ->
                                    if List.isEmpty wmodel.getItems then
                                        { model | weaverModel = { wmodel | getItems = item :: wmodel.getItems } }
                                    else
                                        model
                                _ ->
                                    model
                        _ ->
                            model


                ( npage , nnmodel )=
                    pageBuilding result page model nmodel

            in
            ( { nnmodel | currentPage = npage } , Cmd.none )

pageBuilding : KResult -> Page -> Model -> Model -> ( Page , Model )
pageBuilding result page model nmodel =
                       case page of
                            BuildingPage ( Library (Memory MemoryNone) )->

                                if result == KVictory then
                                    ( page , { nmodel | kmodel = initKmodel Undecided [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] KBefore 4 Map Apple } |> addGSpt )
                                else
                                    ( page , { nmodel | kmodel = initKmodel Undecided [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] KBefore 4 Map Apple })

                            PersonPage Photographer P2 A ->
                                case result of
                                    KVictory ->
                                        let
                                            pmodel = model.photographerModel
                                            npmodel = { pmodel | gamestatusk = GameStatus Pass Klotski}
                                        in
                                        ( PersonPage Photographer P2 B , { nmodel | photographerModel = npmodel } )
                                    KFailure ->
                                        let
                                            pmodel = model.photographerModel
                                            npmodel = { pmodel | gamestatusk = GameStatus Fail Klotski}
                                        in
                                        ( PersonPage Photographer P2 C , { nmodel | photographerModel = npmodel } )
                                    _ ->
                                        ( BuildingPage PhotoStudio , nmodel )

                            BuildingPage ( School Historyroom ) ->
                                ( page , nmodel )
                            _ ->
                                ( page , nmodel )


addGSpt : Model -> Model 
addGSpt model =
    {model | gsPoint = model.gsPoint + 30}


checkVictoryK : Model -> Model
checkVictoryK model =
    let
        kSubmodel =
            model.kmodel
    in
    case kSubmodel.result of
        KUndetermined ->
            if kSubmodel.state /= KGiveUp then
                case List.length (List.filter (\x -> (Tuple.first x.standardActualIndex + 1) == Tuple.second x.standardActualIndex) kSubmodel.cells) of
                    8 ->
                        let
                            nkSubmodel =
                                { kSubmodel | result = KVictory, state = KEnd }
                        in
                        { model | kmodel = nkSubmodel }

                    _ ->
                        model

            else
                let
                    nkSubmodel =
                        { kSubmodel | result = KFailure, state = KEnd }
                in
                { model | kmodel = nkSubmodel }

        _ ->
            model

{-|
    This function is for the initialization of the game Klotski depending on the page on which the player plays the game.

-}

klotskiInit : Model -> Model
klotskiInit model =
    let
        page = model.currentPage
        ( npage , nkmodel )=
            case page of
                BuildingPage ( Library (Memory MemoryNone )) ->
                    (GamePage Klotski , initKmodel BookNumber [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] KBefore 4 page Apple)
                HintPage ->
                    (GamePage Klotski , initKmodel Number [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] KBefore 4 page Apple)
                PersonPage Photographer P2 A ->
                    case model.photographerModel.gamestatusk.pOf of
                        Before ->
                            (GamePage Klotski , initKmodel Photo [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] KBefore 4 page Apple)
                        Pass ->
                            let
                                initkmodel = initKmodel Photo [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] KEnd 4 page Apple
                            in
                            (GamePage Klotski , {initkmodel | result = KVictory })
                        Fail ->
                            let
                                initkmodel = initKmodel Photo [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] KEnd 4 page Apple
                            in
                            (GamePage Klotski , { initkmodel | result = KFailure })
                BuildingPage ( School Historyroom ) ->
                    (GamePage Klotski , initKmodel Cloth [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] KBefore 4 page BlueClothFrag )
                _ ->
                    ( page , model.kmodel)

    in
    { model | kmodel = nkmodel , currentPage = npage }
