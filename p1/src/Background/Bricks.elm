module Background.Bricks exposing (BrickState(..), BrickType(..), Bricks, SpecialItem(..), bricksFall, dropBroken, makeBricks, randomBricks)

{- The module that contains functions and types for the bricks. -}

import Debug exposing (toString)
import Html exposing (Html)
import Html.Attributes exposing (src, style)
import List exposing (concat, filter, map, range)
import Random exposing (Seed(..), constant, map5, step, weighted)


type SpecialItem
    = BigPaddle
    | BigBall
    | AnotherBall
    | None


type BrickState
    = Normal
    | Broken
    | Fortified


type BrickType
    = Magma
    | Rock


type alias Bricks =
    { state : BrickState
    , brickType_ : BrickType
    , specialItem_ : SpecialItem
    , xPosition : Float
    , yPosition : Float
    }


checkBroken : Bricks -> Bool
checkBroken theBrick =
    case theBrick.state of
        Broken ->
            False

        _ ->
            True



{- This function randomize the bricks at the very beginning.
   After searching all over the package, I've not found an out-of-box useful
   function that can help with our bricks list.
-}


randomBricks : Int -> Seed -> ( List Bricks, Seed )
randomBricks level =
    \seed ->
        randomHelp [] initBrickX (randomBrick level) seed



--This is a help function which helps create a List of randomized items


randomHelp : List Bricks -> List ( Float, Float ) -> (Float -> Float -> (Seed -> ( Bricks, Seed ))) -> Seed -> ( List Bricks, Seed )
randomHelp revList coordinates gen seed =
    case coordinates of
        [] ->
            ( revList, seed )

        ( x, y ) :: rest ->
            let
                ( brick, newSeed ) =
                    gen x y seed
            in
            randomHelp (brick :: revList) rest gen newSeed



--This is a fundamental function that gives random Brick
--Note the possibility of special items are connected with
--the level you're in


randomBrick : Int -> Float -> Float -> Seed -> ( Bricks, Seed )
randomBrick level x y =
    let
        multiplier =
            toFloat level
    in
    step
        (map5
            (\brickState brickType specialItem bX bY -> Bricks brickState brickType specialItem bX bY)
            (weighted ( 100, Normal ) [ ( 0, Broken ), ( 10 * multiplier, Fortified ) ])
            (weighted ( 50, Magma ) [ ( 50, Rock ) ])
            (weighted ( 95, None )
                [ ( 4 * multiplier, BigPaddle )
                , ( 4 * multiplier, AnotherBall )
                , ( 2 * multiplier, BigBall )
                ]
            )
            (constant x)
            (constant y)
        )



--Simple function for Coordinates


createCoordinate : Float -> Float -> ( Float, Float )
createCoordinate x y =
    ( x, y )



--Initializing the coordinates for the brick list
--They are fixed and shall not be randomized


initBrickY : Float -> List ( Float, Float )
initBrickY x =
    map (createCoordinate x) (map toFloat (map ((*) 7) (range 1 5)))


initBrickX : List ( Float, Float )
initBrickX =
    concat (map initBrickY (map toFloat (map ((*) 10) (range 1 8))))

-- filter broken bricks

dropBroken : List Bricks -> List Bricks
dropBroken prevBricks =
    filter checkBroken prevBricks



--A basic function to show one brick.


makeOneBrick : Bricks -> Html msg
makeOneBrick { xPosition, yPosition, state, brickType_, specialItem_ } =
    let
        brickSrc =
            "assets/images/" ++ "Bricks_" ++ toString state ++ "_" ++ toString brickType_ ++ "_" ++ toString specialItem_ ++ ".png"
    in
    Html.img
        [ style "width" "8%" --with respect to the width of the png file
        , style "height" "6%"
        , style "position" "absolute"
        , style "left" (toString xPosition ++ "%")
        , style "top" (toString yPosition ++ "%")
        , src brickSrc
        ]
        []


makeBricks : List Bricks -> List (Html msg)
makeBricks bricks =
    map makeOneBrick bricks



--Likewise, the speed of the bricks falling down are connected with the level.


brickFall : Int -> Bricks -> Bricks
brickFall level brick =
    let
        newY =
            brick.yPosition

        speed =
            0.001 * toFloat (5 ^ (level - 1))
    in
    { brick | yPosition = newY + speed }


bricksFall : List Bricks -> Int -> List Bricks
bricksFall bricks level =
    map (brickFall level) bricks
