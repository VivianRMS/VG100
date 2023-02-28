module Snake exposing (Snake,Dir(..),Movable(..),Live_status(..),headPos,headLegal,putHead,legalForward,forward,removeTail)
import Fruit exposing (..)
import Grid exposing (..)

type Dir
    = Up
    | Down
    | Left
    | Right

type Movable
    = Wall
    | Free

type Live_status
    = Alive
    | Dead

type alias Snake =
    { snake_body : List ( Int, Int )
    , snake_dir : Dir
    , snake_state : Live_status
    , score : Int
    , heart : Int
    , fruitnum : Int
    }



headPos : ( Int, Int ) -> Dir -> ( Int, Int )
headPos ( oldx, oldy ) dir =
    case dir of
        Up ->
            ( oldx, oldy - 1 )

        Down ->
            ( oldx, oldy + 1 )

        Right ->
            ( oldx + 1, oldy )

        Left ->
            ( oldx - 1, oldy )

headLegal : ( Int, Int ) -> List ( Int, Int ) -> Movable
headLegal ( x, y ) body =
    if x < 0 || x >= Tuple.first mapsize then
        Wall

    else if y < 0 || y >= Tuple.second mapsize then
        Wall

    else if List.member ( x, y ) body then
        Wall

    else
        Free

legalForward : Snake -> Fruit -> Snake
legalForward snakee fruit =
    case List.head snakee.snake_body of
        Nothing ->
            snakee

        Just oldhead ->
            let
                newhead =
                    headPos oldhead snakee.snake_dir
            in
             forward snakee newhead fruit

forward : Snake -> ( Int, Int ) -> Fruit -> Snake
forward snakee newhead fruit =
    if headLegal newhead snakee.snake_body == Wall then
        { snakee | snake_state = Dead , heart = snakee.heart - 1 }

    else if getFruit newhead fruit.fruit_pos then
        let addingscore =
                case fruit.fruit_type of
                    "apple" ->
                        50
                    "grape" ->
                        10
                    _->
                        0
        in
            {snakee | snake_body = putHead newhead snakee.snake_body , score = snakee.score + addingscore , fruitnum = snakee.fruitnum + 1 }

    else
        {snakee | snake_body =
                                snakee.snake_body
                                |> putHead newhead
                                |> removeTail
        }


putHead : ( Int, Int ) -> List ( Int, Int ) -> List ( Int, Int )
putHead newhead body =
    List.append [ newhead ] body


removeTail : List a -> List a
removeTail body =
    body
        |> List.reverse
        |> List.tail
        |> Maybe.withDefault []
        |> List.reverse
