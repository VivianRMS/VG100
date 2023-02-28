module Ball_Three.Color exposing (red,blue,green,yellow,purple,lightblue,ColorInfo,Color,getColor)
{-| This module defines basic colors and data types for color in the game Seize teh wanted.

# Data types
@docs ColorInfo, Color

# Function to define color
@docs getColor, red, blue, green, yellow, purple, lightblue
-}

import Ball_Three.Message exposing (ColorType(..), Group(..))
import String exposing (fromFloat)

{-|
    This data type records the information of the color.
    The field color is the color of the color block.
    The field pair is the group the color block is in.
    The field category records color type of the block's color. 

-}

type alias ColorInfo =
    { color : Color
    , pair : Group
    , category : ColorType
    }

{-|
    This data type records the rgb parameter for color
    The field r is the value of r parameter.
    The field g is the value of g parameter.
    The field b is the value of b parameter.

-}

type alias Color =
    { r : Float
    , g : Float
    , b : Float
    }


{-|
    This function is for defining color red.

-}
red : Color
red =
    Color 204 0 0

{-|
    This function is for defining color yellow.

-}
yellow : Color
yellow =
    Color 255 178 102

{-|
    This function is for defining color green.

-}
green : Color
green =
    Color 0 102 0
{-|
    This function is for defining color lightblue.

-}
lightblue : Color
lightblue =
    Color 0 204 204
{-|
    This function is for defining color blue.

-}

blue : Color
blue =
    Color 0 0 153
{-|
    This function is for defining color purple.

-}

purple : Color
purple =
    Color 204 153 255

{-|
    This function is for defining color information according to its group number and color type.

-}
getColor : ( Int, ColorType ) -> ColorInfo
getColor ( x, y ) =
    case ( x, y ) of
        ( 1, Dark ) ->
            ColorInfo red Red Dark

        ( 1, Light ) ->
            ColorInfo yellow Red Light

        ( 2, Dark ) ->
            ColorInfo green Green Dark

        ( 2, Light ) ->
            ColorInfo lightblue Green Light

        ( 3, Dark ) ->
            ColorInfo blue Blue Dark

        ( 3, Light ) ->
            ColorInfo purple Blue Light

        _ ->
            ColorInfo (Color 0 0 0) Red Dark


showcolor : Color -> String
showcolor color =
    let
        r =
            fromFloat color.r

        g =
            fromFloat color.g

        b =
            fromFloat color.b
    in
    "rgb(" ++ r ++ "," ++ g ++ "," ++ b ++ ")"
