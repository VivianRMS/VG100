module Ball_Four.Update4 exposing (moveHoleP2_5)
{-| This module controls the part of the update for the game Break the loop.

# Ball4 Update Function
@docs moveHoleP2_5

-}

import Ball_Four.Model exposing (BFourModel)

{-|
    This function is for updating the moving hole in pattern2 by time.

-}

moveHoleP2_5 : BFourModel -> BFourModel
moveHoleP2_5 b4model =
  if b4model.time_hole > ( 3.8 * pi + 17.8 ) && b4model.time_hole <= (3.8 * pi + 19.8) then
        let
            nposx =
                100 - cos(85*pi/180) * (b4model.time_hole - 3.8*pi - 17.8)*7
            nposy =
                9.6 + sin(85*pi/180) * (b4model.time_hole - 3.8*pi - 17.8)*7
            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole } 
    else if b4model.time_hole > ( 3.8 * pi + 19.8 ) && b4model.time_hole <= ( 3.8 * pi + 20.8 ) then
        let
            nposx =
                109 + (b4model.time_hole - 3.8*pi - 19.8)*7
            nposy =
                9.4
            tmp_hole =
                b4model.hole
            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole } 
    else if b4model.time_hole > ( 3.8 * pi + 20.8 ) && b4model.time_hole <= ( 3.8 * pi + 22.8) then
        let
            nposx =
                109 - cos(85*pi/180) * (b4model.time_hole - 3.8*pi - 20.8)*7
            nposy =
                9.4 + sin(85*pi/180) * (b4model.time_hole - 3.8*pi - 20.8)*7
            tmp_hole =
                b4model.hole
            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }
    else
       moveHoleP2_6 b4model


moveHoleP2_6 : BFourModel -> BFourModel
moveHoleP2_6 b4model =
    if b4model.time_hole > ( 3.8 * pi + 22.8 ) && b4model.time_hole <= ( 3.8 * pi + 23.8 ) then
        let
            nposx =
                109 + (b4model.time_hole - 3.8*pi - 22.8)*7
            nposy =
                16 
            tmp_hole =
                b4model.hole
            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }
    else if b4model.time_hole >  ( 3.8 * pi + 23.8 ) && b4model.time_hole <= (3.8 * pi + 24.8) then
        let
            nposx =
                109 + (b4model.time_hole - 3.8*pi - 23.8)*7
            nposy =
                25.3 
            tmp_hole =
                b4model.hole
            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole } 
    else if b4model.time_hole > ( 3.8 * pi + 24.8 ) && b4model.time_hole <= ( 3.8 * pi + 26.8 ) then
        let
            nposx =
                125 - cos(85*pi/180) * (b4model.time_hole - 3.8*pi - 24.8)*7
            nposy =
                9.6 + sin(85*pi/180) * (b4model.time_hole - 3.8*pi - 24.8)*7
            tmp_hole =
                b4model.hole
            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole } 
    else
       moveHoleP2_7 b4model


moveHoleP2_7 : BFourModel -> BFourModel
moveHoleP2_7 b4model =
     if b4model.time_hole > ( 3.8 * pi + 26.8 ) && b4model.time_hole <= ( 5 * pi + 26.8) then
        let
            nposx =
                127 - cos(b4model.time_hole - 3.8* pi + 26.8 - 3*pi/5 ) * 5
            nposy =
                12 - sin(b4model.time_hole - 3.8* pi + 26.8 - 3*pi/5) * 4
            tmp_hole =
                b4model.hole
            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }  
    else if b4model.time_hole > ( 5 * pi + 26.8 ) && b4model.time_hole <= (5 * pi + 28) then
        let
            nposx =
                127 +  cos(60*pi/180) * (b4model.time_hole - 5*pi - 26.8)*7
            nposy =
                15.5 + sin(60*pi/180) * (b4model.time_hole - 5*pi - 26.8)*7
            tmp_hole =
                b4model.hole
            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole } 
    else
        { b4model | time_hole = 0 }