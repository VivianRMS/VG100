module Fruit exposing (fruitGen,getFruit,fruit_kindGen,Fruit)
import Grid exposing (..)

import Random

type alias Fruit =
    { fruit_pos : ( Int, Int )
    , fruit_type : String
    }

fruitGen : Random.Generator ( Int, Int )
fruitGen =
    Random.pair (Random.int 0 (Tuple.first mapsize - 1)) (Random.int 0 (Tuple.second mapsize - 1))

getFruit : ( Int, Int ) -> ( Int, Int ) -> Bool
getFruit head fruit =
    fruit == head

fruit_kindGen : Random.Generator Int
fruit_kindGen =
    Random.int 0 4

