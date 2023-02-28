module Tetriminos exposing (random)

import Color exposing (Color)
import Grid exposing (Grid)
import Random


random : Random.Seed -> ( Grid Color, Random.Seed )
random seed =
    let
        (color , nseed) = randomColor seed
        number =
            Random.int 0 (List.length ( tetriminos color ) - 1)

        tetrimino n =
            Maybe.withDefault Grid.empty (List.head (List.drop n ( tetriminos color )))
    in
    Random.step (Random.map tetrimino number) nseed

randomColor : Random.Seed -> ( Color , Random.Seed )
randomColor seed0 =
    let
        (red, seed1) = Random.step (Random.int 60 300) seed0
        (green, seed2) = Random.step (Random.int 60 300) seed1
        (blue, seed3) = Random.step (Random.int 60 300) seed2
      in
        ( Color.rgb red green blue, seed3 )

tetriminos : Color -> List (Grid Color)
tetriminos color =
    List.map
        (\( a, b ) -> Grid.fromList a b)
        [ ( color, [ ( 0, 0 ), ( 1, 0 ), ( 2, 0 ), ( 3, 0 ) ] )
        , ( color, [ ( 0, 0 ), ( 1, 0 ), ( 0, 1 ), ( 1, 1 ) ] )
        , ( color, [ ( 1, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ) ] )
        , ( color, [ ( 0, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ) ] )
        , ( color, [ ( 2, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ) ] )
        , ( color, [ ( 1, 0 ), ( 2, 0 ), ( 0, 1 ), ( 1, 1 ) ] )
        , ( color, [ ( 0, 0 ), ( 1, 0 ), ( 1, 1 ), ( 2, 1 ) ] )
        , ( color, [ ( 0, 0 ), ( 0, 1 ), ( 1, 1 ), ( 0, 2 ) ] )
        , ( color, [ ( 0, 0 ), ( 1, 0 ), ( 1, 1 ), ( 2, 0 ) ] )
        , ( color, [ ( 0, 0 ), ( 1, 0 ), ( 0, 1 ), ( 0, 2 ) ] )
        ]
