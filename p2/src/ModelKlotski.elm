module ModelKlotski exposing (KSubmodel, initKmodel)

{-| This module defines the submodel type for the game Klotski and the Klotski initialization function.

# Submodel types
@docs KSubmodel

# Initialization function
@docs initKmodel
-}

import Basis exposing (GameIdentity,Page(..),Item(..))
import Klotski exposing (Cell,KResult(..),KState,KlotskiKind,initCells)

{-|
    This data type defines the submodel for the game Klotski.
    The field cells is a list of all eight cells.
    The field result records the result of the whole game.
    The field state records the game status.
    The field chance records how many chances the player has used.
    The field nOrp records the kind of Klotski.
    The field identity records the page where the start game button is placed and the item this game may carry.

-}

type alias KSubmodel =
    { cells : List Cell
    , result : KResult
    , state : KState
    , chance : Int
    , nOrp : KlotskiKind
    , identity : GameIdentity
    }

{-|
    This function is the initialization of a KSubmodel.
    With input of the Klotski kind, the list of initial random order indexes, the game status, the chances the player has
    used, the page where the player enters the game and the item the game may carry, the KSubmodel is initialized.

-}

initKmodel : KlotskiKind -> List Int -> KState -> Int -> Page -> Item -> KSubmodel
initKmodel kind orderList kstate chance page item =
    let
        initcells =
            initCells orderList
        initidentity =
            GameIdentity page item
    in
    KSubmodel initcells KUndetermined kstate chance kind initidentity
