module Update exposing (update)
{-|
    This module is the main update module.
# Main Update
@docs update
-}
import Action exposing (backtoPlace, changePlace, textClue)
import Ball_Four.Model exposing (initBFourModel_P1)
import Ball_Four.Update exposing (checkVictoryBFour, updateAdjust, updateb4ByTime, updateb4Usermsg)
import Ball_One.Update exposing (updateAdjustBall, updateB_OneUsrMsg, updateb1ByTime, updateb1ModelMsg)
import Ball_Three.Init exposing (initB_ThrSubmodel)
import Ball_Three.Update exposing (updateb3BrickState, updateb3Key, updateb3ModelMsg, updateb3UserMsg)
import Ball_Two.Model exposing (initBTwoModel_S1P1)
import Ball_Two.Update exposing (updateAngle, updateb2Model, updateb2Modelmsg, updateb2Usermsg)
import Ball_Two.UpdatePlot exposing (checkVictoryBTwo)
import Basis exposing (CharacterIdentity(..), Content(..), Ending, GameKind(..), GamePF(..), GameStatus, Item(..), Line(..), LineEnding(..), Page(..), Phase(..), StoryLine(..), TEState(..), TxtState(..), checkNumberInList)
import Dialogues exposing (removeDialogue)
import Drawer exposing (getDrawerString, updateDrawer)
import Init exposing (initAPts, initFragments, initLimit, reinitModel, reinitTEModel)
import InitScripts exposing (textDrawerP2, textPhotoP2, textWeaverP2, textWeaverP1)
import Judgement exposing (determinePass)
import Klotski exposing (KResult(..), KState(..), KlotskiKind(..))
import Model exposing (Model)
import ModelKlotski exposing (initKmodel)
import Msg exposing (KeyInput(..), ModelMsg(..), Msg(..), UserMsg(..), sendMsg)
import MsgColor exposing (ModelMsgColor(..))
import MsgKlotski exposing (ModelMsgKlotski(..))
import Photographer exposing (getPhotoString, updatePhotographer)
import UpdateColor exposing (updateMoveColor, updateStateColor)
import UpdateKlotski exposing (updateMoveKlotski, updateStateKlotski)
import Weaver exposing (getString, updateWeaver)

{-|
    This function is the main update function of our game.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
        |> updateall msg


updateall : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateall msg ( model, cmd ) =
    (case msg of
        Tick _ ->
            updateTime msg ( model, cmd )

        Usermsg usermsg ->
            updateMove usermsg model

        Modelmsg modelmsg ->
            updateState modelmsg model

        Change string ->
            ( getString model string, Cmd.none )

        ChangePhoto string ->
            ( getPhotoString model string, Cmd.none )

        ChangeDrawer string ->
            ( getDrawerString model string, Cmd.none )

        Resize width height ->
            ( { model | size = ( toFloat width, toFloat height ) }, Cmd.none )

        GetViewport { viewport } ->
            ( { model | size = ( viewport.width, viewport.height ) }, Cmd.none )
    )
        |> checkAll


updateTime : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateTime msg ( model, cmd ) =
    case model.currentPage of
        GamePage kind ->
            updateGamebyTime msg ( model, cmd ) kind

        LogoPage ->
            ( updateLogoByTime model msg, cmd )

        InstructionPage ->
            ( updateInstructionPageByTime model msg, cmd )

        EndingPage ->
            ( updateEndingByTime model msg, cmd )

        _ ->
            ( model, cmd )


updateEndingByTime : Model -> Msg -> Model
updateEndingByTime model msg =
    case msg of
        Tick elapsed ->
            { model | time = model.time + elapsed }

        _ ->
            model


updateLogoByTime : Model -> Msg -> Model
updateLogoByTime model msg =
    case msg of
        Tick elapsed ->
            { model | time = model.time + elapsed }

        _ ->
            model


updateInstructionPageByTime : Model -> Msg -> Model
updateInstructionPageByTime model msg =
    case msg of
        Tick elapsed ->
            { model | time = model.time + elapsed }

        _ ->
            model


updateGamebyTime : Msg -> ( Model, Cmd Msg ) -> GameKind -> ( Model, Cmd Msg )
updateGamebyTime msg ( model, cmd ) gamekind =
    case gamekind of
        Klotski ->
            updateState (KlotskiModelMsg KlotskiAutomatic) model

        BallTwo ->
            let
                nb2model =
                    checkVictoryBTwo (updateb2Model msg ( model.b2model, cmd ))
            in
            ( { model | b2model = nb2model }, cmd )

        Color ->
            updateState (ColorModelMsg ColorAutomatic) model

        BallThree ->
            let
                ( nb3model, ncmd ) =
                    updateb3BrickState model.b3model
            in
            ( { model | b3model = nb3model }, ncmd )

        BallFour ->
            let
                nb4model =
                    checkVictoryBFour (updateb4ByTime msg model.b4model)
            in
            ( { model | b4model = nb4model }, Cmd.none )

        BallOne ->
            let
                ( nb1model, ncmd ) =
                    updateb1ByTime model.b1model
            in
            ( { model | b1model = nb1model }, ncmd )



checkAll : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
checkAll model =
    checkDayEnd model
        |> checkLine
        |> checkLineEnd
        |> checkTELine


checkLine : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
checkLine ( model, cmd ) =
    let
        day =
            model.day

        lineStatus =
            model.storyline
    in
    if day == 5 then
        case lineStatus of
            Undetermined ->
                ( model, Cmd.batch [ cmd, sendMsg (Modelmsg DetermineLine) ] )

            Determined _ ->
                ( model, cmd )

    else
        ( model, cmd )


checkTELine : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
checkTELine ( model, cmd ) =
    if model.startTE == TEJudge && model.day == 1 then
        ( model, Cmd.batch [ cmd, sendMsg (Modelmsg DetermineLine) ] )

    else
        ( model, cmd )


checkLineEnd : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
checkLineEnd ( model, cmd ) =
    if model.day == 8 then
        let
            curEnding =
                model.currentEnding
        in
        case curEnding of
            NotReached ->
                ( model, Cmd.batch [ cmd, sendMsg (Modelmsg Msg.RecordLineEnding) ] )

            _ ->
                ( model, cmd )

    else
        ( model, cmd )


updateMove : UserMsg -> Model -> ( Model, Cmd Msg )
updateMove msg model =
    case msg of

        Samsara ->
            resetModel model

        GotoPlace page ->
            -- deduct action point
            changePlace model page

        BacktoPlace page ->
            --not deduct
            backtoPlace model page
                |> textClue

        PhotographerMsg photomsg ->
            updatePhotographer model photomsg

        DrawerMsg item ->
            updateDrawer model item

        WeaverMsg item ->
            updateWeaver model item

        KlotskiUserMsg klotskimsg ->
            updateMoveKlotski klotskimsg model

        PressedKey keyinput ->
            updateByKeyPress model keyinput

        ReleasedKey keyinput ->
            updateByKeyRelease model keyinput

        BallTwoUserMsg balltwomsg ->
            updateb2Usermsg balltwomsg model

        ColorUserMsg colormsg ->
            updateMoveColor colormsg model

        BallThreeUserMsg ballthreemsg ->
            updateb3UserMsg ballthreemsg model

        BallFourUserMsg ballfourmsg ->
            updateb4Usermsg ballfourmsg model

        BallOneUserMsg ballonemsg ->
            updateB_OneUsrMsg ballonemsg model

        P2G kind ->
            updateP2G model kind

        G2P page ->
            updateG2P model page

        POut ->
            updatePOut model

        TextNext ->
            ( removeDialogue model, Cmd.none )


resetModel : Model -> ( Model, Cmd Msg )
resetModel model =
    if checkNumberInList model.passedEnding (Ending (CharacterLine Weaver) True) then
        ( reinitTEModel model, Cmd.none )

    else
        ( reinitModel model, Cmd.none )


updatePOut : Model -> ( Model, Cmd Msg )
updatePOut model =
    ( { model | currentPage = Map }, Cmd.batch [ sendMsg (Modelmsg TurnDay) ] )


updateG2P : Model -> Page -> ( Model, Cmd Msg )
updateG2P model page =
    ( { model | currentPage = page }, Cmd.none )


updateP2G : Model -> GameKind -> ( Model, Cmd Msg )
updateP2G model kind =
    ( { model | currentPage = GamePage kind }, Cmd.none )


updateByKeyPress : Model -> KeyInput -> ( Model, Cmd Msg )
updateByKeyPress model keyinput =
    case model.currentPage of
        GamePage BallTwo ->
            ( { model | b2model = Tuple.first (updateAngle (PressedKey keyinput) model.b2model) }, Cmd.none )

        GamePage BallThree ->
            ( { model | b3model = updateb3Key (PressedKey keyinput) model.b3model }, Cmd.none )

        GamePage BallFour ->
            ( { model | b4model = Tuple.first (updateAdjust (PressedKey keyinput) model.b4model) }, Cmd.none )

        GamePage BallOne ->
            ( { model | b1model = Tuple.first (updateAdjustBall (PressedKey keyinput) model.b1model) }, Cmd.none )

        LogoPage ->
            case keyinput of
                Skip ->
                    ( { model | currentPage = InstructionPage, time = 0 }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        InstructionPage ->
            case keyinput of
                LoadMap ->
                    ( { model | currentPage = Map, time = 0 }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateByKeyRelease : Model -> KeyInput -> ( Model, Cmd Msg )
updateByKeyRelease model keyinput =
    case model.currentPage of
        GamePage BallTwo ->
            ( { model | b2model = Tuple.first (updateAngle (ReleasedKey keyinput) model.b2model) }, Cmd.none )

        GamePage BallThree ->
            ( { model | b3model = updateb3Key (ReleasedKey keyinput) model.b3model }, Cmd.none )

        GamePage BallFour ->
            ( { model | b4model = Tuple.first (updateAdjust (ReleasedKey keyinput) model.b4model) }, Cmd.none )

        GamePage BallOne ->
            ( { model | b1model = Tuple.first (updateAdjustBall (ReleasedKey keyinput) model.b1model) }, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateState : ModelMsg -> Model -> ( Model, Cmd Msg )
updateState msg model =
    case msg of
        TurnDay ->
            ( turnNextDay model, Cmd.none )

        DetermineLine ->
            ( determineLine model, Cmd.none )

        DeductActionPoint ->
            ( deductActionPoint model
                |> initTxtState
            , Cmd.none
            )

        RecordLineEnding ->
            ( recordEnding model, Cmd.none )

        KlotskiModelMsg klotskimsg ->
            updateStateKlotski klotskimsg model

        BallTwoModelMsg ball2msg ->
            let
                nb2model =
                    updateb2Modelmsg ball2msg model.b2model
            in
            ( { model | b2model = nb2model }, Cmd.none )

        ColorModelMsg colormsg ->
            updateStateColor colormsg model

        BallThreeModelMsg ball3msg ->
            let
                ( nb3model, ncmd ) =
                    updateb3ModelMsg ball3msg model.b3model
            in
            ( { model | b3model = nb3model }, ncmd )

        BallOneModelMsg ball1msg ->
            let
                ( nb1model, ncmd ) =
                    updateb1ModelMsg ball1msg model.b1model
            in
            ( { model | b1model = nb1model }, ncmd )

        ToExhaustPage ->
            ( toExhaustpage model, Cmd.none )


toExhaustpage : Model -> Model
toExhaustpage model =
    { model | lastPage = model.currentPage, currentPage = ExhaustedPage }


recordEnding : Model -> Model
recordEnding model =
    let
        storyline =
            model.storyline
    in
    case storyline of
        Undetermined ->
            model

        Determined line ->
            determinePass model line
                |> insertCurEnding


insertCurEnding : Model -> Model
insertCurEnding model =
    let
        curline =
            model.currentEnding
    in
    case curline of
        NotReached ->
            model

        Reached ending ->
            insertLine model ending


insertLine : Model -> Ending -> Model
insertLine model ending =
    let
        prevLines =
            model.passedEnding

        others =
            List.filter (\x -> x /= ending) prevLines

        updatedLines =
            List.append [ ending ] others
    in
    { model | passedEnding = updatedLines }


deductActionPoint : Model -> Model
deductActionPoint model =
    let
        newActionPoint =
            model.actionpoints - 1
    in
    { model | actionpoints = newActionPoint }


initTxtState : Model -> Model
initTxtState model =
    let
        wmodel =
            model.weaverModel
    in
    { model | weaverModel = { wmodel | isTxtRight = No } }



--determineLine


determineLine : Model -> Model
determineLine model =
    determineWeaverLine model
        |> determineDrawLine
        |> determinePhotoLine
        |> determinePriority
        |> determineBadLine
        |> uptNextPerPage
        |> determineTELine


determinePriority : Model -> Model
determinePriority model =
    photoANDdrawer model


photoANDdrawer : Model -> Model
photoANDdrawer model =
    if checkPhotoLine model && checkDrawerLine model then
        if checkNumberInList model.passedEnding { line = CharacterLine Photographer, result = True } then
            { model
                | storyline = Determined (CharacterLine Drawer)
                , currentPage = Map
            }

        else
            { model
                | storyline = Determined (CharacterLine Photographer)
                , currentPage = Map
            }

    else
        model

determineTELine : Model -> Model
determineTELine model =
    if checkNumberInList model.passedEnding (Ending (CharacterLine Weaver) True) then
        { model
            | storyline = Determined TrueLine
            , startTE = TEInProg
        }

    else
        model


determinePhotoLine : Model -> Model
determinePhotoLine model =
    if checkPhotoLine model then
        { model
            | storyline = Determined (CharacterLine Photographer)
            , currentPage = Map
        }

    else
        model


checkPhotoLine : Model -> Bool
checkPhotoLine model =
    let
        currentFra =
            List.length model.photographerModel.getFragments

        allFra =
            initFragments

        isPhoto =
            currentFra == allFra

        isAlbum =
            checkNumberInList model.photographerModel.getItems AlbumClue
    in
    isPhoto && model.day > 4 && isAlbum


determineWeaverLine : Model -> Model
determineWeaverLine model =
    if checkWeaverLine model then
        { model
            | storyline = Determined (CharacterLine Weaver)
            , currentPage = Map
        }

    else
        model


checkWeaverLine : Model -> Bool
checkWeaverLine model =
    model.gsPoint
        > initLimit
        && checkNumberInList model.weaverModel.getItems BlueClothFrag
        && model.day
        > 4
        && checkNumberInList model.passedEnding (Ending (CharacterLine Photographer) True)
        && checkNumberInList model.passedEnding (Ending (CharacterLine Drawer) True)

determineDrawLine : Model -> Model
determineDrawLine model =
    if checkDrawerLine model then
        { model
            | storyline = Determined (CharacterLine Drawer)
            , currentPage = Map
        }

    else
        model


checkDrawerLine : Model -> Bool
checkDrawerLine model =
    checkNumberInList model.drawerModel.getItems Pencil
        && checkNumberInList model.drawerModel.getItems GrassRing
        && checkNumberInList model.drawerModel.getItems Apple
        && checkNumberInList model.drawerModel.getItems BlueCloth
        && model.day
        > 4


determineBadLine : Model -> Model
determineBadLine model =
    if model.storyline == Undetermined then
        { model | storyline = Determined BadLine }

    else
        model


turnNextDay : Model -> Model
turnNextDay model =
    uptNextDay model
        |> uptNextDayGame
        |> uptWeaverDay
        |> uptNextPerPage
        |> uptScript


uptScript : Model -> Model
uptScript model =
    let
        newTexts =
            case model.storyline of
                Determined (CharacterLine Photographer) ->
                    if model.photographerModel.gamestatusb2.pOf == Fail then
                        textPhotoP2

                    else
                        []

                Determined (CharacterLine Drawer) ->
                    if model.drawerModel.gamestatusb3.pOf == Fail then
                        textDrawerP2

                    else
                        []

                Determined (CharacterLine Weaver) ->
                    if model.weaverModel.gamestatusb4.pOf == Fail then
                        List.concat [textWeaverP1, textWeaverP2]

                    else
                        []

                _ ->
                    []
    in
    { model | texts = List.concat [ newTexts, model.texts ] }


uptNextPerPage : Model -> Model
uptNextPerPage model =
    case model.storyline of
        Determined (CharacterLine Photographer) ->
            uptNextDayPhoto model

        Determined (CharacterLine Drawer) ->
            uptNextDayDraw model

        Determined (CharacterLine Weaver) ->
            uptNextDayWeaver model

        _ ->
            model



--judgements are after the day is added


uptNextDayPhoto : Model -> Model
uptNextDayPhoto model =
    if model.day > 4 then
        case ( model.day, model.photographerModel.gamestatusk.pOf, model.photographerModel.gamestatusb2.pOf ) of
            ( 5, _, _ ) ->
                --End of day 4
                { model | nextPersonPage = PersonPage Photographer P2 A }

            ( 8, _, Pass ) ->
                { model | nextPersonPage = PersonPage Photographer P2 H }

            ( 8, _, Fail ) ->
                { model | nextPersonPage = PersonPage Photographer P2 I }

            ( _, Before, _ ) ->
                { model | nextPersonPage = PersonPage Photographer P2 A }

            ( _, Fail, _ ) ->
                { model | nextPersonPage = PersonPage Photographer P2 A }

            ( _, Pass, Before ) ->
                { model | nextPersonPage = PersonPage Photographer P2 D }

            ( _, Pass, Fail ) ->
                { model | nextPersonPage = PersonPage Photographer P2 D }

            ( _, Pass, Pass ) ->
                { model | nextPersonPage = PersonPage Photographer P2 G }

    else
        model


uptNextDayDraw : Model -> Model
uptNextDayDraw model =
    if model.day > 4 then
        case ( model.day, model.drawerModel.gamestatusb3.pOf ) of
            ( 5, _ ) ->
                { model | nextPersonPage = PersonPage Drawer P2 A }

            ( 8, Pass ) ->
                { model | nextPersonPage = PersonPage Drawer P2 G }

            ( 8, Fail ) ->
                { model | nextPersonPage = PersonPage Drawer P2 H }

            ( _, Fail ) ->
                { model | nextPersonPage = PersonPage Drawer P2 A }

            ( _, Before ) ->
                { model | nextPersonPage = PersonPage Drawer P2 A }

            ( _, Pass ) ->
                { model | nextPersonPage = PersonPage Drawer P2 F }

    else
        model


uptNextDayWeaver : Model -> Model
uptNextDayWeaver model =
    if model.day > 4 then
        case ( model.day, model.weaverModel.gamestatusb4.pOf ) of
            ( 5, _ ) ->
                { model | nextPersonPage = PersonPage Weaver P2 A }

            ( _, Fail ) ->
                { model | nextPersonPage = PersonPage Weaver P2 A }

            ( _, Before ) ->
                { model | nextPersonPage = PersonPage Weaver P2 A }

            ( _, Pass ) ->
                { model | nextPersonPage = PersonPage Weaver P2 D }

    else
        model


uptNextDay : Model -> Model
uptNextDay model =
    let
        day =
            model.day
    in
    if day >= 8 then
        model

    else if day <= 0 then
        model

    else
        { model | day = day + 1, actionpoints = initAPts, currentPage = Map }



-- added to judge whether init games


uptNextDayGame : Model -> Model
uptNextDayGame model =
    let
        nkmodel =
            initKmodel Undecided [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] KBefore 4 Map Apple

        nb2model =
            initBTwoModel_S1P1 Map Apple False

        nb3model =
            initB_ThrSubmodel Map Apple False

        nb4model =
            initBFourModel_P1 Map Apple False

        pmodel =
            model.photographerModel

        dmodel =
            model.drawerModel

        wmodel =
            model.weaverModel

        npmodel =
            case pmodel.gamestatusk.pOf of
                Fail ->
                    { pmodel | gamestatusk = GameStatus Before Klotski }

                _ ->
                    pmodel

        nnpmodel =
            case pmodel.gamestatusb2.pOf of
                Fail ->
                    { npmodel | gamestatusb2 = GameStatus Before BallTwo }

                _ ->
                    npmodel

        ndmodel =
            case dmodel.gamestatusb3.pOf of
                Fail ->
                    { dmodel | gamestatusb3 = GameStatus Before BallThree }

                _ ->
                    dmodel

        nwmodel =
            case wmodel.gamestatusb4.pOf of
                Fail ->
                    { wmodel | gamestatusb4 = GameStatus Before BallFour }

                _ ->
                    wmodel
    in
    { model | kmodel = nkmodel, b2model = nb2model, b3model = nb3model, b4model = nb4model, photographerModel = nnpmodel, drawerModel = ndmodel, weaverModel = nwmodel }


uptWeaverDay : Model -> Model
uptWeaverDay model =
    let
        wmodel =
            model.weaverModel
    in
    if model.day == 5 then
        { model | weaverModel = { wmodel | nextday = False } }

    else
        { model | weaverModel = { wmodel | nextday = True } }




checkDayEnd : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
checkDayEnd ( model, cmd ) =
    let
        nowActionPoint =
            model.actionpoints
    in
    case model.currentPage of
        GamePage _ ->
            ( model, cmd )

        Map ->
            if nowActionPoint == 0 then
                ( model, Cmd.batch [ cmd, sendMsg (Modelmsg TurnDay) ] )

            else
                ( model, cmd )

        _ ->
            ( model, cmd )
