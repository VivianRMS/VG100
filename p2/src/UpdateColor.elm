module UpdateColor exposing (updateMoveColor,updateStateColor,colorInit)
{-| This module controls the update for the game Color Union.

# Color Union Update Function
@docs updateMoveColor, updateStateColor, colorInit

-}
import Basis exposing (TEState(..),GameKind(..),ClassBuilding(..), Building(..), CharacterIdentity(..), Item(..), Page(..), SchoolBuilding(..))
import Color exposing (CState(..),changeColorTris,clickChangeColor,whetherValidClick,CResult(..),Pattern(..),initTriLeft,maxStep)
import Drawer exposing (getItem)
import Model exposing (Model)
import ModelColor exposing (initCmodel)
import Msg exposing (Drawermsg(..), Msg(..))
import MsgColor exposing (UserMsgColor(..),ModelMsgColor(..))

{-|
    This function is for the update of the game Color Union not controlled by the player.

-}
updateStateColor : ModelMsgColor -> Model -> ( Model, Cmd Msg )
updateStateColor msg model =
    case msg of
        ColorAutomatic ->
            if model.cmodel.state /= CEnd then
                let
                    nmodel =
                        checkVictoryC model

                    cSubmodel =
                        nmodel.cmodel

                    ncSubmodel =
                        { cSubmodel | tris = changeColorTris cSubmodel.tris cSubmodel.oldColor cSubmodel.nColor }

                    nnmodel =
                        { model | cmodel = ncSubmodel }
                in
                ( nnmodel, Cmd.none )

            else
                ( model, Cmd.none )

{-|
    This function is for the update of the game Color Union controlled by the player.

-}
updateMoveColor : UserMsgColor -> Model -> ( Model, Cmd Msg )
updateMoveColor msg model =
    case msg of
        CClick tri ->
            let
                cSubmodel =
                    model.cmodel

                tris =
                    cSubmodel.tris

                noldcolor =
                    tri.color

                ncolor =
                    cSubmodel.nColor

                ntris =
                    clickChangeColor tri noldcolor ncolor tris

                ncSubmodel =
                    { cSubmodel | tris = ntris, oldColor = noldcolor, step = cSubmodel.step + 1 }
            in
            case whetherValidClick tri.color tris ncolor cSubmodel.step cSubmodel.pattern of
                True ->
                    ( { model | cmodel = ncSubmodel }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        CNcolor ncolor ->
            case whetherValidClick 1 model.cmodel.tris 0 model.cmodel.step model.cmodel.pattern of
                True ->
                    let
                        cSubmodel =
                            model.cmodel

                        ncSubmodel =
                            { cSubmodel | nColor = ncolor }
                    in
                    ( { model | cmodel = ncSubmodel }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        CState state ->
            case state of
                CBefore ->
                    let
                        cSubmodel =
                            model.cmodel

                        pattern =
                            cSubmodel.pattern

                        ncSubmodel =
                            { cSubmodel | state = CPrepare pattern }
                    in
                    ( { model | cmodel = ncSubmodel }, Cmd.none )

                CPrepare pattern ->
                    let

                        {page,item} = model.cmodel.identity

                        te = model.cmodel.te

                        chance = model.cmodel.chance - 1

                        cSubmodel =
                            initCmodel page item CPlaying pattern te
                    in
                    ( { model | cmodel = { cSubmodel | chance = chance } }, Cmd.none )

                CGiveUp ->
                    let
                        cSubmodel =
                            model.cmodel
                    in
                    ( { model | cmodel = { cSubmodel | state = CEnd, result = CFailure } }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        CGame2Plot ->
            cgame2plot model

cgame2plot : Model -> ( Model , Cmd Msg )
cgame2plot model =
    let
                result =
                    model.cmodel.result

                {page,item} =
                    model.cmodel.identity

                nmodel =
                    if item == Apple || item == BlueCloth || item == GrassRing then
                        case result of
                            CVictory ->
                                getItem model item

                            _ ->
                                model
                    else
                        model

                (npage,nnmodel) =
                    case page of
                        BuildingPage ( School (Classroom ClassNone ) ) ->
                            ( page, { nmodel | cmodel = initCmodel Map BlueClothFrag CBefore PHint False} )
                        BuildingPage ( School Historyroom ) ->
                            ( page, { nmodel | cmodel = initCmodel Map BlueClothFrag CBefore PHint False} )
                        BuildingPage Lawn ->
                            ( page , { nmodel | cmodel = initCmodel Map BlueClothFrag CBefore PHint False} )
                        BuildingPage Apartment ->
                            let
                                te =
                                    case model.startTE of
                                        TEInProg ->
                                            True
                                        _ ->
                                            False
                                npag =
                                    case te of
                                        True ->
                                            GamePage Color
                                        False ->
                                            page

                                nnpage =
                                    if model.cmodel.result == CUndetermined then
                                        page
                                    else
                                        npag

                                pattern = model.cmodel.pattern

                            in
                            if result == CVictory then
                                ( nnpage , { nmodel | cmodel = initCmodel page BlueClothFrag CBefore PHint te}|> ( addGSpt pattern ) )
                            else
                                ( nnpage , { nmodel | cmodel = initCmodel page BlueClothFrag CBefore PHint te} )
                        _ ->
                            ( page , nmodel )
    in
            ( { nnmodel | currentPage = npage }, Cmd.none )

addGSpt : Pattern -> Model -> Model
addGSpt pattern model =
    let
        pts =
            case pattern of
                PLeaf ->
                    10
                PTE1 ->
                    20
                PTE2 ->
                    30
                _ ->
                    0
    in

    {model | gsPoint = model.gsPoint + pts}

checkVictoryC : Model -> Model
checkVictoryC model =
    let
        cSubmodel =
            model.cmodel
    in
    case cSubmodel.result of
        CUndetermined ->
            let
                pattern = cSubmodel.pattern
                firstTri =
                    Maybe.withDefault (initTriLeft pattern ( 0, 0 ) ( 0, 0 )) (List.head cSubmodel.tris)

                testColor =
                    firstTri.color
            in
            if cSubmodel.step >= ( maxStep cSubmodel.pattern ) && List.isEmpty (List.filter (\x -> x.center == True) cSubmodel.tris) then
                let
                    ncSubmodel =
                        { cSubmodel | result = CFailure }

                    nncSubmodel =
                        if ncSubmodel.chance == 0 then
                            { ncSubmodel | state = CEnd }

                        else
                            ncSubmodel
                in
                { model | cmodel = nncSubmodel }

            else
                case List.length (List.filter (\x -> x.color /= testColor) cSubmodel.tris) of
                    0 ->
                        let
                            ncSubmodel =
                                { cSubmodel | result = CVictory, state = CEnd }
                        in
                        { model | cmodel = ncSubmodel }

                    _ ->
                        model

        _ ->
            model

{-|
    This function is for the initialization of the game Color Union depending on the page on which the player plays the game.

-}
colorInit : Model -> Model
colorInit model =
    let
        page = model.currentPage
        ( npage , ncmodel ) =
            case page of
                BuildingPage ( School (Classroom ClassNone ) ) ->
                    ( GamePage Color , initCmodel page Apple CBefore PApple False)
                BuildingPage ( School Historyroom )->
                    ( GamePage Color , initCmodel page BlueCloth CBefore PBlueCloth False)
                BuildingPage Lawn ->
                    ( GamePage Color , initCmodel page GrassRing CBefore PGrassRing False)
                BuildingPage Apartment ->
                    case model.startTE of
                        TEInProg ->
                            ( GamePage Color , initCmodel page BlueClothFrag CBefore PLeaf True)
                        _ ->
                            ( GamePage Color , initCmodel page BlueClothFrag CBefore PLeaf False)
                HintPage ->
                    ( GamePage Color , initCmodel page GrassRing CBefore PHint False)
                _ ->
                    ( page , model.cmodel )
    in
    { model | cmodel = ncmodel , currentPage = npage }

