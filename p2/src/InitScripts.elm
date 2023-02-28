module InitScripts exposing (initScript,textPhotoP2,textDrawerP2, textWeaverP2, textWeaverP1)
{-|
    This module init all scripts at the beginning.

# View Scripts Functions
@docs initScript,textPhotoP2,textDrawerP2, textWeaverP2, textWeaverP1

-}
import Basis exposing (DialogueIndex)
import Basis exposing (Content(..))
import Basis exposing (DialogueChunk)
import Basis exposing (Dialogue)
import Basis exposing (DialogueIndex, CharacterIdentity(..), Phase(..), Content(..))

{-|
    This function initializes all scripts.
-}
initScript : List DialogueChunk
initScript  =
    textPhoto ++ textDrawer ++ textWeaver

textPhoto : List DialogueChunk 
textPhoto =
    textPhotoP1 ++ textPhotoP2 ++ textPhotoP3

textPhotoP1 : List DialogueChunk
textPhotoP1 =
    [textPhotoP1A, textPhotoP1B, textPhotoP1C, textPhotoP1D]



textPhotoP1A : DialogueChunk
textPhotoP1A =
    let
        index = DialogueIndex Photographer P1 A
        dialogue1 = Dialogue "Photographer" "Welcome, buy film or take photos?"
        dialogue2 = Dialogue "Player" "Hi, I'm Lee's friend. He told me to find you just before he died."
        dialogue3 = Dialogue "Photographer" "Sorry, but I don't remember him."
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3]
    
textPhotoP1B : DialogueChunk
textPhotoP1B =
    let
        index = DialogueIndex Photographer P1 B
        dialogue1 = Dialogue "Photographer" "Welcome, buy film or take photos?"
        dialogue2 = Dialogue "Player" "Lee told me that you knew a lot about memories, what caused his death?"
        dialogue3 = Dialogue "Photographer" "Sorry, I need the fragments to recall the past. Can you find them?"
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3]


textPhotoP1C : DialogueChunk
textPhotoP1C =
    let
        index = DialogueIndex Photographer P1 C
        dialogue1 = Dialogue "Photographer" "Welcome, have you brought me anything?"
        dialogue2 = Dialogue "Player" "(give the fragments)"
        dialogue3 = Dialogue "Photographer" "But they are just fragments."
        dialogue4 = Dialogue "Photographer" "Go to the library to find a clue!"
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3,dialogue4]

textPhotoP1D : DialogueChunk
textPhotoP1D =
    let
        index = DialogueIndex Photographer P1 D
        dialogue1 = Dialogue "Photographer" "Welcome, have you brought me anything?"
        dialogue2 = Dialogue "Player" "(give fragments and clue)"
        dialogue3 = Dialogue "Photographer" "That's enough. Let's extract memories."
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3]


{-|
    This function initializes the scipts of photographer in day 5-7.
-}
textPhotoP2 : List DialogueChunk
textPhotoP2 =
    [textPhotoP2A, textPhotoP2B,textPhotoP2C,textPhotoP2D,textPhotoP2E,textPhotoP2F,textPhotoP2G, textPhotoP2H]

textPhotoP2A : DialogueChunk
textPhotoP2A =
    let
        index = DialogueIndex Photographer P2 A
        dialogue1 = Dialogue "Photographer" "Welcome, have you brought me anything?"
        dialogue2 = Dialogue "Player" "(give fragments and clue)"
        dialogue3 = Dialogue "Photographer" "Could you help me piece fragments together?"
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3]

textPhotoP2B : DialogueChunk
textPhotoP2B =
    let
        index = DialogueIndex Photographer P2 B
        dialogue1 = Dialogue "Photographer" "Oh my God! The painful operating room! Please leave me alone."
    in
        DialogueChunk index [dialogue1]


textPhotoP2C : DialogueChunk
textPhotoP2C =
    let
        index = DialogueIndex Photographer P2 C
        dialogue1 = Dialogue "Photographer" "Try again next day!"
    in
        DialogueChunk index [dialogue1]

textPhotoP2D : DialogueChunk
textPhotoP2D =
    let
        index = DialogueIndex Photographer P2 D
        dialogue1 = Dialogue "Photographer" "I saw Lee's death. And also, many other friends'."
        dialogue2 = Dialogue "Photographer" "How could I forget everything about them! How could I return to yesterday's painless life!"
        dialogue3 = Dialogue "Photographer" "I don't want others to taste such pain!"
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3]

textPhotoP2E : DialogueChunk
textPhotoP2E =
    let
        index = DialogueIndex Photographer P2 E
        dialogue1 = Dialogue "Player" "Don't escape reality! Hold memories! They are part of life!"
        dialogue2 = Dialogue "Photographer" "I understand. Let me spend tonight recalling all lost memories."
    in
        DialogueChunk index [dialogue1,dialogue2]

textPhotoP2F : DialogueChunk
textPhotoP2F =
    let
        index = DialogueIndex Photographer P2 F
        dialogue1 = Dialogue "Player" "..."
        dialogue2 = Dialogue "Photographer" "Let the past be the past. It's good for everyone."
    in
        DialogueChunk index [dialogue1,dialogue2]

textPhotoP2G : DialogueChunk
textPhotoP2G =
    let
        index = DialogueIndex Photographer P2 G
        dialogue1 = Dialogue "Photographer" "Welcome, these are the town’s lost memories."
        dialogue2 = Dialogue "Photographer" "To combat SummerSara, ask the time guardian for help to weave memory pictures onto time ribbon."
        dialogue3 = Dialogue "Photographer" "But first find the painter to create memory pictures."
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3]

textPhotoP2H : DialogueChunk
textPhotoP2H =
    let
        index = DialogueIndex Photographer P2 H
        dialogue1 = Dialogue "Photographer" "My friend. Keep memories and help everyone recover memories!"
    in
        DialogueChunk index [dialogue1]

textPhotoP3 : List DialogueChunk
textPhotoP3 =
    [textPhotoP3A]

textPhotoP3A : DialogueChunk
textPhotoP3A =
    let
        index = DialogueIndex Photographer P3 A
        dialogue1 = Dialogue "Photographer" "Welcome, have we seen each other before?"
        dialogue2 = Dialogue "Player" "I'm Lee's friend. Nice to meet you.'"
        dialogue3 = Dialogue "Photographer" "My friend, you must be tired, relax and enjoy the game!"
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3]


textDrawer : List DialogueChunk
textDrawer =
    List.concat [ textDrawerP1 , textDrawerP2 , textDrawerP3 ]

textDrawerP1 : List DialogueChunk
textDrawerP1 =
    [textDrawerP1A,textDrawerP1B,textDrawerP1C]

{-|
    This function initializes the scipts of drawer in day 5-7.
-}
textDrawerP2 : List DialogueChunk
textDrawerP2 =
    [textDrawerP2A,textDrawerP2B,textDrawerP2C,textDrawerP2D,textDrawerP2E,textDrawerP2F,textDrawerP2G]

textDrawerP3 : List DialogueChunk
textDrawerP3 = [textDrawerP3A]

textDrawerP1A : DialogueChunk
textDrawerP1A =
    let
        index = DialogueIndex Drawer P1 A
        dialogue1 = Dialogue "Drawer" "..."
        dialogue2 = Dialogue "Player" "Hello? What's up?"
        dialogue3 = Dialogue "Drawer" "Hi, could you please find my paintbrush?"
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3]

textDrawerP1B : DialogueChunk
textDrawerP1B =
    let
        index = DialogueIndex Drawer P1 B
        dialogue1 = Dialogue "Drawer" "Hi, have you brought me anything?"
        dialogue2 = Dialogue "Player" "(give paintbrush)"
        dialogue3 = Dialogue "Drawer" "I will draw you a portrait to express thanks."
        dialogue4 = Dialogue "Drawer" "The portrait is colorless! Could you find paint for me?"
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3,dialogue4]

textDrawerP1C : DialogueChunk
textDrawerP1C =
    let
        index = DialogueIndex Drawer P1 C
        dialogue1 = Dialogue "Drawer" "Hi, my friend. Have you brought me anything?"
        dialogue2 = Dialogue "Player" "(give pigments)"
        dialogue3 = Dialogue "Drawer" "These sacred pigments are so bright!"
        dialogue4 = Dialogue "Drawer" "I'm ready to draw you anything you want!"
    in
       DialogueChunk index [dialogue1,dialogue2,dialogue3,dialogue4]

textDrawerP2A : DialogueChunk
textDrawerP2A =
    let
        index = DialogueIndex Drawer P2 A
        dialogue1 = Dialogue "Drawer" "Hi, my friend. What do you want me to draw for you?"
    in
    DialogueChunk index [dialogue1]

textDrawerP2B : DialogueChunk
textDrawerP2B =
    let
        index = DialogueIndex Drawer P2 B
        dialogue1 = Dialogue "Player" "I want the portrait."
        dialogue2 = Dialogue "Drawer" "Here you are the portrait! Have a nice day!"
    in
        DialogueChunk index [dialogue1,dialogue2]

textDrawerP2C : DialogueChunk
textDrawerP2C =
    let
        index = DialogueIndex Drawer P2 C
        dialogue1 = Dialogue "Player" "I want you to draw the memories."
        dialogue2 = Dialogue "Drawer" "God! These memories carry heavy emotions!"
        dialogue3 = Dialogue "Drawer" "I draw to spread happiness."
        dialogue4 = Dialogue "Drawer" "Drawing these violates my principles!"
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3,dialogue4]

textDrawerP2D : DialogueChunk
textDrawerP2D =
    let
        index = DialogueIndex Drawer P2 D
        dialogue1 = Dialogue "Player" "Realist artists are praised for honest reflection of life, critical to whole society."
        dialogue2 = Dialogue "Drawer" "Good point! Let me start creating memory pictures."
    in
        DialogueChunk index [dialogue1,dialogue2]

textDrawerP2E : DialogueChunk
textDrawerP2E =
    let
        index = DialogueIndex Drawer P2 E
        dialogue1 = Dialogue "Drawer" "That's not enough to change my mind."
    in
       DialogueChunk index [dialogue1]

textDrawerP2F : DialogueChunk
textDrawerP2F =
    let
        index = DialogueIndex Drawer P2 F
        dialogue1 = Dialogue "Drawer" "Hi, my friend. These are memory pictures."
        dialogue2 = Dialogue "Drawer" "The time guardian should have prevented SummerSara from happening."
        dialogue3 = Dialogue "Drawer" "Find her to figure out the truth."
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3]

textDrawerP2G : DialogueChunk
textDrawerP2G =
    let
        index = DialogueIndex Drawer P2 G
        dialogue1 = Dialogue "Drawer" "My friend, use memory pictures to end SummerSara!"
    in
        DialogueChunk index [dialogue1]

textDrawerP3A : DialogueChunk
textDrawerP3A =
    let
        index = DialogueIndex Drawer P3 A
        dialogue1 = Dialogue "Drawer" "Welcome, what do you want me to paint?"
        dialogue2 = Dialogue "Player" "Real-life paintings are great, right?"
        dialogue3 = Dialogue "Drawer" "My friend, you must be tired, relax and enjoy the game!"
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3]


textWeaver : List DialogueChunk 
textWeaver =
    textWeaverP1 ++ textWeaverP2 ++ textWeaverP3

{-|
    This function initializes the scipts of weaver in day 1-4.
-}
textWeaverP1 : List DialogueChunk
textWeaverP1 =
    [textWeaverP1A, textWeaverP1B, textWeaverP1C,textWeaverP1D, textWeaverP1E]

textWeaverP1A : DialogueChunk
textWeaverP1A =
    let
        index = DialogueIndex Weaver P1 A
        dialogue1 = Dialogue "" "Show your guard of time to talk with the time guardian."

    in
        DialogueChunk index [dialogue1]

textWeaverP1B : DialogueChunk
textWeaverP1B =
    let
        index = DialogueIndex Weaver P1 B
        dialogue1 = Dialogue "" "You are a qualified time protector, you are welcomed to the church."
    
    in
        DialogueChunk index [dialogue1]

textWeaverP1C : DialogueChunk
textWeaverP1C =
    let
        index = DialogueIndex Weaver P1 C
        dialogue1 = Dialogue "" "Church is only open to qualified time protector."
    
    in
        DialogueChunk index [dialogue1]

textWeaverP1D : DialogueChunk
textWeaverP1D =
    let
        index = DialogueIndex Weaver P1 D
        dialogue1 = Dialogue "" "Find the broken clothes to wipe weaver's tears."
    
    in
        DialogueChunk index [dialogue1]

textWeaverP1E : DialogueChunk
textWeaverP1E =
    let
        index = DialogueIndex Weaver P1 E
        dialogue1 = Dialogue "" "Meet weaver on day 5. Remember, only qualified time protector are welcomed."
    
    in
        DialogueChunk index [dialogue1]

{-|
    This function initializes the scipts of weaver in day 5-7.
-}
textWeaverP2 : List (DialogueChunk)
textWeaverP2 =
    [textWeaverP2A, textWeaverP2B,textWeaverP2C,textWeaverP2D,textWeaverP2E]

textWeaverP2A : DialogueChunk
textWeaverP2A =
    let
        index = DialogueIndex Weaver P2 A
        dialogue1 = Dialogue "Weaver" "Thank you for wiping my tears."
        dialogue2 = Dialogue "Player" "(give memory pictures)"
        dialogue3 = Dialogue "Weaver" "Thank you for creating these lost memory pictures."
        dialogue4 = Dialogue "Weaver" "BUT SummerSara gives people a shortened yet painless life. Isn't it better than a long and struggling life?"
    
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3,dialogue4]

textWeaverP2B : DialogueChunk
textWeaverP2B =
    let
        index = DialogueIndex Weaver P2 B
        dialogue1 = Dialogue "Player" "Everyone has his own life journey. We spend life-long time growing and hardening ourselves."
        dialogue2 = Dialogue "Weaver" "Your journey impressed me. Let me weave memory pictures back to the time ribbon."
    in
        DialogueChunk index [dialogue1,dialogue2]

textWeaverP2C : DialogueChunk
textWeaverP2C =
    let
        index = DialogueIndex Weaver P2 C
        dialogue1 = Dialogue "Player" "..."
        dialogue2 = Dialogue "Weaver" "SummerSara is a way out of the painful life."
    
    
    in
        DialogueChunk index [dialogue1,dialogue2]
textWeaverP2D : DialogueChunk
textWeaverP2D =
    let
        index = DialogueIndex Weaver P2 D
        dialogue1 = Dialogue "Weaver" "Young man, thank you for ending SummerSara."
        dialogue2 = Dialogue "Weaver" "To make changes effective, everything will start again from August 1st for the last time."
        dialogue3 = Dialogue "Weaver" "The fixed ribbon will let the time flow!"
   
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3]

textWeaverP2E : DialogueChunk
textWeaverP2E =
    let
        index = DialogueIndex Weaver P2 E

        dialogue1 = Dialogue "Weaver" "Thank you for wiping my tears."
        dialogue2 = Dialogue "Player" "..."
        dialogue3 = Dialogue "Weaver" "Thank you for protecting time. Try to meet Photographer and Drawer."
    
    
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3]

textWeaverP3 : List DialogueChunk
textWeaverP3 =
    [textWeaverP3A]
textWeaverP3A : DialogueChunk
textWeaverP3A =
    let
        index = DialogueIndex Weaver P3 A

        dialogue1 = Dialogue "Weaver" "My friend, now time flows again."
        dialogue2 = Dialogue "Player" "Thanks, now everyone has their time back."
        dialogue3 = Dialogue "Weaver" "My friend, you must be tired, relax and enjoy the game!"
    
    
    in
        DialogueChunk index [dialogue1,dialogue2,dialogue3]



