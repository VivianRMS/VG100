module Ball_Three.Init exposing (initB_ThrSubmodel, initBrick,initBricks,initCloth,initScore)
{-| This module defines initialization fuction in the game Seize the wanted.

# Initialization functions
@docs initB_ThrSubmodel, initBrick,initBricks,initCloth,initScore

-}
import Ball_Three.Color exposing (red,ColorInfo,Color)
import Ball_Three.Message exposing (BallThreeUserMsg(..), ColorType(..), Group(..), ModelMsgBallThree(..))
import Ball_Three.Model exposing (B_ThrSubmodel,Cloth,Brick, Score, BriState(..), ClothState(..), GameState(..), PatternValid(..), Pattern(..))
import Basis exposing (GameIdentity,Page(..),Item(..))
import Random


{-|
    This function is the initialization of a ball3's submodel.
    With input of the initialization of the cloth, the bricks, the score, the pattern,
    the page where the player enters the game and the item the game may carry, the B_ThrSubmodel is initialized.

-}

initB_ThrSubmodel : Page -> Item -> Bool -> B_ThrSubmodel
initB_ThrSubmodel page item te =
    let
        identity =
            GameIdentity page item
        modelA = B_ThrSubmodel initCloth initBricks initScore ( 160, 90 ) 1 Dark
    in
    modelA ( State_Start ValidPattern ) 3 identity Pattern1 0 red te

{-|
    This function initializes basic status of the cloth.
   
-}

initCloth : Cloth
initCloth =
    Cloth ( 80, 10 ) 30 30 Static

{-|
    This function initializes basic status of bricks.
   
-}

initBricks : List Brick
initBricks =
    [ initBrick ]

{-|
    This function initializes basic status of one brick.
   
-}

initBrick : Brick
initBrick =
    Brick 10 10 initColor ( 80, 70 ) 1 ( 0, 0 ) 0 Empty


initColor : ColorInfo
initColor =
    ColorInfo (Color 0 0 0) None Dark

{-|
    This function initializes basic status of the score.
   
-}
initScore : Score
initScore =
    Score ( 0, 0 ) ( 0, 0 ) ( 0, 0 )

