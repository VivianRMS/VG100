module Ball_Four.Update exposing (updateb4ByTime,updateb4Usermsg,b4Init,updateAdjust,checkVictoryBFour)

{-| This module controls part of the update for the game Break the loop.

# Ball4 Update Function
@docs updateb4ByTime,updateb4Usermsg,b4Init,updateAdjust,checkVictoryBFour

-}


import Ball_Four.Ball_Four exposing (Ball,GameStatus(..),BallState(..),WinOrFail(..),Pattern(..),PatternValid(..),BFourResult,initHole)
import Ball_Four.Message exposing (BallFourUserMsg(..))
import Ball_Four.Model exposing (BFourModel,initBFourModel_P1,initBFourModel_P2)
import Ball_Four.Update2 exposing (changehole)
import Basis exposing (Building(..), CharacterIdentity(..), Content(..), GameIdentity, GameKind(..), GamePF(..), GameStatus, Item(..), LibraryBuilding(..), Page(..), Phase(..), SchoolBuilding(..))
import Model exposing (Model)
import Msg exposing (KeyInput(..), Msg(..), UserMsg(..))



-- Ball


changeBall : BFourModel -> Ball -> Ball
changeBall b4model ball =
    if b4model.game_status == Playing then
        if ball.ball_posy >= 90 - toFloat ball.ball_distance * sin ball.ball_angle && ball.ball_posy <= 90 then
            let
                nposx =
                    ball.ball_posx - cos ball.ball_angle

                nposy =
                    ball.ball_posy - sin ball.ball_angle

                nscale =
                    nposy / 200
            in
            { ball | ball_posx = nposx, ball_posy = nposy, ball_radius = 1 + 8 * nscale, ball_state = Launched }

        else
            { ball | ball_state = Judge, shoot_pos = ( 80 - toFloat ball.ball_distance * cos ball.ball_angle, 90 - toFloat ball.ball_distance * sin ball.ball_angle ) }

    else
        ball


judgeShootposyout : Ball -> Bool
judgeShootposyout ball =
    if Tuple.second ball.shoot_pos >= 43 && Tuple.second ball.shoot_pos <= 90 then
        True

    else
        False


judgeShootposxout : Ball -> Bool
judgeShootposxout ball =
    if Tuple.first ball.shoot_pos <= 30 || Tuple.first ball.shoot_pos >= 130 then
        True

    else
        False


judgeballout : Ball -> Bool
judgeballout ball =
    if ball.ball_posy >= 100 || judgeShootposxout ball || judgeShootposyout ball then
        True

    else
        False


judgeballposy : Ball -> Bool
judgeballposy ball =
    if Tuple.second ball.shoot_pos < 43 && Tuple.second ball.shoot_pos > 2 then
        True

    else
        False


judgeballposxLeft1 : Ball -> Bool
judgeballposxLeft1 ball =
    if Tuple.first ball.shoot_pos > 30 && Tuple.first ball.shoot_pos < 45 then
        True

    else
        False


judgeballposxLeft2 : Ball -> Bool
judgeballposxLeft2 ball =
    if Tuple.first ball.shoot_pos <= 80 && Tuple.first ball.shoot_pos > 45 then
        True

    else
        False


judgeballposxRight1 : Ball -> Bool
judgeballposxRight1 ball =
    if Tuple.first ball.shoot_pos > 80 && Tuple.first ball.shoot_pos < 115 then
        True

    else
        False


judgeballposxRight2 : Ball -> Bool
judgeballposxRight2 ball =
    if Tuple.first ball.shoot_pos >= 115 && Tuple.first ball.shoot_pos < 130 then
        True

    else
        False


judgeballBounceState : BFourModel -> Bool
judgeballBounceState b4model =
    if b4model.game_status == Interval && b4model.result.round_result == RoundFail then
        True

    else
        False


bounceBall : BFourModel -> Ball -> Ball
bounceBall b4model ball =
    if
        b4model.game_status
            == Interval
            && judgeballout ball
    then
        { ball | ball_state = Over }

    else if
        judgeballBounceState b4model
            && judgeballposy ball
            && judgeballposxLeft1 ball
    then
        let
            nposx =
                ball.ball_posx + cos (2 * ball.ball_angle)

            nposy =
                ball.ball_posy + sin (2 * ball.ball_angle)

            nscale =
                nposy / 180
        in
        { ball | ball_posx = nposx, ball_posy = nposy, ball_radius = 1 + 8 * nscale }

    else if
        judgeballBounceState b4model
            && judgeballposy ball
            && judgeballposxLeft2 ball
    then
        let
            nposx =
                ball.ball_posx - sin (2 * ball.ball_angle)

            nposy =
                ball.ball_posy - cos (2 * ball.ball_angle)

            nscale =
                nposy / 150
        in
        { ball | ball_posx = nposx, ball_posy = nposy, ball_radius = 1 + 8 * nscale }

    else if
        judgeballBounceState b4model
            && judgeballposy ball
            && judgeballposxRight1 ball
    then
        let
            nposx =
                ball.ball_posx + sin (2 * (pi - ball.ball_angle))

            nposy =
                ball.ball_posy - cos (2 * (pi - ball.ball_angle))

            nscale =
                nposy / 150
        in
        { ball | ball_posx = nposx, ball_posy = nposy, ball_radius = 1 + 8 * nscale }

    else if
        judgeballBounceState b4model
            && judgeballposy ball
            && judgeballposxRight2 ball
    then
        let
            nposx =
                ball.ball_posx - cos (2 * (pi - ball.ball_angle))

            nposy =
                ball.ball_posy + sin (2 * (pi - ball.ball_angle))

            nscale =
                nposy / 180
        in
        { ball | ball_posx = nposx, ball_posy = nposy, ball_radius = 1 + 8 * nscale }

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


changeDistance : KeyInput -> Ball -> Ball
changeDistance dir ball =
    if (ball.ball_distance <= 20) && (dir == Down) then
        ball

    else if (ball.ball_angle >= 110) && (dir == Up) then
        ball

    else
        case ball.ball_state of
            NotLaunched ->
                case dir of
                    Down ->
                        let
                            ndistance =
                                ball.ball_distance - 1
                        in
                        { ball | ball_distance = ndistance }

                    Up ->
                        let
                            ndistance =
                                ball.ball_distance + 1
                        in
                        { ball | ball_distance = ndistance }

                    _ ->
                        ball

            _ ->
                ball

{-|
    This function is for the update of the game Break the loop by players pressing the keyboard.

-}

updateAdjust : UserMsg -> BFourModel -> ( BFourModel, Cmd Msg )
updateAdjust msg b4SubModel =
    let
        nb4Submodel =
            case msg of
                PressedKey ndir ->
                    if ndir /= Launch then
                        let
                            tmp_ball =
                                b4SubModel.ball

                            nball =
                                { tmp_ball | ball_dir = ndir }
                        in
                        prepareBall { b4SubModel | ball = nball } ndir

                    else if ndir == Launch then
                        { b4SubModel | game_status = Playing }

                    else
                        b4SubModel

                ReleasedKey _ ->
                    let
                        tmp_ball =
                            b4SubModel.ball

                        nball =
                            { tmp_ball | ball_dir = Idle }
                    in
                    prepareBall { b4SubModel | ball = nball } Idle

                _ ->
                    b4SubModel
    in
    ( nb4Submodel, Cmd.none )


prepareBall : BFourModel -> KeyInput -> BFourModel
prepareBall b4model dir =
    if b4model.game_status == Prepare then
        { b4model | ball = changeAngle dir b4model.ball |> changeDistance dir }

    else
        b4model


changeGameStatus : BFourModel -> BFourModel
changeGameStatus b4model =
    let
        ngame_status =
            case b4model.ball.ball_state of
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
    { b4model | game_status = ngame_status }


changeBFourModel : BFourModel -> BFourModel
changeBFourModel b4model =
    let
        nball =
            changeBall b4model b4model.ball |> bounceBall b4model

        tmp_b4model =
            { b4model | ball = nball }

        nb4model =
            judgeRoundVictory (changehole (changeGameStatus tmp_b4model)) b4model.result
    in
    nb4model

{-|
    This function is for the update of the game Break the loop by time.

-}

updateb4ByTime : Msg -> BFourModel -> BFourModel
updateb4ByTime msg b4SubModel =
    let
        nb4model =
            case msg of
                Tick elapsed ->
                    let
                        time_ =
                            b4SubModel.time_hole
                    in
                    case b4SubModel.game_status of
                        Prepare ->
                            { b4SubModel | time_hole = time_ + (elapsed / 1000), time = b4SubModel.time + elapsed / 1000 }
                                |> changeBFourModel

                        Playing ->
                            { b4SubModel | time_hole = time_ + (elapsed / 1000), time = b4SubModel.time + elapsed / 1000 }
                                |> changeBFourModel

                        JudgeResult ->
                            changeBFourModel b4SubModel

                        Interval ->
                            { b4SubModel | time_hole = time_ + (elapsed / 1000), time = b4SubModel.time + elapsed / 1000 }
                                |> changeBFourModel

                        _ ->
                            b4SubModel

                _ ->
                    b4SubModel
    in
    nb4model

{-|
    This function is for the update of the game Break the loop controlled by the player.

-}

updateb4Usermsg : BallFourUserMsg -> Model -> ( Model, Cmd Msg )
updateb4Usermsg msg model =
    let
        b4SubModel =
            model.b4model

        pt =
            b4SubModel.pattern
    in
    case msg of
        Start_prepare ->
            ( { model | b4model = { b4SubModel | game_status = Prepare } }, Cmd.none )

        B4ChoosePattern pattern ->
            let
                npattern =
                    case pattern of
                        2 ->
                            Pattern2

                        _ ->
                            Pattern1
            in
            ( { model | b4model = { b4SubModel | pattern = npattern } }, Cmd.none )

        Start_playing ->
            ( { model | b4model = { b4SubModel | game_status = Playing } }, Cmd.none )

        Pause_prepare ->
            ( { model | b4model = { b4SubModel | game_status = Paused_prepare } }, Cmd.none )

        Pause_playing ->
            ( { model | b4model = { b4SubModel | game_status = Paused_playing } }, Cmd.none )

        EnterBallFour ->
            case b4SubModel.te of
                False ->
                    ( { model | b4model = { b4SubModel | game_status = Prepare } }, Cmd.none )

                True ->
                    ( minusApt pt model, Cmd.none )

        NextBallFour ->
            updateNextBallFour model

        B4Game2Plot ->
            updatePlotBallFour model

        _ ->
            ( model, Cmd.none )


updatePlotBallFour : Model -> ( Model, Cmd Msg )
updatePlotBallFour model =
    let
        result =
            model.b4model.result.victory_or_fail

        pt =
            model.b4model.pattern

        { page, item } =
            model.b4model.identity

        ( npage, nmodel ) =
            case page of
                PersonPage Weaver P2 A ->
                    case result of
                        GameVictory ->
                            let
                                wmodel =
                                    model.weaverModel

                                nwmodel =
                                    { wmodel | gamestatusb4 = GameStatus Pass BallFour }
                            in
                            ( PersonPage Weaver P2 B, { model | weaverModel = nwmodel } )

                        GameFail ->
                            let
                                wmodel =
                                    model.weaverModel

                                nwmodel =
                                    { wmodel | gamestatusb4 = GameStatus Fail BallFour }
                            in
                            ( PersonPage Weaver P2 C, { model | weaverModel = nwmodel } )

                        _ ->
                            ( BuildingPage Church, model )

                PersonPage Weaver P3 A ->
                    case model.b4model.game_status of
                        Intro _ ->
                            ( BuildingPage Church, { model | b4model = initBFourModel_P1 page Apple False } )

                        ActNotEnough ->
                            ( BuildingPage Church, { model | b4model = initBFourModel_P2 page Apple False } )

                        _ ->
                            if result == GameVictory then
                                ( GamePage BallFour, { model | b4model = initBFourModel_P1 page Apple True } |> addGSpt pt )

                            else
                                ( GamePage BallFour, { model | b4model = initBFourModel_P1 page Apple True } )

                _ ->
                    ( page, model )
    in
    ( { nmodel | currentPage = npage }, Cmd.none )


updateNextBallFour : Model -> ( Model, Cmd Msg )
updateNextBallFour model =
    let
        b4SubModel =
            model.b4model

        nround =
            b4SubModel.round + 1

        nwin =
            b4SubModel.result.win_num

        nlose =
            b4SubModel.result.lose_num

        tmp_victory =
            b4SubModel.result

        nvictory =
            { tmp_victory | win_num = nwin, lose_num = nlose }

        { page, item } =
            model.b4model.identity

        te =
            b4SubModel.te

        initb4model =
          case b4SubModel.pattern of
            Pattern1 ->
               initBFourModel_P1 page item te
            Pattern2 ->
              initBFourModel_P2 page item te
    in
    ( { model | b4model = { initb4model | round = nround, result = nvictory, game_status = Prepare } }, Cmd.none )


minusApt : Pattern -> Model -> Model
minusApt pattern model =
    let
        pts =
            case pattern of
                Pattern1 ->
                    1

                Pattern2 ->
                    2

        b4model =
            model.b4model
    in
    if model.actionpoints - 1 < 0 then
        { model | b4model = { b4model | game_status = ActNotEnough } }

    else if model.actionpoints - pts < 0 then
        { model | b4model = { b4model | game_status = Intro InvalidPattern } }

    else
        { model | actionpoints = model.actionpoints - pts, b4model = { b4model | game_status = Prepare } }


addGSpt : Pattern -> Model -> Model
addGSpt pattern model =
    let
        pts =
            case pattern of
                Pattern1 ->
                    30

                Pattern2 ->
                    40
    in
    { model | gsPoint = model.gsPoint + pts }



-- Win or Fail


judgeHitTopLeft : BFourModel -> Bool
judgeHitTopLeft b4model =
    if b4model.ball.ball_posx >= b4model.hole.hole_posx && b4model.ball.ball_posy >= b4model.hole.hole_posy then
        True

    else
        False


judgeHitTopRight : BFourModel -> Bool
judgeHitTopRight b4model =
    if b4model.ball.ball_posx + b4model.ball.ball_radius * 2 <= b4model.hole.hole_posx + b4model.hole.hole_radius * 3 then
        True

    else
        False


judgeHitBottomLeft : BFourModel -> Bool
judgeHitBottomLeft b4model =
    if b4model.ball.ball_posy + b4model.ball.ball_radius * 2 <= b4model.hole.hole_posy + b4model.hole.hole_radius * 3 then
        True

    else
        False


judgeRoundVictory : BFourModel -> BFourResult -> BFourModel
judgeRoundVictory b4model victory_status =
    let
        ball =
            b4model.ball

        ( nresult, judgeover ) =
            case b4model.game_status of
                Interval ->
                    ( b4model.result, True )

                RoundPage ->
                    ( b4model.result, True )

                End ->
                    ( b4model.result, True )

                JudgeResult ->
                    if
                        judgeHitBottomLeft b4model && judgeHitTopLeft b4model && judgeHitTopRight b4model
                    then
                        ( { victory_status | win_num = victory_status.win_num + 1, round_result = RoundVictory }, True )

                    else
                        ( { victory_status | lose_num = victory_status.lose_num + 1, round_result = RoundFail }, True )

                _ ->
                    ( victory_status, False )

        nball =
            case judgeover of
                True ->
                    case b4model.game_status of
                        JudgeResult ->
                            { ball | ball_state = Bounce }

                        _ ->
                            ball

                False ->
                    ball

        ngame_status =
            case nball.ball_state of
                Bounce ->
                    Interval

                _ ->
                    b4model.game_status
    in
    { b4model | ball = nball, result = nresult, game_status = ngame_status }

{-|
    This function is for the update of the game Break the loop by judging whether the player wins or loses in the game.

-}

checkVictoryBFour : BFourModel -> BFourModel
checkVictoryBFour b4model =
    let
        nb4model =
            if b4model.result.win_num >= 1 then
                let
                    tmp_victory =
                        b4model.result

                    nvictory =
                        { tmp_victory | victory_or_fail = GameVictory }
                in
                { b4model | result = nvictory, game_status = End }

            else if b4model.result.lose_num >= 5 then
                let
                    tmp_victory =
                        b4model.result

                    nvictory =
                        { tmp_victory | victory_or_fail = GameFail }
                in
                { b4model | result = nvictory, game_status = End }

            else if b4model.round > 5 then
                let
                    tmp_victory =
                        b4model.result

                    nvictory =
                        { tmp_victory | victory_or_fail = GameFail }
                in
                { b4model | result = nvictory, game_status = End }

            else
                b4model
    in
    nb4model


{-|
    This function is for the update of initializing the game Break the loop under different situations.

-}

b4Init : Model -> Model
b4Init model =
    let
        page =
            model.currentPage

        ( npage, nb4model ) =
            case page of
                PersonPage Weaver P2 A ->
                    case model.weaverModel.gamestatusb4.pOf of
                        Before ->
                            ( GamePage BallFour, initBFourModel_P1 page Apple False )

                        Pass ->
                            let
                                initBFourVictory : BFourResult
                                initBFourVictory =
                                    BFourResult 0 0 GameVictory GameVictory

                                initBallOver : Ball
                                initBallOver =
                                    Ball 0 80 90 8 1 GameOver Left 1 ( 0, 0 )

                                identity =
                                    GameIdentity page Apple

                                initb4model =
                                    BFourModel initBallOver initHole (Intro ValidPattern) 0 0 initBFourVictory 1 identity Pattern1 False
                            in
                            ( GamePage BallFour, initb4model )

                        Fail ->
                            let
                                initBFourVictory : BFourResult
                                initBFourVictory =
                                    BFourResult 0 0 GameFail GameFail

                                initBallOver : Ball
                                initBallOver =
                                    Ball 0 80 90 8 1 GameOver Left 1 ( 0, 0 )

                                identity =
                                    GameIdentity page Apple

                                initb4model =
                                    BFourModel initBallOver initHole (Intro ValidPattern) 0 0 initBFourVictory 1 identity Pattern1 False
                            in
                            ( GamePage BallFour, initb4model )

                PersonPage Weaver P3 A ->
                    ( GamePage BallFour, initBFourModel_P1 page Apple True )

                HintPage ->
                    ( GamePage BallFour, initBFourModel_P1 page Apple False )

                _ ->
                    ( page, model.b4model )
    in
    { model | b4model = nb4model, currentPage = npage }
