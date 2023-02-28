module Background.Ball exposing (Ball, BallScale(..), BallState(..), ballTouchPaddle, ballTouchWall, ballsCollideAllBricks, ballsCollideBalls, initBalls, makeBalls, moveBall, moveTimerBall)

{- The module that contains functions and types for the balls. -}

import Background.Bricks as Bricks
import Background.Paddle exposing (Paddle, ScaleTime(..))
import Debug exposing (toString)
import Html exposing (Html)
import Html.Attributes exposing (src, style)
import Message exposing (..)
import Port exposing (playSFX)


type
    Collision
    -- whether or which part the ball strikes the paddle
    = Middle
    | LeftPad
    | RightPad
    | Miss
    | JustPaddled


type
    BallState
    -- whether ball has fallen below paddle
    = Alive
    | Dead


type
    BallScale
    --zoom in or zoom out the ball
    = ZoomIn
    | ZoomOut


maximumScaleTime : Float



--the ball can only zoom in for a limited time, after that it will return to original size


maximumScaleTime =
    400.0


type alias Ball =
    { pos : ( Float, Float )
    , radius : Float
    , scale : Float
    , angle : Float
    , speed : Float
    , ballState : BallState
    , timerScale : ScaleTime
    , paddled : Bool
    , balled : Bool
    }


initBall :
    ( Float, Float )
    -> Float
    -> Ball --init one ball by defining its position and angle of motion
initBall a b =
    { pos = a
    , radius = 1
    , scale = 1.0
    , angle = pi / b
    , speed = 1.0
    , ballState = Alive
    , timerScale = Original
    , paddled = False
    , balled = False
    }


initBalls : List Ball



--a list of balls which contains only one ball at first


initBalls =
    [ initBall ( 6.0, 79.0 ) 3.0
    ]


makeBalls :
    List Ball
    -> List (Html msg) --draw a list of balls
makeBalls balls =
    List.map makeBall balls


makeBall :
    Ball
    -> Html msg --draw one ball
makeBall ball =
    Html.img
        [ style "position" "absolute"
        , style "left" (toString (Tuple.first ball.pos - ball.radius * ball.scale) ++ "%")
        , style "top" (toString (Tuple.second ball.pos - ball.radius * ball.scale) ++ "%")
        , style "width" (toString (ball.radius * 2 * ball.scale) ++ "%")
        , style "height" "auto"
        , src "assets/images/ball.png"
        ]
        []


moveBall :
    Ball
    -> Ball --move ball along its angle of motion
moveBall ball =
    let
        x =
            Tuple.first ball.pos + ball.speed * cos ball.angle / 3

        y =
            Tuple.second ball.pos - ball.speed * sin ball.angle / 3

        npos =
            Tuple.pair x y
    in
    { ball | pos = npos }


collide :
    Ball
    -> Bricks.Bricks
    -> ( ( ( Ball, List Ball ), Bricks.Bricks, Float ), Cmd msg ) --ball collide with one brick return which side the ball collides and the broken brick
collide ball bricks =
    let
        ( ( ballX, ballY ), ( ballLeft, ballRight ), ballWidth ) =
            ballInfo ball

        ( ( bricksLeft, bricksRight ), ( bricksUp, bricksDown ) ) =
            bricksInfo bricks

        ( newState, brickSFX ) =
            --choose correct music to play depending on the rock type
            case bricks.state of
                Bricks.Normal ->
                    case bricks.brickType_ of
                        Bricks.Magma ->
                            ( Bricks.Broken, Port.playSFX "magma" )

                        Bricks.Rock ->
                            ( Bricks.Broken, Port.playSFX "rock" )

                Bricks.Fortified ->
                    ( Bricks.Normal, Port.playSFX "Forted" )

                _ ->
                    ( bricks.state, Cmd.none )

        ( newScaleBall, ballSFX ) =
            --choose the correct music to play depending on the size of ball and adjust ball's scale according to the brick type
            case bricks.specialItem_ of
                Bricks.BigBall ->
                    if collideOrNot then
                        ( scalingBall ZoomIn ball, Port.playSFX "bigBall" )

                    else
                        ( scalingBall ZoomIn ball, Cmd.none )

                _ ->
                    ( ball, Cmd.none )

        collideOrNot =
            --judge whether the ball collides with the brick
            if ballX >= bricksLeft - ballWidth && ballX <= bricksRight + ballWidth && ballY >= bricksUp - ballWidth && ballY <= bricksDown + ballWidth then
                True

            else
                False

        changedirection =
            --get which side the ball is hit
            changeDirection collideOrNot ball.timerScale ( ballLeft, ballRight, ballY ) ( bricksRight, bricksLeft, bricksUp )

        newDirectionBall =
            --change ball's angle if it strikes the brick and if it is zoomed in by the brick change the zoomed in ball's angle
            case changedirection of
                Nothing ->
                    ball

                dir ->
                    changeBallDir newScaleBall dir

        ( newPaddleScale, paddleSFX ) =
            --choose the correct music to play depending on the size of paddle
            if collideOrNot then
                case bricks.specialItem_ of
                    Bricks.BigPaddle ->
                        ( 2.0, Port.playSFX "bigPaddle" )

                    _ ->
                        ( 1.0, Cmd.none )

            else
                ( 1.0, Cmd.none )

        ( anotherBall, yetBallSFX ) =
            ----choose the correct music to play depending on whether new balls are generated and prepare new balls if the brick is of the type
            if collideOrNot then
                case bricks.specialItem_ of
                    Bricks.AnotherBall ->
                        ( [ initBall ( (bricksLeft + bricksRight) / 2.0, (bricksUp + bricksDown) / 2.0 ) (2 * pi - newDirectionBall.angle) ], Port.playSFX "bigBall" )

                    _ ->
                        ( [], Cmd.none )

            else
                ( [], Cmd.none )

        ( newBricks, trueBrickSFX ) =
            --add or not add new balls depending on whether collision happens
            if not collideOrNot then
                ( bricks, Cmd.none )

            else
                ( { bricks | state = newState }, brickSFX )
    in
    ( ( ( newDirectionBall, anotherBall ), newBricks, newPaddleScale ), Cmd.batch [ trueBrickSFX, ballSFX, paddleSFX, yetBallSFX ] )


ballInfo :
    Ball
    -> ( ( Float, Float ), ( Float, Float ), Float ) --fetch info of a ball
ballInfo ball =
    let
        ballX =
            Tuple.first ball.pos

        ballY =
            Tuple.second ball.pos

        ballWidth =
            ball.radius * ball.scale

        ballLeft =
            ballX - ballWidth

        ballRight =
            ballX + ballWidth
    in
    ( ( ballX, ballY ), ( ballLeft, ballRight ), ballWidth )


bricksInfo :
    Bricks.Bricks
    -> ( ( Float, Float ), ( Float, Float ) ) --fetch info of a bricks
bricksInfo bricks =
    let
        bricksX =
            bricks.xPosition

        bricksY =
            bricks.yPosition

        bricksLeft =
            bricksX

        bricksRight =
            bricksLeft + 9.5

        bricksUp =
            bricksY

        bricksDown =
            bricksUp + 6.0
    in
    ( ( bricksLeft, bricksRight ), ( bricksUp, bricksDown ) )


changeDirection :
    Bool
    -> ScaleTime
    -> ( Float, Float, Float )
    -> ( Float, Float, Float )
    -> Maybe KeyInput --if the ball collides with the brick, judge which side the ball is hit. If the ball is an invincible big ball, don't change its angle
changeDirection collideOrNot scaleTime ( ballLeft, ballRight, ballY ) ( bricksRight, bricksLeft, bricksUp ) =
    case scaleTime of
        Original ->
            if collideOrNot then
                if ballLeft >= bricksRight - 1 then
                    Just Left

                else if ballRight <= bricksLeft + 1 then
                    Just Right

                else if ballY <= bricksUp - 4 then
                    Just Down

                else if ballY > bricksUp - 4 then
                    Just Up

                else
                    Nothing

            else
                Nothing

        Scaling past ->
            if modBy 100 (round past) <= 70 && modBy 100 (round past) >= 60 then
                if collideOrNot then
                    if ballLeft >= bricksRight then
                        Just Left

                    else if ballRight <= bricksLeft + 1 then
                        Just Right

                    else if ballY <= bricksUp - 4 then
                        Just Down

                    else if ballY > bricksUp - 4 then
                        Just Up

                    else
                        Nothing

                else
                    Nothing

            else
                Nothing


changeBallDir :
    Ball
    -> Maybe KeyInput
    -> Ball -- change ball direction/angle based on which side of the ball collides
changeBallDir ball dir =
    case dir of
        Just Left ->
            let
                nAngle =
                    if ball.angle <= pi then
                        pi - ball.angle

                    else
                        3 * pi - ball.angle
            in
            { ball | angle = angleAdjust nAngle }

        Just Right ->
            let
                nAngle =
                    if ball.angle <= pi / 2 then
                        pi - ball.angle

                    else
                        3 * pi - ball.angle
            in
            { ball | angle = angleAdjust nAngle }

        Just Up ->
            let
                nAngle =
                    2 * pi - ball.angle
            in
            { ball | angle = angleAdjust nAngle }

        Just Down ->
            let
                nAngle =
                    if ball.angle >= pi / 2 then
                        2 * pi - ball.angle

                    else
                        2 * pi - 2 * ball.angle
            in
            { ball | angle = angleAdjust nAngle }

        _ ->
            ball


angleAdjust :
    Float
    -> Float --adjust angle to avoid either very flat or almost vertical angles from happening
angleAdjust tempAngle =
    if tempAngle >= 0.0 && tempAngle <= 10.0 * (pi / 180) then
        tempAngle + pi / 6

    else if tempAngle >= pi && tempAngle <= 190.0 * (pi / 180) then
        tempAngle + pi / 6

    else if tempAngle <= pi && tempAngle >= 170.0 * (pi / 180) then
        tempAngle - pi / 6

    else if tempAngle <= 2 * pi && tempAngle >= 350.0 * (pi / 180) then
        tempAngle - pi / 6

    else if tempAngle >= 80.0 * (pi / 180) && tempAngle <= pi / 2 then
        tempAngle - pi / 6

    else if tempAngle >= pi / 2 && tempAngle <= 100.0 * (pi / 180) then
        tempAngle + pi / 6

    else if tempAngle <= 3 * pi / 2 && tempAngle >= 3 * pi / 2 - 10.0 * (pi / 180) then
        tempAngle - pi / 6

    else if tempAngle >= 3 * pi / 2 && tempAngle <= 3 * pi / 2 + 10.0 * (pi / 180) then
        tempAngle + pi / 6

    else
        tempAngle


oneBallCollideAllBricks :
    --make a ball collide with all bricks and get a list of bricks with new states and the ball with new states and a list of probably newly generated balls
    Ball
    -> List Bricks.Bricks
    -> List Bricks.Bricks
    -> List Ball
    -> List Ball
    -> Float
    -> Cmd msg
    -> ( ( ( Ball, List Ball ), List Bricks.Bricks, Float ), Cmd msg ) --each time test all bricks to see whether collision happens
oneBallCollideAllBricks ball bricks nbricks nballs nanotherballs x cmd =
    case bricks of
        cell :: rest ->
            let
                ( ( ( nball, nanother ), ncell, nPaddleScale ), collideCmd ) =
                    collide ball cell

                nnbricks =
                    List.append nbricks [ ncell ]

                nnballs =
                    List.append nballs [ nball ]

                nnanotherballs =
                    List.append nanotherballs nanother
            in
            oneBallCollideAllBricks nball rest nnbricks nnballs nnanotherballs (x * nPaddleScale) (Cmd.batch [ cmd, collideCmd ])

        [] ->
            let
                originalball =
                    case List.head nballs of
                        Nothing ->
                            initBall ( 6.0, 79.0 ) 3.0

                        Just origin ->
                            origin

                finalball =
                    List.filter (\a -> a /= originalball) nballs
                        |> List.head

                finalBall =
                    case finalball of
                        Nothing ->
                            originalball

                        Just final ->
                            final
            in
            ( ( ( finalBall, nanotherballs ), nbricks, x ), cmd )


ballsCollideAllBricks :
    --make all balls collide all bricks and get their new states and a list of probably newly generated balls
    Float
    -> List Ball
    -> List Bricks.Bricks
    -> List Ball
    -> List Ball
    -> Cmd msg
    -> ( ( List Ball, List Bricks.Bricks, Float ), Cmd msg )
ballsCollideAllBricks paddle balls bricks nballs nanotherballs cmd =
    case balls of
        ball :: rest ->
            let
                ( ( ( nball, nanother ), nbricks, npaddle ), newCmd ) =
                    oneBallCollideAllBricks ball bricks [] [ ball ] [] 1.0 cmd

                nnballs =
                    List.append nballs [ nball ]

                nnanotherballs =
                    List.append nanotherballs nanother
            in
            ballsCollideAllBricks (npaddle * paddle) rest nbricks nnballs nnanotherballs (Cmd.batch [ cmd, newCmd ])

        [] ->
            ( ( List.append nballs nanotherballs, bricks, paddle ), cmd )


ballTouchWall :
    Ball
    -> Ball --check whether ball touches boundaries and change their angles and if the ball drops beyond boundary, change its status to dead
ballTouchWall ball =
    if Tuple.second ball.pos >= 97.5 - ball.radius * ball.scale then
        { ball | ballState = Dead }

    else if Tuple.second ball.pos <= 2.5 + ball.radius * ball.scale then
        changeBallDir ball (Just Up)

    else if Tuple.first ball.pos <= 3.5 + ball.radius * ball.scale then
        changeBallDir ball (Just Left)

    else if Tuple.first ball.pos >= 96.5 - ball.radius * ball.scale then
        changeBallDir ball (Just Right)

    else
        ball


scalingBall :
    BallScale
    -> Ball
    -> Ball --zoom in or out ball scale
scalingBall zoom ball =
    case zoom of
        ZoomIn ->
            if ball.scale > 3.0 then
                --At most zooming in to 3 times
                ball

            else if ball.scale == 1.0 then
                --zoom in the ball and speed it up if it is of original scale
                { ball | scale = ball.scale + 1.0, timerScale = Scaling 1.0, speed = 1.5 }

            else
                --zoom in the ball if it is already zoomed in before
                { ball | scale = ball.scale + 1.0 }

        ZoomOut ->
            --recover ball's original scale and set speed and timer of scaling to zero/ Original
            { ball | scale = 1.0, timerScale = Original, speed = 1.0 }



--After limited time of amplifying, the scale immediately returns to 1.0


moveTimerBall :
    List Ball
    -> List Ball --if the ball is scaling move timer,
moveTimerBall balls =
    let
        moveTimer : Ball -> Ball
        moveTimer ball =
            case ball.timerScale of
                Original ->
                    --if the ball is not scaling, do nothing
                    ball

                Scaling past ->
                    --if the ball is scaling
                    if past >= maximumScaleTime then
                        --if the scaling ball has used up maximum scaling time, make it return to normal size
                        scalingBall ZoomOut ball

                    else
                        --else move timer
                        { ball | timerScale = Scaling (past + 1.0) }
    in
    List.map moveTimer balls


ballCollideBall :
    Ball
    -> Ball
    -> Ball --check whether A ball collides with B ball, if so, change A ball's angle of motion
ballCollideBall bball aball =
    let
        ( ( aballX, aballY ), ( left_aball, right_aball ), aballWidth ) =
            ballInfo aball

        ( ( bballX, bballY ), ( left_bball, right_bball ), bballWidth ) =
            ballInfo bball

        centerDistance =
            sqrt ((aballX - bballX) ^ 2 + (aballY - bballY) ^ 2)

        validDistance =
            aballWidth + bballWidth
    in
    if centerDistance <= validDistance then
        if left_aball >= right_bball - 1 / 6 then
            changeBallDir aball (Just Left)

        else if right_aball <= left_bball + 1 / 6 then
            changeBallDir aball (Just Right)

        else if aballY < bballY then
            changeBallDir aball (Just Down)

        else if aballY > bballY then
            changeBallDir aball (Just Up)

        else
            aball

    else
        aball


ballCollideBalls :
    List Ball
    -> Ball
    -> Ball --a ball collides with a list of balls, then get the accumulative effect the list of balls have exerted on the ball
ballCollideBalls balls ball =
    List.foldl ballCollideBall ball balls


ballsCollideBalls :
    List Ball
    -> List Ball --a list of balls collide with each other, get balls of new states
ballsCollideBalls balls =
    List.map (ballCollideBalls balls) balls


ballHitPaddle :
    Paddle
    -> Ball
    -> Collision --check whether ball hit paddle and do corresponding changes
ballHitPaddle { xPosition, scale } ball =
    let
        ( ( ballX, ballY ), ( ballLeft, ballRight ), ballWidth ) =
            ballInfo ball

        paddleLeft =
            xPosition

        paddleWidth =
            10.0 * scale

        paddleRight =
            paddleLeft + paddleWidth

        paddleUp : Float
        paddleUp =
            87.0

        paddleDown : Float
        paddleDown =
            paddleUp + 1.5

        hitOrNot =
            --check whether the ball hits the paddle
            if ballX >= paddleLeft - ballWidth && ballX <= paddleRight + ballWidth && ballY >= paddleUp - ballWidth && ballY <= paddleDown then
                True

            else
                False
    in
    if not hitOrNot then
        --if not, the ball Misses the paddle
        Miss

    else if ball.paddled then
        --if the ball is hit, yet it is recorded that the ball has just been paddled, then the ball JustPaddled
        JustPaddled
        --if the ball is newly hit, check whether the ball is hit on its left side, or right side, or the middle part

    else if ballLeft >= paddleRight then
        RightPad

    else if ballRight <= paddleLeft then
        LeftPad

    else
        Middle


ballTouchPaddle :
    Paddle
    -> Ball
    -> ( Ball, Cmd msg ) --change ball direction depending on whether or which part the ball is hit and play corresponding music
ballTouchPaddle paddle ball =
    case ballHitPaddle paddle ball of
        Middle ->
            let
                nball =
                    changeBallDir ball (Just Down)
            in
            ( { nball | paddled = True }, playSFX "paddleHit" )

        LeftPad ->
            let
                nball =
                    changeBallDir ball (Just Right)
            in
            ( { nball | paddled = True }, playSFX "paddleHit" )

        RightPad ->
            let
                nball =
                    changeBallDir ball (Just Left)
            in
            ( { nball | paddled = True }, playSFX "paddleHit" )

        Miss ->
            ( { ball | paddled = False }, Cmd.none )

        JustPaddled ->
            ( ball, Cmd.none )
