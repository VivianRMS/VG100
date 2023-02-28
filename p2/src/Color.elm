module Color exposing (initTris,Tri,triHeight,triWidth,TDirection(..),triButtonTwoDeltaY,triButtonOneDeltaY,triButtonOneWidth,triButtonTwoThreeWidth,triButtonThreeDeltaY,triButtonFourDeltaX,triButtonFourWidth,triButtonFourDeltaY,CState(..),changeColorTris,clickChangeColor,whetherValidClick,CResult(..),Pattern(..),initTriLeft,maxStep)
{-| This module defines basic data types and functions for the game Color Union.

# Data types
@docs Tri, TDirection, CState, CResult, Pattern

# Initialization functions
@docs initTris, triHeight, triWidth, triButtonTwoDeltaY, triButtonOneDeltaY, triButtonOneWidth, 
triButtonTwoThreeWidth, triButtonThreeDeltaY, triButtonFourDeltaX, triButtonFourWidth, 
triButtonFourDeltaY, maxStep, initTriLeft

# Operation functions
@docs changeColorTris, clickChangeColor, whetherValidClick

-}
import Maybe
import ColorElements exposing (pieceApple,pieceHint,pieceLeaf,pieceBlueCloth,pieceGrassRing,pieceTE1,pieceTE2)
{-|
    This data type determines different kinds of Color Union in different scenes.
    The PApple type shows up when the apple appears in the school classroom.
    The PBlueCloth type shows up when the blue cloth appears in the school history room.
    The PGrassRing type shows up when the grass ring appears on the lawn.
    The PHint type shows up on the library Guide floor.
    The PLeaf type shows up in the apartment.
    The PTE1 type shows up in the apartment after entering the true ending line.
    The PTE2 type shows up in the apartment after entering the true ending line.
-}
type Pattern
    = PApple
    | PBlueCloth
    | PGrassRing
    | PHint
    | PLeaf
    | PTE1
    | PTE2

{-|
    This data type includes different game status.
    The CBefore is at the very beginning of the game.
    The CPrepare is when the pattern is chosen and added to the Csubmodel.
    The CPlaying is after the game starts.
    The CGiveUp is when the player chooses to give up.
    The CEnd is after the game result is determined.

-}
type CState
    = CPrepare Pattern
    | CPlaying
    | CEnd
    | CBefore
    | CGiveUp

{-|
    This data type includes different game results.
    The CVictory is when the player succeeds.
    The CFailure is when the player loses.
    The CUndetermined is when the game result has not been decided yet.

-}
type CResult
    = CVictory
    | CFailure
    | CUndetermined


{-|
    This data type is for one small triangle in the pattern.
    The pos records the three end points' positions of the triangle.
    The index records the number index of the triangle.
    The colRow records in which column and row the triangle is.
    The tdir records whether the triangle is towards left or right.
    The center records whether the triangle is currently at the center of the color changing range.
-}
type alias Tri =
    { pos : List ( Float, Float )
    , index : Float
    , colRow : ( Int, Int )
    , color : Int
    , tdir : TDirection
    , center : Bool
    }

{-|
    This data type defines the direction of each small triangle.
    The TLeft is when one of the endpoint is on the left of the other two.
    The TRight is when one of the endpoint is on the right of the other two.
-}
type TDirection
    = TLeft
    | TRight

{-|
    This function defines how many steps the player is given for different patterns.
-}
maxStep : Pattern -> Int
maxStep pattern =
    case pattern of
        PHint ->
            4
        PApple ->
            3
        PGrassRing ->
            3
        PBlueCloth ->
            3
        PLeaf ->
            2
        PTE1 ->
            4
        PTE2 ->
            3

{-|
    This function defines the height of each small triangle.
-}
triHeight : Float
triHeight =
    46 * sqrt 3

{-|
    This function defines the width of each small triangle.
-}
triWidth : Float
triWidth =
    triHeight / 2 * sqrt 3

{-|
    This function defines the y-position of button one inside the triangle.
-}
triButtonOneDeltaY : Float
triButtonOneDeltaY =
    triHeight / (sqrt 3 + 2)

{-|
    This function defines the width of button one inside the triangle.
-}
triButtonOneWidth : Float
triButtonOneWidth =
    triButtonOneDeltaY * sqrt 3

{-|
    This function defines the width of button two and three inside the triangle.
-}
triButtonTwoThreeWidth : Float
triButtonTwoThreeWidth =
    triButtonOneDeltaY - triButtonTwoDeltaY

{-|
    This function defines the y-position of button two inside the triangle.
-}
triButtonTwoDeltaY : Float
triButtonTwoDeltaY =
    triButtonOneDeltaY / (sqrt 3 + 1)

{-|
    This function defines the y-position of button three inside the triangle.
-}
triButtonThreeDeltaY : Float
triButtonThreeDeltaY =
    triButtonOneDeltaY + triButtonOneWidth

{-|
    This function defines the y-position of button four inside the triangle.
-}
triButtonFourDeltaY : Float
triButtonFourDeltaY =
    triButtonOneDeltaY + (triButtonOneWidth / (sqrt 3 + 2))

{-|
    This function defines the width of button four inside the triangle.
-}
triButtonFourWidth : Float
triButtonFourWidth =
    (triButtonOneWidth / (sqrt 3 + 2)) * sqrt 3

{-|
    This function defines the x-position of button four inside the triangle.
-}
triButtonFourDeltaX : Float
triButtonFourDeltaX =
    triButtonOneWidth

initTriRight : Pattern -> ( Float, Float ) -> ( Float, Float ) -> Tri
initTriRight pattern ( x, y ) ( col, row ) =
    let
        index =
            col * 7 + row + 1

        color =
            getColor pattern index

        ( tCol, tRow ) =
            case floor (index / 43) of
                0 ->
                    ( floor ((index - 1) / 7) * 2 + 1, modBy 7 (round (index - 1)) * 2 + 1 )

                _ ->
                    ( (floor ((index - 84 - 1) / 7) + 1) * 2, modBy 7 (round (index - 84 - 1)) * 2 )
    in
    { pos = [ ( x, y ), ( x, y + triHeight ), ( x + triWidth, y + triHeight / 2 ) ]
    , index = index
    , colRow = ( tCol, tRow )
    , color = color
    , tdir = TRight
    , center = False
    }

{-|
    This function defines the initialization of triangles with left direction.
-}
initTriLeft : Pattern -> ( Float, Float ) -> ( Float, Float ) -> Tri
initTriLeft pattern ( x, y ) ( col, row ) =
    let
        index =
            col * 7 + row + 1

        color =
            getColor pattern index

        ( tCol, tRow ) =
            case floor (index / 43) of
                1 ->
                    let
                        nindex =
                            index - 42
                    in
                    ( floor ((nindex - 1) / 7) * 2 + 1, modBy 7 (round (nindex - 1)) * 2 )

                _ ->
                    let
                        nindex =
                            index - 42
                    in
                    ( (floor ((nindex - 84 - 1) / 7) + 1) * 2, modBy 7 (round (nindex - 84 - 1)) * 2 + 1 )
    in
    { pos = [ ( x, y ), ( x, y + triHeight ), ( x - triWidth, y + triHeight / 2 ) ]
    , index = index
    , colRow = ( tCol, tRow )
    , color = color
    , tdir = TLeft
    , center = False
    }

{-|
    This function initializes all small triangles in the pattern.
-}
initTris : Pattern -> List Tri
initTris pattern =
    List.append ( initTriOdd pattern ) ( initTriEven pattern )


initTriOdd : Pattern -> List Tri
initTriOdd pattern =
    let
        rightIndex =
            List.range 0 6

        leftIndex =
            List.range 0 6

        rightColIndex =
            List.map toFloat (List.range 0 5)

        leftColIndex =
            List.map toFloat (List.range 0 5)

        rightTris : Float -> List Tri
        rightTris k =
            List.map toFloat rightIndex
                |> List.map (\x -> initTriRight pattern ( 500 + k * 2 * triWidth, 300 + x * triHeight ) ( k, x ))

        leftTris : Float -> List Tri
        leftTris k =
            List.map toFloat leftIndex
                |> List.map (\x -> initTriLeft pattern ( 500 + (2 * k + 1) * triWidth, 300 - triHeight / 2 + x * triHeight ) ( k + 6, x ))

        oddRightTris =
            List.map (\x -> rightTris x) rightColIndex
                |> List.concat

        oddLeftTris =
            List.map (\x -> leftTris x) leftColIndex
                |> List.concat
    in
    List.append oddRightTris oddLeftTris


initTriEven : Pattern -> List Tri
initTriEven pattern =
    let
        rightIndex =
            List.range 0 6

        leftIndex =
            List.range 0 6

        rightColIndex =
            List.map toFloat (List.range 0 5)

        leftColIndex =
            List.map toFloat (List.range 0 5)

        rightTris : Float -> List Tri
        rightTris k =
            List.map toFloat rightIndex
                |> List.map (\x -> initTriRight pattern ( 500 + (2 * k + 1) * triWidth, 300 - triHeight / 2 + x * triHeight ) ( k + 2 * 6, x ))

        leftTris : Float -> List Tri
        leftTris k =
            List.map toFloat leftIndex
                |> List.map (\x -> initTriLeft pattern ( 500 + (2 * k + 2) * triWidth, 300 + x * triHeight ) ( k + 3 * 6, x ))

        oddRightTris =
            List.map (\x -> rightTris x) rightColIndex
                |> List.concat

        oddLeftTris =
            List.map (\x -> leftTris x) leftColIndex
                |> List.concat
    in
    List.append oddRightTris oddLeftTris

getColor : Pattern -> Float -> Int
getColor pattern index =
    case pattern of
        PHint ->
            getHintColor index
        PApple ->
            getAppleColor index
        PGrassRing ->
            getGrassRingColor index
        PBlueCloth ->
            getBlueClothColor index
        PLeaf ->
            getLeafColor index
        PTE1 ->
            getTE1Color index
        PTE2 ->
            getTE2Color index


getAppleColor : Float -> Int
getAppleColor index =
    let
        orange =
            Maybe.withDefault [] (List.head pieceApple)

        red =
            Maybe.withDefault [] (List.head (List.drop 1 pieceApple))

        yellow =
            Maybe.withDefault [] (List.head (List.drop 2 pieceApple))

        purple =
             Maybe.withDefault [] (List.head (List.drop 3 pieceApple))

    in
    if List.member index orange then
        1

    else if List.member index red then
        4

    else if List.member index yellow then
        5

    else if List.member index purple then
        6

    else
        0

getHintColor : Float -> Int
getHintColor index =
    let
        orange =
            Maybe.withDefault [] (List.head pieceHint)

        blue =
            Maybe.withDefault [] (List.head (List.drop 1 pieceHint))

        green =
            Maybe.withDefault [] (List.head (List.drop 2 pieceHint))

    in
    if List.member index orange then
        1

    else if List.member index blue then
        2

    else if List.member index green then
        3

    else
        0

getGrassRingColor : Float -> Int
getGrassRingColor index =
    let
        lightGreen =
            Maybe.withDefault [] (List.head pieceGrassRing)

        darkGreen =
            Maybe.withDefault [] (List.head (List.drop 1 pieceGrassRing))

        lightRed =
            Maybe.withDefault [] (List.head (List.drop 2 pieceGrassRing))


    in
    if List.member index lightGreen then
        7

    else if List.member index darkGreen then
        8

    else if List.member index lightRed then
        9

    else
        0

getBlueClothColor : Float -> Int
getBlueClothColor index =
    let
        blue =
            Maybe.withDefault [] (List.head pieceBlueCloth)

        lightPurple =
            Maybe.withDefault [] (List.head (List.drop 1 pieceBlueCloth))

        purple =
            Maybe.withDefault [] (List.head (List.drop 2 pieceBlueCloth))

        lightBlue =
             Maybe.withDefault [] (List.head (List.drop 3 pieceBlueCloth))

    in
    if List.member index blue then
        2

    else if List.member index lightPurple then
        10

    else if List.member index purple then
        6

    else if List.member index lightBlue then
        11

    else
        0

getLeafColor : Float -> Int
getLeafColor index =
    let
        lightBlue =
            Maybe.withDefault [] (List.head pieceLeaf)

        lightGreen =
            Maybe.withDefault [] (List.head (List.drop 1 pieceLeaf))

        lightRed =
            Maybe.withDefault [] (List.head (List.drop 2 pieceLeaf))

    in
    if List.member index lightBlue then
        11

    else if List.member index lightGreen then
        7

    else if List.member index lightRed then
        9

    else
        0

getTE1Color : Float -> Int
getTE1Color index =
    let
        lightPurple =
            Maybe.withDefault [] (List.head pieceTE1)

        purple =
            Maybe.withDefault [] (List.head (List.drop 1 pieceTE1))

        lightYellow =
            Maybe.withDefault [] (List.head (List.drop 2 pieceTE1))

        lightPink =
            Maybe.withDefault [] (List.head (List.drop 3 pieceTE1))

    in
    if List.member index lightPurple then
        10

    else if List.member index purple then
        6

    else if List.member index lightYellow then
        12

    else if List.member index lightPink then
        15

    else
        0

getTE2Color : Float -> Int
getTE2Color index =
    let
        yellow =
            Maybe.withDefault [] (List.head pieceTE2)

        black =
            Maybe.withDefault [] (List.head (List.drop 1 pieceTE2))

        pink =
            Maybe.withDefault [] (List.head (List.drop 2 pieceTE2))

    in
    if List.member index yellow then
        5

    else if List.member index black then
        13

    else if List.member index pink then
        14

    else
        0

{-|
    This function defines the changing of neighboring colors of after clicking one triangle.
-}
clickChangeColor : Tri -> Int -> Int -> List Tri -> List Tri
clickChangeColor clicked oldcolor ncolor tris =
    triTouchTris tris oldcolor ncolor clicked

{-|
    This function defines the changing of colors of all triangles after clicking.
-}
changeColorTris : List Tri -> Int -> Int -> List Tri
changeColorTris tris oldcolor ncolor =
    let
        centers =
            List.filter (\x -> x.center == True) tris
    in
    trisTouchTris tris oldcolor ncolor centers


trisTouchTris : List Tri -> Int -> Int -> List Tri -> List Tri
trisTouchTris all oldcolor ncolor centers =
    case centers of
        center :: rest ->
            let
                nall =
                    triTouchTris all oldcolor ncolor center
            in
            trisTouchTris nall oldcolor ncolor rest

        [] ->
            all


triTouchTris : List Tri -> Int -> Int -> Tri -> List Tri
triTouchTris tris oldcolor ncolor center =
    let
        ntris =
            List.filter (\x -> x /= center) tris

        nntris =
            List.map (triTouchTri center oldcolor ncolor) ntris
    in
    { center | center = False } :: nntris


triTouchTri : Tri -> Int -> Int -> Tri -> Tri
triTouchTri center oldcolor ncolor checked =
    let
        neighbourClickedColRow =
            neighbourIndex center

        checkedColRow =
            checked.colRow
    in
    if checked.color == oldcolor && List.member checkedColRow neighbourClickedColRow then
        { checked | color = ncolor, center = True }

    else
        checked


neighbourIndex : Tri -> List ( Int, Int )
neighbourIndex tri =
    let
        ( col, row ) =
            tri.colRow

        tdir =
            tri.tdir
    in
    case tdir of
        TRight ->
            [ ( col, row - 1 ), ( col, row + 1 ), ( col - 1, row ) ]

        TLeft ->
            [ ( col, row - 1 ), ( col, row + 1 ), ( col + 1, row ) ]

{-|
    This function judges whether the click is valid.
    If the chosen color is the same as the color of the clicked triangle, then the click is invalid.
    Otherwise, the click is valid.
-}
whetherValidClick : Int -> List Tri -> Int -> Int -> Pattern -> Bool
whetherValidClick clickedColor tris ncolor step pattern =
    List.isEmpty (List.filter (\x -> x.center == True) tris) && clickedColor /= ncolor && step < ( maxStep pattern )
