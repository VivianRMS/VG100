module Basis exposing (HistoryBuilding(..),BirthBuilding(..),MemoryBuilding(..),LibraryBuilding(..),ClassBuilding(..),Dialogue, DialogueIndex,SchoolBuilding(..),GameKind(..),GameIdentity,GamePF(..),GameStatus,StoryLine(..),Line(..),CharacterIdentity(..),Content(..),LineEnding(..),Building(..),Page(..),Phase(..),Ending,PhotographerModel,DrawerModel,WeaverModel,TxtState(..),Item(..),LaterName(..),TEState(..),DialogueChunk,checkNumberInList,allGames)

{-| This module defines the basic data type of the whole game.

# Data types
@docs HistoryBuilding, BirthBuilding, MemoryBuilding, LibraryBuilding, ClassBuilding, 
Dialogue, DialogueIndex, SchoolBuilding, GameKind, GameIdentity, GamePF, GameStatus, StoryLine, Line,
CharacterIdentity, Content, LineEnding, Building, Page, Phase, Ending,
PhotographerModel, DrawerModel, WeaverModel, TxtState, Item,LaterName, TEState, DialogueChunk

# Functions
@docs checkNumberInList, allGames

-}

{-|
    This data type defines the game kind.
    The Klotski type is the game Klotski.
    The BallTwo type is the game Defend the fragile.
    The Color type is the game Color Union.
    The BallThree type is the game Seize the wanted.
    The BallFour type is the game Break the loop.
    The BallOne type is the game Company and love.
-}

type GameKind
    = Klotski
    | BallTwo
    | Color
    | BallThree
    | BallFour
    | BallOne

{-|
    This data type defines the game identity.
    The field page records the current page of the game.
    The field item records the items that the player has obtained.
-}


type alias GameIdentity =
    { page : Page
    , item : Item
    }

{-|
    This data type defines the state of small games.
    The Pass type is the state that the player has passed the game.
    The Fail type is the state that the player has failed when playing the game.
    The Before type is the state that the player has not played the game yet.
    
-}

type GamePF
    = Pass
    | Fail
    | Before

{-|
    This data type defines the basic status of the game.
    The field pOf records whether the player has enter the game and the game result.
    The field gamekind records the type of the game.
-}

type alias GameStatus =
    { pOf : GamePF
    , gamekind : GameKind
    }

{-|
    This data type defines the state of the current storyline that the player enters and whether the story line has been determined.
    The Undetermined type is the state that the player is still on day 1-4 and the story line hasn't been determined.
    The Determined type is the state that the game has reached day 5 and the story line has been determined.
    
-}

type StoryLine
    = Undetermined
    | Determined Line

{-|
    This data type defines the story lines in tha game.
    The BadLine type is the line leading to the bad ending.
    The CharacterLine type is line that players can interact with specific character according to their performance on day1-4.
    The TrueLine type is the line leading to the true ending.
-}

type Line
    = BadLine
    | CharacterLine CharacterIdentity
    | TrueLine

{-|
    This data type defines the identity of the character.
    The Drawer type is the character drawer.
    The Weaver type is the character weaver.
    The Photographer type is the character photographer.
-}

type CharacterIdentity
    = Drawer
    | Weaver
    | Photographer

{-|
    This data type defines the number of the contents in the dialogue.
    The A type refers to the content A.
    The B type refers to the content B.
    The C type refers to the content C.
    The D type refers to the content D.
    The E type refers to the content E.
    The F type refers to the content F.
    The G type refers to the content G.
    The H type refers to the content H.
    The I type refers to the content I.
-}

type Content
    = A
    | B
    | C
    | D
    | E
    | F
    | G
    | H
    | I

{-|
    This data type defines state about whether the player has reached the ending.
    The NotReached type is the state that the player has not reached the ending.
    The Reached type is the state that the player has reached certain the ending.
-}

type LineEnding
    = NotReached
    | Reached Ending

{-|
    This data type defines building type.
    The PhotoStudio type refers to the photostudio.
    The Library type refers to the library.
    The School type refers to the school.
    The Church type refers to the church.
    The Apartment type refers to the apartment.
    The Lawn type refers to the lawn.
    The Artmuseum type refers to the artmuseum.
    The Square type refers to the square.

-}

type Building
    = PhotoStudio
    | Library LibraryBuilding
    | School SchoolBuilding
    | Church
    | Apartment
    | Lawn
    | ArtMuseum
    | Square
    
{-|
    This data type defines the rooms inside the school.
    The Classroom type refers to the classroom.
    The Artroom type refers to the artroom.
    The Historyroom type refers to the historyroom.

-}

type SchoolBuilding
    = Classroom ClassBuilding
    | Artroom
    | Historyroom
    | SchoolNone
    
{-|
    This data type defines the rooms inside the library.
    The History type refers to the floor of history.
    The Memory type refers to the floor of gold memory.
    The Birth type refers to the floor of birth.
    The LibraryNone type is the interface of library for players to choose floor.

-}

type LibraryBuilding
    = History HistoryBuilding
    | Memory MemoryBuilding
    | Birth BirthBuilding
    | LibraryNone

{-|
    This data type defines the building in the part memory in the library.
-}

type MemoryBuilding
    = AlbumBuild
    | MemoryNone
    | OtherAlbum
{-|
    This data type defines the building in the part history in the library.
-}


type HistoryBuilding
    = HistoryBuild
    | HistoryNone
    | OtherHisAlbum
{-|
    This data type defines the building in the part birth in the library.
-}

type BirthBuilding
    = BirthBuild
    | BirthNone
    | OtherBirAlbum

{-|
    This data type provides the page of the paint brush for riddle solving.
-}
type ClassBuilding
    = BrushBuild
    | ClassNone

{-|
    This data type controls the page of the game that the player is in.
-}
type Page
    = Map
    | BuildingPage Building
    | GamePage GameKind
    | PersonPage CharacterIdentity Phase Content 
    | EndingPage
    | ItemPage
    | NonePage
    | ExhaustedPage
    | LogoPage
    | HintPage
    | AlbumPage
    | InstructionPage
    | ThanksPage
    

{-|
    This data type defines which chunk of dialogue contents will be loaded.
-}

type Phase
    = P1
    | P2
    | P3


{-|
    This data type defines an ending in the game.
-}
type alias Ending =
    { line : Line
    , result : Bool
    }

{-|
    This data type contains information for photographer line.
-}
type alias PhotographerModel =
    { leftFragments : List Int
    , getFragments : List Int
    , getItems : List Item
    , getTxtClues : List Content
    , albumTxt : String
    , isTxtRight : TxtState
    , passed : Bool
    , gamestatusk : GameStatus
    , gamestatusb2 : GameStatus
    }


{-|
    This data type contains information for drawer line.
-}
type alias DrawerModel =
    { getItems : List Item
    , getTxtClues : List Content
    , passed : Bool
    , gamestatusb3 : GameStatus
    , isTxtRight : TxtState
    , brushTxt : String
    }

{-|
    This data type contains information for weaver line.
-}
type alias WeaverModel =
    { getItems : List Item
    , getTxtClues : List Content
    , nextday : Bool
    , churchTxt : String
    , isTxtRight : TxtState
    , passed : Bool
    , gamestatusb4 : GameStatus
    }

{-|
    This data type defines whether the input of a text field is right.
-}
type TxtState
    = Right
    | Wrong
    | No

{-|
    This data type includes the items in the game.
-}
type Item
    = Apple
    | Pencil
    | Drawing Int
    | DrawingLater LaterName
    | BlueCloth
    | BlueClothFrag
    | GrassRing
    | AlbumClue


{-|
    This data type defines which photo the painter will draw.
-}

type LaterName
    = Portrait
    | Pastmemory

{-|
    This data type defines whether the true ending has been reached.
-}
type TEState
    = TENotReach
    | TEJudge
    | TEInProg

{-|
    This data type defines a single dialogue in the game.
-}
type alias Dialogue = 
    {
        character : String,
        content : String
    }

{-|
    This data type gives an index to a given dialogue.
-}
type alias DialogueIndex = 
    {   
        character : CharacterIdentity
        , phase : Phase
        , content : Content
    }
{-|
    This data type combines a dialogue with its index to give a complete dialogue for use.
-}
type alias DialogueChunk =
    {
        index : DialogueIndex
        , contents : List Dialogue   
    }
{-|
    This functions check whether an element is in the list.
-}
checkNumberInList : List a -> a -> Bool
checkNumberInList list obj =
    let
        num =
            List.filter (\x -> x == obj) list
                |> List.length
    in
    if num <= 0 then
        False

    else
        True

{-|
    This list lists all the small games.
-}
allGames : List GameKind
allGames =
    [Klotski,BallTwo,Color,BallThree,BallFour,BallOne]
