module Ball_One.Update exposing (b1Init, updateAdjustBall, updateB_OneUsrMsg, updateb1ByTime, updateb1ModelMsg)
{-| This module controls the update for the game Company and love.

# Ball1 Update Function
@docs b1Init, updateAdjustBall, updateB_OneUsrMsg, updateb1ByTime, updateb1ModelMsg

-}

import Ball_One.Init exposing (initB_OneSubmodel, initRandomGoal)
import Ball_One.Model exposing (PatternValid(..),B_OneSubmodel, Ball, BallState(..), Dir(..), Goal, Path(..), Point, State(..))
import Ball_One.Msg exposing (BallOneUserMsg(..), ModelMsgBallOne(..))
import Msg exposing (Msg(..), UserMsg(..), ModelMsg(..), KeyInput(..))
import Model exposing (Model)
import Basis exposing (TEState(..),Item(..),GameKind(..), Phase(..),Building(..), CharacterIdentity(..), Content(..),Page(..))
import Random
import Ball_One.Model exposing (Pattern(..))


{-|
    This function is for the update of the game Company and love controlled by players.

-}

updateB_OneUsrMsg : BallOneUserMsg -> Model -> ( Model, Cmd Msg )
updateB_OneUsrMsg msg model =
    let
        b_one = model.b1model
        pattern = b_one.pattern
    in
    case b_one.state of
        State_Start _ ->
            case msg of
                B1Game2Plot ->
                     case b_one.identity.page of
                        HintPage  ->
                            ( { model | b1model = ( initB_OneSubmodel Map Apple Pattern1 False),currentPage = HintPage},Cmd.none )
                        _ ->
                            ( { model | b1model = ( initB_OneSubmodel Map Apple Pattern1 False),currentPage = BuildingPage Square},Cmd.none )
                _ ->
                    ( updateStart msg model , Cmd.none )

        ActNotEnough ->
            case msg of
                B1Game2Plot ->
                    ( { model | b1model = ( initB_OneSubmodel Map Apple Pattern1 False),currentPage = BuildingPage Square},Cmd.none )
                _ ->
                    ( model , Cmd.none )

        Play ->
            case msg of
                PauseBallOne ->
                    ( { model | b1model = { b_one | state = State_Pause } }, Cmd.none )

                _ ->
                    ( model , Cmd.none )

        State_Pause ->
            case msg of
                ResumeBallOne ->
                    ( { model | b1model = { b_one | state = Play } } , Cmd.none )

                _ ->
                    ( model , Cmd.none )

        Pass ->
            case msg of
                B1Game2Plot ->
                    case model.b1model.te of
                        False ->
                            ( { model | b1model = ( initB_OneSubmodel model.b1model.identity.page Apple Pattern1 False)}
                            |> ( addGSpt pattern ) , Cmd.none)
                        True ->
                            ( { model | b1model = ( initB_OneSubmodel model.b1model.identity.page Apple Pattern1 True) }
                            |> ( addGSpt pattern ) , Cmd.none)
                _ ->
                    ( model , Cmd.none )

        Fail ->
            case msg of
                B1Game2Plot ->
                    case model.b1model.te of
                        False ->
                            ( { model | b1model = ( initB_OneSubmodel model.b1model.identity.page Apple Pattern1 False) } , Cmd.none)
                        True ->
                            ( { model | b1model = ( initB_OneSubmodel model.b1model.identity.page Apple Pattern1 True) } , Cmd.none)
                _ ->
                    ( model , Cmd.none )

        _ ->
            ( model , Cmd.none )


updateStart : BallOneUserMsg -> Model -> Model
updateStart msg model =
    let
        b_one = model.b1model
    in
    case msg of
        StartBallOne ->
            case b_one.identity.page of
                HintPage ->
                    {model | b1model = { b_one | state = Play} }
                _ ->
                    minusApt b_one.pattern model

        B1ChoosePattern pattern ->
            { model | b1model = { b_one | pattern = pattern , state = State_Start ValidPattern} }

        _ ->
            model

-- update in different patterns

minusApt : Pattern -> Model -> Model
minusApt pattern model =
    let
        pts =
            case pattern of
                Pattern1 ->
                    1
                Pattern2 ->
                    2
                Pattern3 ->
                    3
                Pattern4 ->
                    3

        b_one = model.b1model

    in
    if model.actionpoints - 1 < 0 then
        { model | b1model = { b_one | state = ActNotEnough }}
    else if model.actionpoints - pts < 0 then
        { model | b1model = { b_one | state = State_Start InvalidPattern }}
    else
        {model | actionpoints = model.actionpoints - pts , b1model = { b_one | state = Play} }


addGSpt : Pattern -> Model -> Model
addGSpt pattern model =
    let
        pts =
            case pattern of
                Pattern1 ->
                    20
                Pattern2 ->
                    30
                Pattern3 ->
                    40
                Pattern4 ->
                    45
    in
    {model | gsPoint = model.gsPoint + pts }

updatePattern : B_OneSubmodel ->  B_OneSubmodel
updatePattern b_one =
  let
       nmodel = changeBallSize b_one
  in
   case b_one.pattern of
     Pattern1 ->
       { b_one | ball = checkStruck b_one.goal b_one.ball }
     Pattern2 ->
       { b_one | ball = checkStruck b_one.goal b_one.ball, goal = moveGoal b_one b_one.goal }
     Pattern3 ->
       { nmodel | ball = checkStruck nmodel.goal nmodel.ball }
     Pattern4 ->
       { nmodel | ball = checkStruck nmodel.goal nmodel.ball  , goal = moveGoal b_one b_one.goal}

{-|
    This function is for the update of the game Company and love by time.

-}

updateb1ByTime : B_OneSubmodel -> ( B_OneSubmodel, Cmd Msg )
updateb1ByTime b_one =
        case b_one.state of
            Play ->
               updatePattern b_one
                |> updatepos
                |> updateEndState
                |> updateAllEndState
                |> updateinitGoal

            Interval ->
                       ( { b_one | endtime = b_one.endtime + 1 }
                            |> newround
                         , Cmd.none
                        )
            _ ->
                 ( b_one, Cmd.none )

{-|
    This function is for the update of the game Company and love by players pressing the keyboard.

-}

updateAdjustBall : UserMsg -> B_OneSubmodel -> ( B_OneSubmodel, Cmd Msg )
updateAdjustBall msg b_one =
    let
        ball =
            b_one.ball
    in
    case msg of
        PressedKey Aim ->
            updateballr b_one

        ReleasedKey Go ->
            if ball.state == Stop then
                ( { b_one | ball = { ball | state = Motion } }
                , Cmd.none
                )

            else
                ( b_one, Cmd.none )

        _ ->
            ( b_one, Cmd.none )

{-|
    This function is for the update of the game Company and love not controlled by players.

-}

updateb1ModelMsg : ModelMsgBallOne -> B_OneSubmodel -> ( B_OneSubmodel, Cmd Msg )
updateb1ModelMsg msg b_one =
    case msg of
        B_One point ->
            let
                ( x, y ) =
                    point

                goal =
                    b_one.goal
            in
            ( { b_one | goal = { goal | anchor = ( x, y ), width = 300, height = 50 } }, Cmd.none )


updateinitGoal : B_OneSubmodel -> ( B_OneSubmodel, Cmd Msg )
updateinitGoal b_one =
    let
        getResult : ( Float, Float ) -> Msg
        getResult ( x, y ) =
            B_One ( x, y )
                |> BallOneModelMsg
                |> Modelmsg
    in
    if b_one.goal.width == 0 && b_one.goal.height == 0 then
        ( b_one, Random.generate getResult initRandomGoal )

    else
        ( b_one, Cmd.none )

-- make the goal move
changeGoalDir : Goal -> Dir
changeGoalDir goal =
    if Tuple.first goal.anchor >= Tuple.second goal.boundary then
        Left_dir

    else if Tuple.first goal.anchor <= Tuple.first goal.boundary then
        Right_dir

    else
        goal.dir


moveGoal : B_OneSubmodel -> Goal -> Goal
moveGoal b1model goal =
    let
        time_ =
            if changeGoalDir b1model.goal /= b1model.goal.dir then
                0

            else
                b1model.time_goal+1

        nposx =
            case changeGoalDir goal of
                Left_dir ->
                    Tuple.first goal.anchor - time_

                Right_dir ->
                    Tuple.first goal.anchor + time_
                _->
                   Tuple.first goal.anchor
        nanchor = (nposx, Tuple.second goal.anchor)
    in
    { goal | anchor = nanchor , dir = changeGoalDir goal }

-- make the size of the ball change when playing
changeSizeDir : B_OneSubmodel -> B_OneSubmodel
changeSizeDir b_one =
  let
      ndir =
         if b_one.time_ball == 30 then
            Left_dir

         else if b_one.time_ball == 0 then
            Right_dir
         else
            b_one.ball.ball_dir
      tmp_ball =
         b_one.ball
      nball =
         { tmp_ball | ball_dir = ndir }
    in
        {b_one| ball = nball}

changeBallSize : B_OneSubmodel -> B_OneSubmodel
changeBallSize  b_one =
  case b_one.ball.state of
    Motion ->
        let
           nmodel = changeSizeDir b_one
           time_ =
            if nmodel.ball.ball_dir == Left_dir then
                b_one.time_ball - 1

            else if nmodel.ball.ball_dir == Right_dir then
                b_one.time_ball + 1
            else
                b_one.time_ball

           nscale = time_ / 10

           tmp_ball = nmodel.ball

           nball ={ tmp_ball | radius = 90 + 10 * nscale }
        in
          { nmodel | time_ball = time_ , ball = nball}
    _->
       b_one


updateballr : B_OneSubmodel -> ( B_OneSubmodel, Cmd Msg )
updateballr b_one =
    let
        ball =
            b_one.ball
    in
    if ball.state == Stop then
        if ball.aimtime > 80 then
            ( b_one, Cmd.none )

        else
            ( { b_one | ball = { ball | radius = ball.radius + 0.5, aimtime = ball.aimtime + 1 } }
            , Cmd.none
            )

    else
        ( b_one, Cmd.none )


updateEndState : B_OneSubmodel -> B_OneSubmodel
updateEndState b_one =
    let
        ball =
            b_one.ball
    in
    if checkGoal b_one.ball b_one.goal then
        case ball.state of
            Win True ->
                -- True: add score
                { b_one | ball = { ball | state = Win False } }

            Win False ->
                b_one

            _ ->
                { b_one | ball = { ball | state = Win True }, score = b_one.score + 10 }

    else if checkEnd ball then
        { b_one
            | ball = updateLose b_one.ball
            , state = Interval
            , chance = b_one.chance - 1
        }

    else
        b_one


updateLose : Ball -> Ball
updateLose ball =
    if ball.state == Motion then
        { ball | state = Lose }

    else
        ball


updatepos : B_OneSubmodel -> B_OneSubmodel
updatepos b_one =
    let
        ball =
            b_one.ball

        nAngle =
            if getDeltaY ball.aimtime (Tuple.first ball.anchor) <= 0 then
                atan2 (-1 * getDeltaY ball.aimtime (Tuple.first ball.anchor)) -1

            else
                atan2 (-1 * getDeltaY ball.aimtime (Tuple.first ball.anchor)) -1 + 2 * pi
    in
    if b_one.ball.state /= Stop then
        case ball.path of
            Curve ->
                { b_one | ball = { ball | anchor = updateanc ball.aimtime ball.anchor, lineAngle = nAngle } }

            Line ->
                { b_one | ball = lineMoveBall ball }

    else
        b_one


updateanc : Float -> Point -> Point
updateanc k ( x, y ) =
    let
        ( xdir, ydir ) =
            ( -3, getDeltaY k x * 3 )
    in
    ( x + xdir, y + ydir )


lineMoveBall :
    Ball
    -> Ball --move ball along its angle of motion
lineMoveBall ball =
    let
        x =
            Tuple.first ball.anchor + 3 * cos ball.lineAngle

        y =
            Tuple.second ball.anchor - 3 * sin ball.lineAngle

        nanchor =
            Tuple.pair x y
    in
    { ball | anchor = nanchor }


newround : B_OneSubmodel -> B_OneSubmodel
newround b_one =
    if b_one.endtime > 50 && b_one.chance /= 0 then
        let
            {page,item} = b_one.identity
            pattern = b_one.pattern
            te = b_one.te
            initb1model = initB_OneSubmodel page item pattern te
        in
        initb1model
            |> (\a -> { a | score = b_one.score, chance = b_one.chance, state = Play })

    else
        b_one


judgeposXInGoal : Float -> Float -> Float -> Bool
judgeposXInGoal ballx goalx delta =
    ballx >= goalx + 30 && ballx <= goalx + delta - 30


judgeposYInGoal : Float -> Float -> Float -> Bool
judgeposYInGoal bally goaly delta =
    bally >= goaly + delta / 2 && bally <= goaly + delta



-- whether ball reaches goal


checkGoal : Ball -> Goal -> Bool
checkGoal ball goal =
    let
        ( ballX, ballY ) =
            ball.anchor

        ( goalX, goalY ) =
            goal.anchor

        ( wid, hei ) =
            ( goal.width, goal.height )
    in
    if judgeposXInGoal ballX goalX wid then
        judgeposYInGoal ballY goalY hei

    else
        False


checkStruck : Goal -> Ball -> Ball
checkStruck goal ball =
    let
        ( ballX, ballY ) =
            ball.anchor

        angle =
            ball.lineAngle

        ( goalX, goalY ) =
            goal.anchor

        ( wid, hei ) =
            ( goal.width, goal.height )

        changedir =
            changeDir ( ballX, ballY ) ( goalX, goalY ) ( wid, hei ) angle
    in
    if ball.strike then
        ball

    else
        case changedir of
            Nothing ->
                ball

            Just dir ->
                let
                    nAngle =
                        changeBallDir (Just dir) angle
                in
                { ball | path = Line, lineAngle = nAngle, strike = True }


changeDir : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> Float -> Maybe Dir
changeDir ( ballX, ballY ) ( goalX, goalY ) ( wid, hei ) angle =
    if ballY < 70 then
        Just Up_dir

    else if ballY >= goalY - hei / 2 && ballY <= goalY + hei then
        if ballX > goalX - 30 && ballX < goalX + 30 then
            if angle <= pi then
                Just Up_dir

            else
                Just Down_dir

        else if ballX > goalX + wid - 30 && ballX < goalX + wid + 30 then
            if angle <= pi then
                Just Up_dir

            else
                Just Down_dir

        else
            Nothing

    else
        Nothing


changeBallDir :
    Maybe Dir
    -> Float
    -> Float
changeBallDir strike oldangle =
    case strike of
        Just Left_dir ->
            if oldangle <= pi then
                pi - oldangle

            else
                3 * pi - oldangle

        Just Right_dir ->
            if oldangle <= pi / 2 then
                pi - oldangle

            else
                3 * pi - oldangle

        Just Up_dir ->
            2 * pi - oldangle

        Just Down_dir ->
            if oldangle >= pi / 2 then
                2 * pi - oldangle

            else
                2 * pi - 2 * oldangle

        _ ->
            oldangle



--whether the ball reaches ground


checkEnd : Ball -> Bool
checkEnd ball =
    let
        ( x, y ) =
            ball.anchor
    in
    if y > 800 || y < 90 || x < ball.radius then
        True

    else
        False


updateAllEndState : B_OneSubmodel -> B_OneSubmodel
updateAllEndState b_one =
    let
        data =
            ( b_one.chance, b_one.score >= 10 )
    in
    case data of
        ( 0, True ) ->
            { b_one | state = Pass }

        ( 0, False ) ->
            { b_one | state = Fail }

        _ ->
            b_one

{-|
    This function is for the update of initializing the game Company and love under different situations.

-}

b1Init : Model -> Model
b1Init model =
    case model.currentPage of
        HintPage ->
            { model | b1model = initB_OneSubmodel model.currentPage Apple Pattern1 False, currentPage = (GamePage BallOne) }
        _ ->
            case model.startTE of
                TEInProg ->
                    { model | b1model = initB_OneSubmodel model.currentPage Apple Pattern1 True, currentPage = (GamePage BallOne) }
                _ ->
                    { model | b1model = initB_OneSubmodel model.currentPage Apple Pattern1 False, currentPage = (GamePage BallOne) }

maxMidX : Float
maxMidX =
    1100


minMidX : Float
minMidX =
    389


deltaMidXperAimTime : Float
deltaMidXperAimTime =
    (maxMidX - minMidX) / 80


getDeltaY : Float -> Float -> Float
getDeltaY aimTime x =
    let
        midX =
            maxMidX - aimTime * deltaMidXperAimTime

        a =
            (-650 + 100) / ((1300 - midX) ^ 2)
    in
    2 * a * x - 2 * a * midX