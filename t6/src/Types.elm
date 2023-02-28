module Types exposing (..)

type Msg
    = Tick Float
    | Go Dir
    | Noop


type Dir
    = Up
    | Down


type ShipType
    = Main
    | Enemy

type State
    = Process
    | End

type alias Ship =
    { pos : ( Float, Float )
    , health : Int
    , ship_type : ShipType
    , dir : Dir
    , blast_time : Float
    }


type alias Blast =
    { pos : ( Float, Float )
    , ship_type : ShipType
    }


type alias Model =
    { ships : List Ship
    , blasts : List Blast
    , ship_time : Float
    , state : State
    }