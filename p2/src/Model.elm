module Model exposing (Model)
{-|
  This module defines the model of our game.
# Main Model
@docs Model
-}

import Ball_Four.Model exposing (BFourModel)
import Ball_One.Model exposing (B_OneSubmodel)
import Ball_Three.Model exposing (B_ThrSubmodel)
import Ball_Two.Model exposing (BTwoModel)
import Basis exposing (TEState(..), DrawerModel, Ending, Line(..), LineEnding, Page, PhotographerModel, StoryLine(..), WeaverModel,DialogueChunk)
import ModelColor exposing (CSubmodel)
import ModelKlotski exposing (KSubmodel)

{-|
  This type defnes the main model of the game.
-}
type alias Model =
    { day : Int
    , actionpoints : Int
    , storyline : StoryLine
    , passedEnding : List Ending
    , currentEnding : LineEnding
    , currentPage : Page
    , lastPage : Page
    , nextPersonPage : Page
    , photographerModel : PhotographerModel
    , drawerModel : DrawerModel
    , weaverModel : WeaverModel
    , kmodel : KSubmodel
    , b2model : BTwoModel
    , cmodel : CSubmodel
    , b3model : B_ThrSubmodel
    , b4model : BFourModel
    , b1model : B_OneSubmodel
    , gsPoint : Float
    , startTE : TEState
    , time : Float
    , size : (Float,Float)
    , texts : List DialogueChunk
    }
