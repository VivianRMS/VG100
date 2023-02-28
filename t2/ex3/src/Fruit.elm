module Fruit exposing (fruitGen,getFruit)
import Grid exposing (..)

import Random

fruitGen : Random.Generator ( Int, Int )
fruitGen =
    Random.pair (Random.int 0 (Tuple.first mapsize - 1)) (Random.int 0 (Tuple.second mapsize - 1))

getFruit : ( Int, Int ) -> ( Int, Int ) -> Bool
getFruit head fruit =
    fruit == head

