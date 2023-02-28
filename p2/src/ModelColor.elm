module ModelColor exposing (initCmodel,CSubmodel)
{-| This module defines the submodel type for the game Color Union and the Color Union initialization function.

# Submodel types
@docs CSubmodel

# Initialization function
@docs initCmodel
-}
import Basis exposing (Page(..),GameIdentity,Item(..))
import Color exposing (Tri,CResult,CState,Pattern(..),initTris,CResult(..))

{-|
    This data type defines the submodel for the game Color Union.
    The field tris is a list of all triangles in the pattern.
    The field result records the result of the whole game.
    The field oldColor records the last chosen color.
    The field nColor records the newly chosen color.
    The field colors records a list of colors specified for the pattern.
    The field step records how many steps the player has used.
    The field state records the game status.
    The field chance records how many chances the player has used.
    The field pattern records the kind of Klotski.
    The field identity records the page where the start game button is placed and the item this game may carry.
    The field te records whether the game shows up in the true ending line.

-}
type alias CSubmodel =
    { tris : List Tri
    , result : CResult
    , oldColor : Int
    , nColor : Int
    , colors : List Int
    , step : Int
    , state : CState
    , chance : Int
    , identity : GameIdentity
    , pattern : Pattern
    , te : Bool
    }

{-|
    This function is the initialization of a CSubmodel.
    With input of the pattern, the item the game may carry, the game status,
    the page where the player enters the game and whether the game now shows up in the true ending line,
    the CSubmodel is initialized.

-}
initCmodel : Page -> Item -> CState -> Pattern -> Bool -> CSubmodel
initCmodel page item state pattern te =
    let
        inittris =
            initTris pattern

        colors =
            case pattern of
                PHint ->
                    [1,2,3]
                PApple ->
                    [1,4,5,6]
                PGrassRing ->
                    [7,8,9]
                PBlueCloth ->
                    [2,10,6,11]
                PLeaf ->
                    [11,7,9]
                PTE1 ->
                    [10,6,12,15]
                PTE2 ->
                    [5,13,14]

        ncolor=
                Maybe.withDefault 0 (List.head colors)

        identity =
            GameIdentity page item
    in
    CSubmodel inittris CUndetermined 1 ncolor colors 0 state 4 identity pattern te
