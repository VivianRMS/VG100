module Ball_Three.Model exposing (B_ThrSubmodel,Cloth,Point,Brick, Score, BriState(..), ClothState(..), GameState(..), PatternValid(..), Pattern(..))
{-| This module defines the submodel type for the game Company and Love.

# Submodel types
@docs B_ThrSubmodel

# Other Datatypes
@docs Cloth, Point, Brick, Score, BriState, ClothState, GameState, PatternValid, Pattern

-}
import Ball_Three.Color exposing (ColorInfo)
import Ball_Three.Message exposing (ColorType(..))
import Msg exposing (KeyInput)
import Basis exposing (GameIdentity,Page(..),Item(..))
import Ball_Four.Ball_Four exposing (Pattern(..))
import Ball_Three.Color exposing (Color)

{-|
    This data type defines the submodel for the game Seize the wanted.

    The field cloth records the information of the white cloth.
    The field bricks records the information of the moving color bricks.
    The field score records the score of each round.
    The field boundary records the boundar of the moving color bricks.
    The field time acts as a timer to control the whole process.
    The field colorNeed_P1 records the color wanted in Pattern 1.
    The field gamestate records the game status.
    The field round records the current round of the whole game.
    The field identity records the page where the start game button is placed and the item this game may carry.
    The field pattern records the kind of ball three.
    The field total_score records the score of the whold game.
    The field colorNeed_P1 records the color wanted in Pattern 2.
    The field te records whether the big game enters TE line.  

        Eg. B_ThrSubmodel cloth bricks score ( 160, 90 ) 1 Dark ( State_Start ValidPattern ) 3 identity Pattern1 0 red te
-}
type alias B_ThrSubmodel =
    { cloth : Cloth
    , bricks : List Brick
    , score : Score
    , boundary : ( Float, Float )
    , time : Int --time to control the whole process
    , colorNeed_P1 : ColorType
    , gamestate : GameState
    , round : Int
    , identity : GameIdentity
    , pattern : Pattern
    , total_score : Int
    , colorNeed_P2 : Color
    , te : Bool
    }

{-|
    This data type records the information of the white cloth.

    The field anchor records the position of the cloth.
    The field width records the width of the cloth.
    The field heigth records the height of the cloth.
    The field state records the current status of the cloth.
    
        Eg. Cloth ( 80, 10 ) 30 30 Static
-}
type alias Cloth =
    { anchor : Point
    , width : Float
    , height : Float
    , state : ClothState
    }

{-|
    This data type defines the way to express the position. 
-}
type alias Point =
    ( Float, Float )

{-|
    This data type records the information of the one color brick.


    The field width records the width of the brick.
    The field heigth records the height of the brick.
    The field color records the color of the brick.
    The field anchor records the position of the brick.
    The field scale records the scale for the change of brick's height 
    and width during its movement.
    The field dir records the direction of the brick.
    The field time records the time the brick moves.
    The field state records the current status of the brick.
    
        Eg. Brick 10 10 color ( 80, 70 ) 1 ( 0, 0 ) 0 Empty
-}
type alias Brick =
    { width : Float
    , height : Float
    , color : ColorInfo
    , anchor : Point
    , scale : Float
    , dir : Point
    , time : Float
    , state : BriState
    }

{-|
    This data type records the score of the game.

    The field pair1 means the score of Red and Yellow bricks. (in order)
    The field pair2 means the score of Green and Lightblue bricks. (in order)
    The field pair3 means the score of Blue and Purple bricks. (in order)
-}
type alias Score =
    { pair1 : ( Int, Int )
    , pair2 : ( Int, Int )
    , pair3 : ( Int, Int )
    }

{-|
    This data type records the state of one brick.

    Empty means the brick hasn't been moving.
    Play means the brick is moving on the screen.
    Get means the brick is seized by the white cloth.

-}
type BriState
    = Empty -- has no random dir
    | Play -- in motion
    | Get

{-|
    This data type records the state of the white cloth.

    Moving means the cloth is moving its position.
    Static means the cloth is not moving.

-}
type ClothState
    = Moving KeyInput
    | Static

{-|
    This data type defines the state of the game ball three.

    Interval means the game is in the interval between two rounds.
    Win means the whole game is passed.
    Lose means the whole game is failed.
    State_Start means the game is in the intro page.
    State_Pause means the game is paused.
    State_Play means the game is being played.  
    ActNotEnough means the action points of the model is not enough
    to enter this game.
-}
type GameState
    = Intervalb3
    | Win
    | Lose
    | State_Start PatternValid
    | State_Pause
    | State_Play
    | ActNotEnough

{-|
    This data type defines whether the game has different patterns
    for players to choose.
    
    ValidPattern means different types of game can be chosen.
    InvalidPattern means the type is the default one.
-}  
type PatternValid =
    ValidPattern
    | InvalidPattern

{-|
    This data type records the pattern of the game ball one.

    Pattern1 means the player needs to seize three wanted bricks.
    Pattern2 means the player needs to seize as the guidance.

    
-}
type Pattern
 = Pattern1
 | Pattern2
