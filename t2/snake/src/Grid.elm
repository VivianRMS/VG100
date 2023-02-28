module Grid exposing (gridsize,mapsize,range2d)


gridsize : Int
gridsize =
    50


mapsize : ( Int, Int )
mapsize =
    ( 10, 10 )




range2d : ( Int, Int ) -> List ( Int, Int )
range2d size =
    let
        rangex =
            List.range 0 (Tuple.first size - 1)

        rangey =
            List.range 0 (Tuple.second size - 1)

        line =
            \y -> List.map (\x -> Tuple.pair x y) rangex
    in
    List.map line rangey
        |> List.concat





