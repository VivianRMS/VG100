port module Port exposing (..)

{- A port module in our project specified for audio control in the html's script -}


port sendChange :
    ()
    -> Cmd msg --If BGM was stopped, this function makes it play, and vice versa-}



--Change the volume of overall sounds


port changeVolume : Float -> Cmd msg



--Play a SFX


port playSFX : String -> Cmd msg
