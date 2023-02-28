module Ball_Two.Update exposing (b2Init,updateAngle, updateb2Model, updateb2Modelmsg, updateb2Usermsg)
{-| This module controls part of the update for the game Defend teh fragile.

# Ball2 Update Function
@docs updateAngle, updateb2Model, updateb2Modelmsg, updateb2Usermsg, b2Init

-}

import Ball_Two.Ball_Two exposing (Dir(..),Scene(..),WinOrFail(..),BallState(..),Ball,Basket,GameStatus(..),Pattern(..),BTwoResult,PatternValid(..))
import Ball_Two.Message exposing (BallTwoUserMsg(..), ModelMsgBallTwo(..))
import Ball_Two.Model exposing (BTwoModel,initBTwoModel_S1P1,initBTwoModel_S1P2,initBTwoModel_S2P1,initBTwoModel_S2P2)
import Ball_Two.Initial exposing (initRandomBasketPos_P1,initRandomBasketPos_P2,initBasket_P1)
import Basis exposing (Building(..), CharacterIdentity(..), ClassBuilding(..), Content(..), GameIdentity, GameKind(..), GamePF(..), GameStatus, Item(..), Page(..), Phase(..), SchoolBuilding(..))
import Model exposing (Model)
import Msg exposing (KeyInput(..), ModelMsg(..), Msg(..), UserMsg(..))
import Random
import Ball_Two.UpdatePlot exposing(updateBallTwoByPlot)


-- Basket


changeDir : Basket -> Dir
changeDir basket =
    if basket.basket_posx >= Tuple.second basket.boundary then
        L

    else if basket.basket_posx <= Tuple.first basket.boundary then
        R

    else
        basket.basket_dir


changeBasket : Basket -> Basket
changeBasket basket =
    let
        time_ =
            if changeDir basket /= basket.basket_dir then
                0

            else
                basket.basket_time + 0.005

        nposx =
            case changeDir basket of
                L ->
                    basket.basket_posx - time_

                R ->
                    basket.basket_posx + time_
    in
    { basket | basket_posx = nposx, basket_dir = changeDir basket, basket_time = time_ }


changeAllBasket : List Basket -> List Basket
changeAllBasket baskets =
    List.map changeBasket baskets



-- Ball


changeLaunchState : BTwoModel -> BTwoModel
changeLaunchState b2model =
    if
        b2model.time
            >= 5
            && b2model.game_status
            /= JudgeResult
            && b2model.game_status
            /= Interval
    then
        { b2model | game_status = Playing }

    else
        b2model


getHitList : Ball -> BTwoModel -> List Basket
getHitList ball b2model =
    List.filter
        (\x ->
            ball.ball_posy
                <= x.basket_posy
                + x.basket_radius
                * 1.5
                && ball.ball_posx
                >= Tuple.first x.boundary
                && ball.ball_posx
                + ball.ball_radius
                <= Tuple.second x.boundary
        )
        b2model.basket


checkJudgeHit : BTwoModel -> Bool
checkJudgeHit b2model =
    if (getHitList b2model.ball b2model |> List.length) > 0 then
        True

    else
        False


checkInField : BTwoModel -> Bool
checkInField b2model =
    if
        (b2model.ball.ball_posx <= Tuple.first b2model.field)
            || (b2model.ball.ball_posx >= Tuple.second b2model.field)
            || (b2model.ball.ball_posy <= 5)
    then
        False

    else
        True


changeBall : BTwoModel -> Ball -> Ball
changeBall b2model ball =
    if b2model.game_status == Playing then
        if checkJudgeHit b2model == False && checkInField b2model then
            let
                nposx =
                    ball.ball_posx - cos ball.ball_angle

                nposy =
                    ball.ball_posy - sin ball.ball_angle

                nscale =
                    nposy / 90
            in
            { ball | ball_posx = nposx, ball_posy = nposy, ball_radius = 2 + 5 * nscale, ball_state = Launched }

        else
            { ball | ball_state = Judge, shoot_pos = ( ball.ball_posx, ball.ball_posy ) }

    else
        ball


judgeBallOver : BTwoModel -> Ball -> Bool
judgeBallOver b2model ball =
    if
        b2model.result.victory_or_fail
            == RoundFail
            || (b2model.result.victory_or_fail == RoundVictory && ball.ball_posy > 90)
    then
        True

    else
        False


bounceBall : BTwoModel -> Ball -> Ball
bounceBall b2model ball =
    if
        b2model.game_status
            == Interval
            && (judgeBallOver b2model ball || b2model.scene == Scene2)
    then
        { ball | ball_state = Over }

    else if
        b2model.game_status
            == Interval
            && (b2model.result.victory_or_fail == RoundVictory && ball.ball_posy <= 90)
            && ball.ball_angle
            <= pi
            / 2
    then
        let
            nposx =
                ball.ball_posx - cos ball.ball_angle

            nposy =
                ball.ball_posy + sin ball.ball_angle

            nscale =
                nposy / 100
        in
        { ball | ball_posx = nposx, ball_posy = nposy, ball_radius = 2 + 5 * nscale }

    else if
        b2model.game_status
            == Interval
            && (b2model.result.victory_or_fail == RoundVictory && ball.ball_posy <= 90)
            && ball.ball_angle
            > pi
            / 2
            && ball.ball_angle
            < pi
    then
        let
            nposx =
                ball.ball_posx + cos (pi - ball.ball_angle)

            nposy =
                ball.ball_posy + sin (pi - ball.ball_angle)

            nscale =
                nposy / 90
        in
        { ball | ball_posx = nposx, ball_posy = nposy, ball_radius = 2 + 5 * nscale }

    else
        ball


changeAngle : KeyInput -> Ball -> Ball
changeAngle dir ball =
    if (ball.ball_angle <= 0) && (dir == Left) then
        ball

    else if (ball.ball_angle >= pi) && (dir == Right) then
        ball

    else
        case ball.ball_state of
            NotLaunched ->
                case dir of
                    Left ->
                        let
                            nangle =
                                ball.ball_angle - pi / 50
                        in
                        { ball | ball_angle = nangle }

                    Right ->
                        let
                            nangle =
                                ball.ball_angle + pi / 50
                        in
                        { ball | ball_angle = nangle }

                    _ ->
                        ball

            _ ->
                ball

{-|
    This function is for the update of the game Defend the fragile by players pressing the keyboard.

-}

updateAngle : UserMsg -> BTwoModel -> ( BTwoModel, Cmd Msg )
updateAngle msg b2SubModel =
    let
        nb2model =
            case msg of
                PressedKey ndir ->
                    let
                        tmp_ball =
                            b2SubModel.ball

                        nball =
                            { tmp_ball | ball_dir = ndir }
                    in
                    prepareBall { b2SubModel | ball = nball } ndir

                ReleasedKey _ ->
                    let
                        tmp_ball =
                            b2SubModel.ball

                        nball =
                            { tmp_ball | ball_dir = Idle }
                    in
                    prepareBall { b2SubModel | ball = nball } Idle

                _ ->
                    b2SubModel
    in
    ( nb2model, Cmd.none )


prepareBall : BTwoModel -> KeyInput -> BTwoModel
prepareBall b2model dir =
    if b2model.game_status == Prepare then
        { b2model | ball = changeAngle dir b2model.ball }

    else
        b2model


changeGameStatus : BTwoModel -> BTwoModel
changeGameStatus b2model =
    let
        ngame_status =
            case b2model.ball.ball_state of
                NotLaunched ->
                    Prepare

                Launched ->
                    Playing

                Judge ->
                    JudgeResult

                Bounce ->
                    Interval

                Over ->
                    RoundPage

                GameOver ->
                    End
    in
    { b2model | game_status = ngame_status }


changeBTwoModel : BTwoModel -> BTwoModel
changeBTwoModel b2model =
    let
        b2model_1 =
            changeLaunchState b2model

        tmp_ball =
            changeBall b2model_1 b2model.ball

        b2model_2 =
            { b2model_1 | ball = tmp_ball }

        tmp2_b2model =
            judgeRoundVictory b2model_2 b2model.result |> changeGameStatus

        nb2model =
            { tmp2_b2model | ball = bounceBall tmp2_b2model tmp2_b2model.ball }
                |> changeGameStatus

        nbasket =
            changeAllBasket nb2model.basket
    in
    { nb2model | basket = nbasket }

{-|
    This function is for the update of submodel for the game Defend the fragile.

-}

updateb2Model : Msg -> ( BTwoModel, Cmd Msg ) -> BTwoModel
updateb2Model msg ( b2model, cmd ) =
    let
        nb2model =
            case msg of
                Tick elapsed ->
                    case b2model.game_status of
                        Prepare ->
                            { b2model | time = b2model.time + elapsed / 1000 }
                                |> changeBTwoModel

                        Playing ->
                            { b2model | time = b2model.time + elapsed / 1000 }
                                |> changeBTwoModel

                        JudgeResult ->
                            changeBTwoModel b2model

                        Interval ->
                            changeBTwoModel b2model

                        _ ->
                            b2model

                _ ->
                    b2model
    in
    nb2model

{-|
    This function is for the update of the game Defend the fragile controlled by players.

-}

updateb2Usermsg : BallTwoUserMsg -> Model -> ( Model, Cmd Msg )
updateb2Usermsg msg model =
    let
        b2model =
            model.b2model

        nb2model =
            case msg of
                Start_prepare ->
                    { model | b2model = { b2model | game_status = Prepare } }

                B2ChoosePattern pattern ->
                    let
                        { page, item } =
                            model.b2model.identity

                        npattern =
                            case pattern of
                                2 ->
                                    initBTwoModel_S2P2

                                _ ->
                                    initBTwoModel_S2P1
                    in
                    { model | b2model = npattern page Apple True }

                Start_playing ->
                    { model | b2model = { b2model | game_status = Playing } }

                Pause_prepare ->
                    { model | b2model = { b2model | game_status = Paused_prepare } }

                Pause_playing ->
                    { model | b2model = { b2model | game_status = Paused_playing } }

                Enter ->
                    case model.b2model.identity.page of
                        PersonPage Photographer P2 D ->
                            { model | b2model = { b2model | game_status = Prepare } }

                        _ ->
                            minusApt b2model.pattern model

                _ ->
                    updateb2Usermsg2 msg model

        getFloat : Float -> Msg
        getFloat x =
            Basketposx_P1 x
                |> BallTwoModelMsg
                |> Modelmsg

        getPair : ( Float, Float ) -> Msg
        getPair ( x, y ) =
            Basketposx_P2 ( x, y )
                |> BallTwoModelMsg
                |> Modelmsg

        ncmd =
            case msg of
                Enter ->
                    case b2model.pattern of
                        Pattern1 ->
                            Random.generate getFloat initRandomBasketPos_P1

                        Pattern2 ->
                            Random.generate getPair initRandomBasketPos_P2

                Nextstep ->
                    case b2model.pattern of
                        Pattern1 ->
                            Random.generate getFloat initRandomBasketPos_P1

                        Pattern2 ->
                            Random.generate getPair initRandomBasketPos_P2

                _ ->
                    Cmd.none
    in
    ( nb2model, ncmd )


updateb2Usermsg2 : BallTwoUserMsg -> Model -> Model
updateb2Usermsg2 msg model =
    let
        b2model =
            model.b2model

        nb2model =
            case msg of
                Nextstep ->
                    let
                        nround =
                            b2model.round + 1

                        nwin =
                            b2model.result.win_num

                        nlose =
                            b2model.result.lose_num

                        tmp_victory =
                            b2model.result

                        nvictory =
                            { tmp_victory | win_num = nwin, lose_num = nlose }

                        { page, item } =
                            b2model.identity

                        te =
                            b2model.te

                        initb2model_S1P1 =
                            initBTwoModel_S1P1 page item te

                        initb2model_S1P2 =
                            initBTwoModel_S1P2 page item te

                        initb2model_S2P1 =
                            initBTwoModel_S2P1 page item te

                        initb2model_S2P2 =
                            initBTwoModel_S2P2 page item te
                    in
                    case b2model.scene of
                        Scene1 ->
                            case b2model.pattern of
                                Pattern1 ->
                                    { model | b2model = { initb2model_S1P1 | round = nround, result = nvictory, game_status = Prepare } }

                                Pattern2 ->
                                    { model | b2model = { initb2model_S1P2 | round = nround, result = nvictory, game_status = Prepare } }

                        Scene2 ->
                            case b2model.pattern of
                                Pattern1 ->
                                    { model | b2model = { initb2model_S2P1 | round = nround, result = nvictory, game_status = Prepare } }

                                Pattern2 ->
                                    { model | b2model = { initb2model_S2P2 | round = nround, result = nvictory, game_status = Prepare } }

                B2Game2Plot ->
                    updateBallTwoByPlot model

                _ ->
                    model
    in
    nb2model




minusApt : Pattern -> Model -> Model
minusApt pattern model =
    let
        pts =
            case pattern of
                Pattern1 ->
                    1

                Pattern2 ->
                    2

        b2model =
            model.b2model
    in
    if model.actionpoints - 1 < 0 then
        { model | b2model = { b2model | game_status = ActNotEnough } }

    else if model.actionpoints - pts < 0 then
        { model | b2model = { b2model | game_status = Intro InvalidPattern } }

    else
        { model | actionpoints = model.actionpoints - pts, b2model = { b2model | game_status = Prepare } }

{-|
    This function is for the update of the game Defend the fiagile not controlled by players.

-}

updateb2Modelmsg : ModelMsgBallTwo -> BTwoModel -> BTwoModel
updateb2Modelmsg msg b2model =
    case msg of
        Basketposx_P1 value ->
            let
                tmp_basket =
                    b2model.basket

                changePosx : Basket -> Basket
                changePosx x =
                    { x | basket_posx = value }

                nbasket =
                    List.map changePosx tmp_basket
            in
            { b2model | basket = nbasket }

        Basketposx_P2 value ->
            let
                tmp_basket =
                    b2model.basket

                changePosx1 : Basket -> Basket
                changePosx1 x =
                    { x | basket_posx = Tuple.first value }

                changePosx2 : Basket -> Basket
                changePosx2 x =
                    { x | basket_posx = Tuple.second value }

                nbasket =
                    List.map changePosx1 (tmp_basket |> List.take 1) ++ List.map changePosx2 (tmp_basket |> List.drop 1)
            in
            { b2model | basket = nbasket }



-- Win or Fail


judgeOneHit : Ball -> BTwoModel -> List Basket
judgeOneHit ball b2model =
    if ball.ball_angle >= 0 && ball.ball_angle < pi / 2 then
        List.filter
            (\x ->
                ball.ball_posx
                    >= x.basket_posx
                    - 2
                    && ball.ball_posx
                    <= x.basket_posx
                    + x.basket_radius
                    * 3
                    + 2
            )
            b2model.basket

    else if ball.ball_angle > pi / 2 && ball.ball_angle <= pi then
        List.filter
            (\x ->
                ball.ball_posx
                    + ball.ball_radius
                    >= x.basket_posx
                    - 2
                    && ball.ball_posx
                    + ball.ball_radius
                    <= x.basket_posx
                    + x.basket_radius
                    * 3
                    + 2
            )
            b2model.basket

    else
        List.filter
            (\x ->
                ball.ball_posx
                    + ball.ball_radius
                    * 0.5
                    >= x.basket_posx
                    - 2
                    && ball.ball_posx
                    + ball.ball_radius
                    * 0.5
                    <= x.basket_posx
                    + x.basket_radius
                    * 3
                    + 2
            )
            b2model.basket


judgeHit : BTwoModel -> Bool
judgeHit b2model =
    if (judgeOneHit b2model.ball b2model |> List.length) > 0 then
        True

    else
        False


judgeRoundVictory : BTwoModel -> BTwoResult -> BTwoModel
judgeRoundVictory b2model victory_status =
    let
        ball =
            b2model.ball

        ( nresult, judgeover ) =
            case b2model.game_status of
                Interval ->
                    ( b2model.result, True )

                RoundPage ->
                    ( b2model.result, True )

                End ->
                    ( b2model.result, True )

                JudgeResult ->
                    if checkJudgeHit b2model then
                        if judgeHit b2model then
                            ( { victory_status | win_num = victory_status.win_num + 1, victory_or_fail = RoundVictory }, True )

                        else
                            ( { victory_status | lose_num = victory_status.lose_num + 1, victory_or_fail = RoundFail }, True )

                    else if
                        (ball.ball_posx
                            <= Tuple.first b2model.field
                            && b2model.round
                            <= 5
                        )
                            || (ball.ball_posx
                                    + ball.ball_radius
                                    >= Tuple.second b2model.field
                                    && b2model.round
                                    <= 5
                               )
                    then
                        ( { victory_status | lose_num = victory_status.lose_num + 1, victory_or_fail = RoundFail }, True )

                    else
                        ( { victory_status | lose_num = victory_status.lose_num + 1, victory_or_fail = RoundFail }, True )

                _ ->
                    ( victory_status, False )

        nball =
            case judgeover of
                True ->
                    case b2model.game_status of
                        JudgeResult ->
                            { ball | ball_state = Bounce }

                        _ ->
                            ball

                False ->
                    ball
    in
    { b2model | ball = nball, result = nresult }

{-|
    This function is for the update of initializing the game Defend the fragile under different situations.

-}

b2Init : Model -> Model
b2Init model =
    let
        page =
            model.currentPage

        ( npage, nb2model ) =
            case page of
                PersonPage Photographer P2 D ->
                    case model.photographerModel.gamestatusb2.pOf of
                        Before ->
                            ( GamePage BallTwo, initBTwoModel_S1P1 page Apple False )

                        Pass ->
                            let
                                initBTwoVictory : BTwoResult
                                initBTwoVictory =
                                    BTwoResult 0 0 GameVictory

                                initBallOver : Ball
                                initBallOver =
                                    Ball 0 80 90 8 1 GameOver Left ( 0, 0 )

                                identity =
                                    GameIdentity page Apple

                                initb2model =
                                    BTwoModel initBallOver initBasket_P1 (Intro ValidPattern) 0 0 initBTwoVictory 1 identity ( 5, 155 ) Pattern1 False Scene1
                            in
                            ( GamePage BallTwo, initb2model )

                        Fail ->
                            let
                                initBTwoFailure : BTwoResult
                                initBTwoFailure =
                                    BTwoResult 0 0 GameFail

                                initBallOver : Ball
                                initBallOver =
                                    Ball 0 80 90 8 1 GameOver Left ( 0, 0 )

                                identity =
                                    GameIdentity page Apple

                                initb2model =
                                    BTwoModel initBallOver initBasket_P1 (Intro ValidPattern) 0 0 initBTwoFailure 1 identity ( 5, 155 ) Pattern1 False Scene1
                            in
                            ( GamePage BallTwo, initb2model )

                PersonPage Photographer P3 A ->
                    ( GamePage BallTwo, initBTwoModel_S1P1 page Apple True )

                HintPage ->
                    ( GamePage BallTwo, initBTwoModel_S2P1 page Apple False )

                BuildingPage (School (Classroom ClassNone)) ->
                    ( GamePage BallTwo, initBTwoModel_S2P2 page Apple False )

                _ ->
                    ( page, model.b2model )
    in
    { model | b2model = nb2model, currentPage = npage }
