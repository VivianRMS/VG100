module Update exposing (update)

{- Here include all our updating functions -}

import Background.Ball as Ball
import Background.Bricks as Bricks
import Background.Paddle as Paddle
import Message exposing (KeyInput(..), Msg(..))
import Model exposing (CurrentState(..), Model, WinOrFailure(..), init)
import Port exposing (playSFX, sendChange)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
        |> updateVF
        |> updateScene msg
        |> updateBall msg
        |> updateGrid
        |> updateCurrentState msg

-- update grid with falling bricks

updateGrid : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateGrid ( model, cmd ) =
    ( newGrid model, cmd )


newGrid :
    Model
    -> Model --filter those broken cells
newGrid model =
    let
        ngrid =
            Bricks.dropBroken model.bricks
    in
    { model | bricks = ngrid }

-- update the motion of paddle with received keyboard messages

movePaddle : KeyInput -> Paddle.Paddle -> Paddle.Paddle
movePaddle dir paddle =
    if (paddle.xPosition <= 0.5) && (dir == Left) then
        Paddle.Paddle 0.5 paddle.scale paddle.timerScale

    else if (paddle.xPosition >= 100.0 - 10.0 * paddle.scale) && (dir == Right) then
        --Adjust the boarder with respect to the scale of the paddle
        Paddle.Paddle (100.0 - 10.0 * paddle.scale) paddle.scale paddle.timerScale

    else
        case dir of
            Left ->
                let
                    newX =
                        paddle.xPosition - 0.6
                in
                Paddle.Paddle newX paddle.scale paddle.timerScale

            Right ->
                let
                    newX =
                        paddle.xPosition + 0.6
                in
                Paddle.Paddle newX paddle.scale paddle.timerScale

            _ ->
                paddle

-- update scenes on the browser

updateScene :
    Msg
    -> ( Model, Cmd Msg )
    -> ( Model, Cmd Msg )
updateScene msg ( model, cmd ) =
    case msg of
        PressedKey newDir ->
            let
                tempKeyState =
                    model.key

                tempGameState =
                    model.state

                ( newState, newGameState, nCmd ) =
                    case newDir of
                        Left ->
                            ( ( True, Tuple.second tempKeyState ), tempGameState, cmd )

                        Right ->
                            ( ( Tuple.first tempKeyState, True ), tempGameState, cmd )

                        Pausing ->
                            ( tempKeyState, Paused, cmd )

                        Resume ->
                            ( tempKeyState, Playing, cmd )

                        Up ->
                            ( tempKeyState, tempGameState, Port.changeVolume 0.1 )

                        Down ->
                            ( tempKeyState, tempGameState, Port.changeVolume -0.1 )

                        ChangeMusic ->
                            ( tempKeyState, tempGameState, Port.sendChange () )

                        Idle ->
                            ( tempKeyState, tempGameState, cmd )
            in
            ( { model | key = newState, state = newGameState }, nCmd )

        ReleasedKey newDir ->
            let
                tempKeyState =
                    model.key

                newState =
                    case newDir of
                        Left ->
                            ( False, Tuple.second tempKeyState )

                        Right ->
                            ( Tuple.first tempKeyState, False )

                        _ ->
                            tempKeyState
            in
            ( { model | key = newState }, cmd )

        Tick _ ->
            ( newScene model, cmd )

        _ ->
            ( model, cmd )


newScene : Model -> Model
newScene model =
    if model.state == Playing then
        let
            dir =
                if model.key == ( True, True ) then
                    Idle

                else if model.key == ( False, True ) then
                    Right

                else if model.key == ( True, False ) then
                    Left

                else
                    Idle

            newBricks =
                Bricks.bricksFall model.bricks model.level
        in
        { model | paddle = movePaddle dir model.paddle, bricks = newBricks }

    else
        model

-- update update ball's automatic movement over time 

updateBall : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateBall msg ( model, cmd ) =
    case msg of
        Tick _ ->
            case model.state of
                Playing ->
                    let
                        paddle =
                            Paddle.moveTimerPaddle model.paddle

                        nModel =
                            { model
                                | balls =
                                    List.map Ball.moveBall model.balls
                                        |> Ball.moveTimerBall
                            }

                        ( ( nBalls, nBricks, nPaddle ), brickCmd ) =
                            Ball.ballsCollideAllBricks 1.0 nModel.balls nModel.bricks [] [] Cmd.none

                        ( tempBalls, paddleCmd ) =
                            List.unzip (List.map (Ball.ballTouchPaddle model.paddle) nBalls)

                        nnBalls =
                            List.map Ball.ballTouchWall tempBalls
                                |> Ball.ballsCollideBalls
                                |> List.filter (\x -> x.ballState == Ball.Alive)

                        nnPaddle =
                            if nPaddle == 1.0 then
                                paddle

                            else
                                let
                                    nscale =
                                        if nPaddle * paddle.scale > 4.0 then
                                            4.0

                                        else
                                            nPaddle * paddle.scale

                                    scalertime =
                                        case paddle.timerScale of
                                            Paddle.Original ->
                                                Paddle.Scaling 1.0

                                            _ ->
                                                paddle.timerScale
                                in
                                { paddle | scale = nscale, timerScale = scalertime }
                    in
                    ( { model | balls = nnBalls, bricks = nBricks, paddle = nnPaddle }, Cmd.batch ([ brickCmd, cmd ] ++ paddleCmd) )

                _ ->
                    ( model, cmd )

        _ ->
            ( model, cmd )

--update current game status over time and when receiving messages

updateCurrentState : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateCurrentState msg ( model, cmd ) =
    case msg of
        Tick elapsed ->
            case model.state of
                PreAnimation ->
                    if model.time > 3 then
                        ( { model | time = model.time + elapsed / 1000, state = BeforeWholeGame }, cmd )

                    else
                        ( { model | time = model.time + elapsed / 1000 }, cmd )

                _ ->
                    ( { model | time = model.time + elapsed / 1000 }, cmd )

        Next ->
            case model.state of
                PreAnimation ->
                    ( { model | state = BeforeWholeGame }
                    , cmd
                    )

                BeforeWholeGame ->
                    ( { model | state = RuleExplanation }
                    , cmd
                    )

                RuleExplanation ->
                    ( { model | state = BeforeStart }
                    , cmd
                    )

                _ ->
                    ( { model | state = Stopped }
                    , cmd
                    )

        Start ->
            ( { model | state = Playing }
            , cmd
            )

        Pause ->
            ( { model | state = Paused }
            , cmd
            )

        Continue ->
            ( { model | state = Playing }
            , cmd
            )

        Pass _ ->
            let
                preLevel =
                    model.level

                ( nmodel, cmdd ) =
                    init (preLevel + 1)
            in
            ( { nmodel | state = BeforeStart }
            , cmdd
            )

        Replay ->
            init 1

        RandomSeed seed ->
            case model.bricks of
                [] ->
                    let
                        ( newBrick, _ ) =
                            Bricks.randomBricks model.level seed
                    in
                    ( { model | bricks = newBrick }
                    , cmd
                    )

                _ ->
                    ( model, cmd )

        _ ->
            ( model, cmd )

-- to judge if all the balls fall out of the game screen and died

checkBallsDead : List Ball.Ball -> Bool
checkBallsDead balls =
    let
        checkBallLife : Ball.Ball -> Bool
        checkBallLife ball =
            if ball.ballState == Ball.Alive then
                True

            else
                False
    in
    if List.filter checkBallLife balls == [] then
        True

    else
        False

-- to judge if bricks falling to the bottom of game screen and died

checkBricksDead : List Bricks.Bricks -> Bool
checkBricksDead bricks =
    let
        sortedbricks =
            List.reverse (List.sortBy .yPosition bricks)

        deepest =
            case List.head sortedbricks of
                Just lowest ->
                    lowest.yPosition

                Nothing ->
                    90.0
    in
    if deepest > 85.0 then
        True

    else
        False

-- to judge if the game is over

checkDeath : Model -> Bool
checkDeath model =
    let
        balls =
            model.balls

        bricks =
            model.bricks
    in
    if checkBallsDead balls || checkBricksDead bricks then
        True

    else
        False


countElements : List Int -> Int -> Int
countElements list num =
    let
        numint =
            List.partition (\x -> x == num) list
    in
    List.length (Tuple.first numint)


checkVictory : Model -> Bool
checkVictory model =
    let
        bricks =
            model.bricks

        allX =
            List.map ((*) 10) (List.range 1 8)

        allBricksX =
            List.map .xPosition bricks

        sameXposition : List Float -> Int -> Int
        sameXposition allBricksx testx =
            List.filter (\x -> round x == testx) allBricksx
                |> List.length

        xCount =
            List.map (sameXposition allBricksX) allX
    in
    case model.level of
        1 ->
            if List.member 0 xCount then
                True

            else
                False

        2 ->
            if countElements xCount 0 >= 2 then
                True

            else
                False

        _ ->
            if List.member 0 xCount then
                True

            else
                False

-- update the information of model when winning or losing the game

deathOrVictoryModel : Model -> Model
deathOrVictoryModel model =
    if not (checkDeath model) && checkVictory model then
        { model | winOrFailure = Victory }

    else if not (checkVictory model) && checkDeath model then
        { model | winOrFailure = Failure }

    else
        model


updateVF : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateVF ( model, cmd ) =
    case model.winOrFailure of
        Undetermined ->
            ( deathOrVictoryModel model, cmd )

        Victory ->
            ( model, playSFX "GameOver" )

        Failure ->
            ( model, Cmd.batch [ playSFX "Dead", sendChange () ] )

