module Klotski exposing (KlotskiKind(..),KState(..),KResult(..),Cell,initCells,moveCell,initRandomOrder,initRandomOrderIndex)
{-| This module defines basic data types and functions for the game Klotski.

# Data types
@docs KlotskiKind, KState, KResult,Cell

# Initialization functions
@docs initCells, initRandomOrder, initRandomOrderIndex

# Operation functions
@docs moveCell

-}

import Random

{-|
    This data type determines different kinds of Klotski in different scenes.
    The Number type is in Library's Guide floor.
    The BookNumber type is at the librarian on Library's gold memory floor.
    The Cloth type is in the history room. It will shows up after the player gets hint from the weaver in the church.
    The Undecided type is the basic initialization type.

-}

type KlotskiKind
    = Number
    | BookNumber
    | Photo
    | Cloth
    | Undecided

{-|
    This data type includes different game status.
    The KBefore is at the very beginning of the game.
    The KPrepare is when the initial random order is determined.
    The KShow is when the correct index order or photo fragment order is shown to the player.
    The KPlaying is after the game starts.
    The KGiveUp is when the player chooses to give up.
    The KEnd is after the game result is determined.

-}

type KState
    = KPrepare
    | KPlaying
    | KEnd
    | KBefore
    | KShow
    | KGiveUp

{-|
    This data type includes different game results.
    The KVictory is when the player succeeds.
    The KFailure is when the player loses.
    The KUndetermined is when the game result has not been decided yet.

-}

type KResult
    = KVictory
    | KFailure
    | KUndetermined

{-|
    This data type is for one cell of the eight cells.
    The pos records the position of the cell on the screen.
    The standardActualIndex records the index seen by the audience and their position in the whole board.

-}

type alias Cell =
    { pos : ( Float, Float )
    , standardActualIndex : ( Int, Int )
    }

createCoordinate : Float -> Float -> ( Float, Float )
createCoordinate x y =
    ( x, y )


initCellY : Float -> List ( Float, Float )
initCellY x =
    List.range 1 3
    |> List.map ((*) 280)
    |> List.map ((+) 268)
    |> List.map toFloat
    |> List.map (createCoordinate x)
    |> List.map (\( a, b ) -> ( b, a ))


initCellX : List ( Float, Float )
initCellX =
    List.range 1 3
    |> List.map ((*) 173)
    |> List.map toFloat
    |> List.map ((+) 130)
    |> List.map initCellY
    |> List.concat

{-|
    This function inits all the eight cells' positions.
    And this function inits the initial random indexes and their actual position indexes of eight cells.

-}

initCells : List Int -> List Cell
initCells orderList =
    let
        standardActualIndex =
            List.indexedMap Tuple.pair orderList

        posIndex =
            List.map2 Tuple.pair initCellX standardActualIndex
    in
    List.map (\( pos, index ) -> Cell pos index) posIndex

{-|
    This function determines whether the player can move the cell he clicks.
    And if valid, the cell will be moved to the nearby blank cell.

-}

moveCell : List Cell -> Cell -> List Cell
moveCell cells movedCell =
    let
        noZeroMovedCells =
            List.filter (\x -> x /= movedCell && Tuple.second x.standardActualIndex /= 0) cells

        zero =
            List.filter (\x -> Tuple.second x.standardActualIndex == 0) cells
                |> List.take 1

        zeroCell =
            case zero of
                [ zerocell ] ->
                    zerocell

                _ ->
                    Cell ( 0, 0 ) ( 10, 10 )

        ( nCellOne, nCellTwo ) =
            exchangeCell ( zeroCell, movedCell )
    in
    List.append noZeroMovedCells [ nCellOne, nCellTwo ]


exchangeCell : ( Cell, Cell ) -> ( Cell, Cell )
exchangeCell ( aCell, bCell ) =
    let
        ( aCell_X, aCell_Y ) =
            aCell.pos

        ( bCell_X, bCell_Y ) =
            bCell.pos
    in
    if aCell_X == bCell_X then
        if abs (aCell_Y - bCell_Y) <= 173 then
            ( { aCell | standardActualIndex = ( Tuple.first aCell.standardActualIndex, Tuple.second bCell.standardActualIndex ) }
            , { bCell | standardActualIndex = ( Tuple.first bCell.standardActualIndex, Tuple.second aCell.standardActualIndex ) }
            )

        else
            ( aCell, bCell )

    else if aCell_Y == bCell_Y then
        if abs (aCell_X - bCell_X) <= 280 then
            ( { aCell | standardActualIndex = ( Tuple.first aCell.standardActualIndex, Tuple.second bCell.standardActualIndex ) }
            , { bCell | standardActualIndex = ( Tuple.first bCell.standardActualIndex, Tuple.second aCell.standardActualIndex ) }
            )

        else
            ( aCell, bCell )

    else
        ( aCell, bCell )


allOrderList : List (List Int)
allOrderList =
    [ [ 1, 8, 7, 4, 5, 2, 6, 3, 0 ]
    , [ 3, 5, 1, 7, 2, 4, 6, 8, 0 ]
    , [ 3, 1, 6, 7, 0, 4, 5, 2, 8 ]
    , [ 2, 3, 1, 0, 5, 4, 6, 8, 7 ]
    , [ 5, 4, 6, 8, 1, 2, 3, 0, 7 ]
    , [ 1, 8, 3, 7, 4, 2, 5, 6, 0 ]
    , [ 1, 3, 0, 5, 8, 7, 2, 4, 6 ]
    , [ 0, 7, 5, 1, 4, 2, 8, 3, 6 ]
    , [ 7, 5, 8, 2, 6, 4, 3, 1, 0 ]
    , [ 2, 8, 7, 4, 0, 3, 6, 5, 1 ]
    ]

{-|
    This function gives the initial random order of eight cells depending on the input number,
    which corresponds to one order in the ten different initial orders.

-}

initRandomOrder : Int -> List Int
initRandomOrder n =
    Maybe.withDefault [] (List.head (List.drop n allOrderList))

{-|
    This function is an int random generator.
    It randomizes a number from zero to nine, deciding which order the initial eight cells will have.

-}

initRandomOrderIndex : Random.Generator Int
initRandomOrderIndex =
    Random.int 0 9

