module Ball_Three.Update exposing (updateb3BrickState, updateb3Key, updateb3ModelMsg, updateb3UserMsg,b3Init)
{-| This module controls part of the update for the game Seize the wanted.

# Ball3 Update Function
@docs updateb3BrickState, updateb3Key, updateb3ModelMsg, updateb3UserMsg,b3Init

-}

import Ball_Three.Color exposing (red,blue,green,yellow,purple,lightblue,Color,getColor)
import Ball_Three.Init exposing (initB_ThrSubmodel, initBrick,initBricks,initCloth,initScore)
import Ball_Three.Message exposing (BallThreeUserMsg(..), ColorType(..), Group(..), ModelMsgBallThree(..))
import Ball_Three.Model exposing (PatternValid(..),B_ThrSubmodel, BriState(..), Brick, Cloth, ClothState(..), GameState(..), Point, Score)
import Msg exposing (KeyInput(..), ModelMsg(..), Msg(..), UserMsg(..))
import Random
import Model exposing (Model)
import Basis exposing (GameIdentity,GamePF(..),GameStatus,Phase(..),Building(..), CharacterIdentity(..), Content(..), GameKind(..), Item(..), LibraryBuilding(..), Page(..), SchoolBuilding(..))
import Ball_Three.Model exposing (Pattern(..))

{-|
    This function is for the update of the game Seize the wanted controlled by players.

-}

updateb3UserMsg : BallThreeUserMsg -> Model -> ( Model, Cmd Msg )
updateb3UserMsg msg model =
    let
        b_thr = model.b3model
    in
    case b_thr.gamestate of
        State_Play ->
            let
                nb_thr =
                    b_thr
                    |> checkPause msg
            in
            ( { model | b3model = nb_thr } , Cmd.none )

        State_Start _ ->
            state_start msg model

        ActNotEnough ->
            case msg of
                B3Game2Plot ->
                    ( { model | b3model = ( initB_ThrSubmodel Map Apple False) , currentPage = model.b3model.identity.page} , Cmd.none )
                _ ->
                    ( model , Cmd.none )

        State_Pause ->
            case msg of
                Resume ->
                    ( { model | b3model = { b_thr | gamestate = State_Play } }, Cmd.none )

                _ ->
                    ( { model | b3model = b_thr }, Cmd.none )

        Intervalb3 ->
            case msg of
                NextBallThree ->

                    nextball3 model

                _ ->
                    ( model, Cmd.none )

        Win ->
            case msg of
                B3Game2Plot ->
                    b3game2plot model
                _ ->
                    ( model , Cmd.none)

        Lose ->
            case msg of
                B3Game2Plot ->
                    b3game2plotB model
                _ ->
                    ( model , Cmd.none )

state_start : BallThreeUserMsg -> Model ->  (Model, Cmd Msg)
state_start msg model =
    let
        b_thr = model.b3model
    in
    case msg of
        StartBallThree ->
            case b_thr.te of
                False ->
                    ( { model | b3model = { b_thr | gamestate = State_Play } }, Cmd.none )
                True ->
                    ( minusApt model.b3model.pattern model , Cmd.none )

        B3Game2Plot ->
            ( { model | b3model = ( initB_ThrSubmodel Map Apple False) , currentPage = model.b3model.identity.page} , Cmd.none )

        B3ChoosePattern pattern ->
            b3choosepattern model pattern

        _ ->
            ( { model | b3model = b_thr }, Cmd.none )

minusApt : Pattern -> Model -> Model
minusApt pattern model =
    let
        pts =
            case pattern of
                Pattern1 ->
                    1
                Pattern2 ->
                    2

        b3model = model.b3model
    in
    if model.actionpoints - 1 < 0 then
        { model | b3model = { b3model | gamestate = ActNotEnough }}
    else if model.actionpoints - pts < 0 then
        { model | b3model = { b3model | gamestate = State_Start InvalidPattern }}
    else
        {model | actionpoints = model.actionpoints - pts , b3model = { b3model | gamestate = State_Play} }

b3choosepattern : Model -> Int ->  (Model, Cmd Msg)
b3choosepattern model pattern =
    let
        b3model = model.b3model
        npattern =
            case pattern of
                2 ->
                    Pattern2
                _ ->
                    Pattern1
    in
    ( { model | b3model ={ b3model | pattern = npattern , gamestate = State_Start ValidPattern} } , Cmd.none )


nextball3 : Model -> (Model, Cmd Msg)
nextball3 model =
    let
        b_thr = model.b3model
        {page,item} =
            model.b3model.identity
        te = model.b3model.te
        pattern = model.b3model.pattern
        initb3model =
            initB_ThrSubmodel page item te
            |>(\a ->
                    { a
                        | score = b_thr.score
                        , round = b_thr.round
                        , colorNeed_P1 = switchColorty b_thr.colorNeed_P1
                        , gamestate = State_Play
                        , pattern = pattern
                    }
                )
    in
    ( { model | b3model = initb3model }
    , Cmd.none
    )


b3game2plot : Model -> (Model , Cmd Msg)
b3game2plot model =
    if model.b3model.identity.page == HintPage then
        ( { model | b3model = ( initB_ThrSubmodel Map Apple False) , currentPage = HintPage} , Cmd.none )
    else
    case model.b3model.te of
        False ->
            let
                {page,item} = model.b3model.identity
                (npage,nmodel) =
                    case page of
                        PersonPage Drawer P2 C ->
                            let
                                dmodel = model.drawerModel
                                ndmodel = { dmodel | gamestatusb3 = GameStatus Pass BallThree }
                            in
                                (PersonPage Drawer P2 D , { model | drawerModel = ndmodel } )
                        HintPage ->
                            (HintPage,model)
                        _ ->
                            (page,model)
            in
            ({ nmodel | currentPage = npage },Cmd.none)
        True ->
            let
                {page,item} = model.b3model.identity
                pattern = model.b3model.pattern
            in
            ({model | b3model = initB_ThrSubmodel page Apple True }|> ( addGSpt pattern ),Cmd.none)

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
    {model | gsPoint = model.gsPoint + pts }

b3game2plotB : Model -> (Model , Cmd Msg)
b3game2plotB model =
    if model.b3model.identity.page == HintPage then
        ( { model | b3model = ( initB_ThrSubmodel Map Apple False) , currentPage = HintPage} , Cmd.none )
    else
    case model.b3model.te of
        False ->
            let
                dmodel = model.drawerModel
                ndmodel = { dmodel | gamestatusb3 = GameStatus Fail BallThree }
            in
            ( { model | currentPage = ( PersonPage Drawer P2 E ), drawerModel = ndmodel }, Cmd.none )
        True ->
            let
                {page,item} = model.b3model.identity
            in
            ({model | b3model = initB_ThrSubmodel page Apple True},Cmd.none)

checkPause : BallThreeUserMsg -> B_ThrSubmodel -> B_ThrSubmodel
checkPause msg b_thr =
    case msg of
        Pause ->
            { b_thr | gamestate = State_Pause }

        _ ->
            b_thr



switchColorty : ColorType -> ColorType
switchColorty clr =
    case clr of
        Dark ->
            Light

        Light ->
            Dark


checkInterval : B_ThrSubmodel -> B_ThrSubmodel
checkInterval b_thr =
    if b_thr.time > 1000 then
        { b_thr | gamestate = Intervalb3, round = b_thr.round - 1 }

    else
        b_thr


checkEnd : B_ThrSubmodel -> B_ThrSubmodel
checkEnd b_thr =
    if b_thr.round == 0 then
      case b_thr.pattern of
        Pattern1 ->
          if checkscore_P1 b_thr.score then
            { b_thr | gamestate = Win }

          else
            { b_thr | gamestate = Lose }
        Pattern2 ->
          if checkscore_P2 b_thr.total_score then
            { b_thr | gamestate = Win }

          else
            { b_thr | gamestate = Lose }

    else
        b_thr


checkscore_P1 : Score -> Bool
checkscore_P1 score =
    let
        ( s1, s2 ) =
            score.pair1

        ( s3, s4 ) =
            score.pair2

        ( s5, s6 ) =
            score.pair3
    in
    if
        s1
            >= 10
            && s2
            >= 10
            && s3
            >= 10
            && s4
            >= 10
            && s5
            >= 10
            && s6
            >= 10
    then
        True

    else
        False




checkscore_P2 : Int -> Bool
checkscore_P2 score =
    if
        score >= 50
    then
        True

    else
        False


-- Bricks

{-|
    This function is for the update of the game Seize the wanted by time.

-}

updateb3BrickState : B_ThrSubmodel -> ( B_ThrSubmodel, Cmd Msg )  
updateb3BrickState b_thr =
    case b_thr.gamestate of
        State_Play ->
            moveBricks b_thr
                |> checkInterval
                |> checkEnd
                |> updateClothPos
                |> getnewBlock
                |> addTimer
                |> updatescore
                |> filterBricks
                |> updateDirClr

        _ ->
            ( b_thr, Cmd.none )

{-|
    This function is for the update of the game Seize the wanted not controlled by players.

-}
updateb3ModelMsg : ModelMsgBallThree -> B_ThrSubmodel -> ( B_ThrSubmodel, Cmd Msg )
updateb3ModelMsg msg b_thr =
    case msg of
        GetDir _ ->
            ( updateDirs msg b_thr, Cmd.none )

        GetColor_P1 _ ->
            ( updateColors msg b_thr, Cmd.none )
        GetColor_P2 _ ->
            (generateP2Color msg b_thr, Cmd.none)


generateP2Color: ModelMsgBallThree -> B_ThrSubmodel -> B_ThrSubmodel
generateP2Color msg b_thr =
   case msg of
     GetColor_P2 x ->
        let
             ncolor =
               case x of
                 1 ->
                     red
                 2 ->
                     blue
                 3->
                    green
                 4 -> 
                    yellow
                 5 ->
                    lightblue
                 6 ->
                    purple   
                 _->
                    blue
        in 
          {b_thr| colorNeed_P2 = ncolor}
     _->
       b_thr
        

addTimer : B_ThrSubmodel -> B_ThrSubmodel
addTimer b_thr =
    { b_thr | time = b_thr.time + 1 }


updateDirs : ModelMsgBallThree -> B_ThrSubmodel -> B_ThrSubmodel
updateDirs msg b_thr =
    { b_thr | bricks = List.map (\x -> updateDir x msg) b_thr.bricks }


updateDir : Brick -> ModelMsgBallThree -> Brick
updateDir brick msg =
    let
        state =
            brick.state
    in
    case state of
        Empty ->
            case msg of
                GetDir x ->
                    { brick | dir = ( x, -0.3 ), state = Play }

                _ ->
                    brick

        _ ->
            brick


updateColors : ModelMsgBallThree -> B_ThrSubmodel -> B_ThrSubmodel
updateColors msg b_thr =
    { b_thr | bricks = List.map (\x -> updateColor x msg) b_thr.bricks }


updateColor : Brick -> ModelMsgBallThree -> Brick
updateColor brick msg =
    let
        state =
            brick.state
    in
    case state of
        Empty ->
            case msg of
                GetColor_P1 pair ->
                    { brick | color = getColor pair }

                _ ->
                    brick

        _ ->
            brick

randomNeedColor : Random.Generator Int
randomNeedColor  =
    Random.int 1 6

randomDir : Random.Generator Float
randomDir =
    Random.float -0.6 0.6


randomColor : B_ThrSubmodel -> Random.Generator ( Int, ColorType )
randomColor b_thr =
    let
        a =
            b_thr.colorNeed_P1

        b =
            case a of
                Dark ->
                    Light

                Light ->
                    Dark
    in
    Random.pair (Random.int 1 3)
        (Random.weighted ( 70, a )
            [ ( 30, b ) ]
        )

timeToChangeColor : B_ThrSubmodel -> Bool
timeToChangeColor b_thr =
  if (b_thr.time == 300 || b_thr.time == 600 || b_thr.time == 800 ) then
    True
  else
    False

updateDirClr : B_ThrSubmodel -> ( B_ThrSubmodel, Cmd Msg )
updateDirClr b_thr =
    let
        getFloat : Float -> Msg
        getFloat x =
            GetDir x
                |> BallThreeModelMsg
                |> Modelmsg

        getResult : ( Int, ColorType ) -> Msg
        getResult ( x, c ) =
            GetColor_P1 ( x, c )
                |> BallThreeModelMsg
                |> Modelmsg
        getInt : Int -> Msg
        getInt z =
            GetColor_P2 z
                |> BallThreeModelMsg
                |> Modelmsg
    in
     if timeToChangeColor b_thr then 
       ( b_thr
        , Cmd.batch
            [ 
                 Random.generate getInt randomNeedColor
            ]
        )
     else if isEmpty b_thr.bricks then
        ( b_thr
        , Cmd.batch
            [ Random.generate getFloat randomDir
            , Random.generate getResult (randomColor b_thr)
            ]
        )
     else
        ( b_thr, Cmd.none )

isEmpty : List Brick -> Bool
isEmpty bricks =
    let
        emptybricks =
            List.filter (\x -> x.state == Empty) bricks

        flag =
            List.length emptybricks > 0
    in
     flag


moveBricks : B_ThrSubmodel -> B_ThrSubmodel
moveBricks b_thr =
    let
        newBricks =
            List.map moveBrick b_thr.bricks
    in
    { b_thr | bricks = newBricks }


moveBrick :
    Brick
    -> Brick -- include change scale
moveBrick brick =
    { brick
        | anchor = addVec brick.anchor brick.dir
        , width = brick.width * brick.scale
        , height = brick.height * brick.scale
        , scale = 1 - 0.00005 * brick.time
    }
        |> gettime


gettime : Brick -> Brick
gettime brick =
    { brick | time = brick.time + 1 }


checkBound : ( Float, Float ) -> Brick -> Bool
checkBound ( boundX, boundY ) brick =
    let
        ( x, y ) =
            brick.anchor
    in
    if
        x
            >= boundX
            || x
            <= 0
            || y
            >= boundY
            || y
            <= 0
    then
        False

    else
        True


getnewBlock : B_ThrSubmodel -> B_ThrSubmodel
getnewBlock b_thr =
    if checkgetnewBrick b_thr then
        { b_thr | bricks = initBrick :: b_thr.bricks }

    else
        b_thr


checkgetnewBrick : B_ThrSubmodel -> Bool
checkgetnewBrick b_thr =
    if modBy 60 b_thr.time == 0 then
        True

    else
        False



-- Cloth


updateClothPos : B_ThrSubmodel -> B_ThrSubmodel
updateClothPos b_thr =
    { b_thr | cloth = updatePos b_thr.cloth }

{-|
    This function is for the update of the game Seize the wanted by pressing the keyboard.

-}
updateb3Key : UserMsg -> B_ThrSubmodel -> B_ThrSubmodel
updateb3Key msg b_thr =
    case b_thr.gamestate of
        State_Play ->
            case msg of
                PressedKey dir ->
                    updateWay dir b_thr

                ReleasedKey dir ->
                    updateStop dir b_thr

                _ ->
                    b_thr

        _ ->
            b_thr


updateWay : KeyInput -> B_ThrSubmodel -> B_ThrSubmodel
updateWay keyin b_thr =
    { b_thr | cloth = directedCloth b_thr.cloth keyin }


updateStop : KeyInput -> B_ThrSubmodel -> B_ThrSubmodel
updateStop keyin b_thr =
    let
        cloth =
            b_thr.cloth
    in
    { b_thr | cloth = { cloth | state = Static } }


directedCloth : Cloth -> KeyInput -> Cloth
directedCloth cloth keyin =
    case cloth.state of
        Moving dir ->
            --if dir ==keyin then
            --let
            --acce = min (cloth.accelerate + 1) 5
            --in {cloth | state = Moving keyin, accelerate=acce}
            --else
            { cloth | state = Moving keyin }

        --accelerate = 1}
        Static ->
            { cloth | state = Moving keyin }



--, accelerate = 1}


updatePos : Cloth -> Cloth
updatePos cloth =
    case cloth.state of
        Moving dir ->
            { cloth | anchor = addVec cloth.anchor (getspeed dir) }

        _ ->
            cloth


getspeed : KeyInput -> Point
getspeed dir =
    case dir of
        Right ->
            ( 1, 0 )

        Left ->
            ( -1, 0 )

        Up ->
            ( 0, -1 )

        Down ->
            ( 0, 1 )

        _ ->
            ( 0, 0 )



-- judge


filterBricks : B_ThrSubmodel -> B_ThrSubmodel
filterBricks b_thr =
    { b_thr
        | bricks =
            List.filter (isBrickinCloth b_thr.cloth) b_thr.bricks
                |> List.filter (checkBound b_thr.boundary)
    }


isBrickinCloth : Cloth -> Brick -> Bool
isBrickinCloth cloth brick =
    let
        ( brX, brY ) =
            brick.anchor

        ( clX, clY ) =
            cloth.anchor

        delta =
            cloth.width - brick.width
    in
    if isBrickSmall brick then
        if judgePos brX clX delta then
            if judgePos brY clY delta then
                False

            else
                True

        else
            True

    else
        True

{-|
    This function is for the update of initializing the game Company and love under different situations.

-}

isBrickSmall : Brick -> Bool
isBrickSmall brick =
    if brick.width <= 8.5 then
        True

    else
        False


judgePos : Float -> Float -> Float -> Bool
judgePos brickx clothx delta =
    (brickx - clothx) <= delta && clothx < brickx


addVec : ( number, number ) -> ( number, number ) -> ( number, number )
addVec p1 p2 =
    let
        ( x1, y1 ) =
            p1

        ( x2, y2 ) =
            p2
    in
    ( x1 + x2, y1 + y2 )


scalarVec : Float -> Point -> Point
scalarVec k pt =
    let
        ( x, y ) =
            pt
    in
    ( k * x, k * y )



--score


updatescore : B_ThrSubmodel -> B_ThrSubmodel
updatescore b_thr =
    getallscore b_thr b_thr.bricks


getallscore : B_ThrSubmodel -> List Brick -> B_ThrSubmodel
getallscore b_thr bricks =
 case b_thr.pattern of
  Pattern1 ->
     case bricks of
        x :: xs ->
            getallscore { b_thr | score = getscore_P1 b_thr.cloth b_thr.colorNeed_P1 b_thr.score x } xs

        [] ->
            b_thr
  Pattern2 ->
      case bricks of
        x :: xs ->
            getallscore { b_thr | total_score = getscore_P2 b_thr.cloth b_thr.colorNeed_P2 b_thr.total_score x } xs

        [] ->
            b_thr


getscore_P1 : Cloth -> ColorType -> Score -> Brick -> Score
getscore_P1 cloth clrneed score brick =
    if not (isBrickinCloth cloth brick) then
        if clrneed == brick.color.category then
            case ( brick.color.pair, brick.color.category ) of
                ( Red, Dark ) ->
                    { score | pair1 = addVec score.pair1 ( 10, 0 ) }

                ( Red, Light ) ->
                    { score | pair1 = addVec score.pair1 ( 0, 10 ) }

                ( Green, Dark ) ->
                    { score | pair2 = addVec score.pair2 ( 10, 0 ) }

                ( Green, Light ) ->
                    { score | pair2 = addVec score.pair2 ( 0, 10 ) }

                ( Blue, Dark ) ->
                    { score | pair3 = addVec score.pair3 ( 10, 0 ) }

                ( Blue, Light ) ->
                    { score | pair3 = addVec score.pair3 ( 0, 10 ) }

                _ ->
                    score

        else
            case ( brick.color.pair, brick.color.category ) of
                ( Red, Dark ) ->
                    { score | pair1 = addVec score.pair1 ( 0, -5 ) }

                ( Red, Light ) ->
                    { score | pair1 = addVec score.pair1 ( -5, 0 ) }

                ( Green, Dark ) ->
                    { score | pair2 = addVec score.pair2 ( 0, -5 ) }

                ( Green, Light ) ->
                    { score | pair2 = addVec score.pair2 ( -5, 0 ) }

                ( Blue, Dark ) ->
                    { score | pair3 = addVec score.pair3 ( 0, -5 ) }

                ( Blue, Light ) ->
                    { score | pair3 = addVec score.pair3 ( -5, 0 ) }

                _ ->
                    score
    else
        score

getscore_P2 : Cloth -> Color -> Int -> Brick -> Int
getscore_P2 cloth clrneed score brick =
  if not (isBrickinCloth cloth brick) then
    if clrneed == brick.color.color then
       score + 10
    else
       score - 5
  else
     score

{-|
    This function is for the update of initializing the game Seize the wanted under different situations.

-}
b3Init : Model -> Model
b3Init model =
    let
        page = model.currentPage
        initb3modelsame = B_ThrSubmodel initCloth initBricks initScore ( 160, 90 )
        ( npage , nb3model ) =
            case page of
                PersonPage Drawer P2 C ->
                    case model.drawerModel.gamestatusb3.pOf of
                        Before ->
                            ( GamePage BallThree , initB_ThrSubmodel page Apple False)
                        Pass ->
                            let
                                identity = GameIdentity page Apple
                                initb3model = initb3modelsame 1 Dark Win 3 identity Pattern1 0 red False
                             in
                                 (GamePage BallThree , initb3model )
                        Fail ->
                            let
                                identity = GameIdentity page Apple
                                initb3model = initb3modelsame 1 Dark Lose 3 identity Pattern1 0 red False
                             in
                                 (GamePage BallThree , initb3model )
                PersonPage Drawer P3 A ->
                    (GamePage BallThree, initB_ThrSubmodel page Apple True)
                HintPage ->
                    ( GamePage BallThree , initB_ThrSubmodel page Apple False)
                _ ->
                    ( page,model.b3model)
    in
    { model | b3model = nb3model , currentPage = npage }
