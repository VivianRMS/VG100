module Ball_Four.Update3 exposing (moveHoleP2_1)
{-| This module controls the part of the update for the game Break the loop.

# Ball4 Update Function
@docs moveHoleP2_1

-}


import Ball_Four.Model exposing (BFourModel)
import Ball_Four.Update4 exposing (moveHoleP2_5)

{-|
    This function is for updating the moving hole in pattern2 by time.

-}

moveHoleP2_1 : BFourModel -> BFourModel
moveHoleP2_1 b4model =
    if b4model.time_hole <= 3 * pi / 2 then
        let
            nposx =
                44 + 5.6* cos b4model.time_hole 

            nposy =
                14 - 4.6 * sin b4model.time_hole

            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }

    else if b4model.time_hole > 3 * pi / 2 && b4model.time_hole <= 3 * pi then
        let
            nposx =
                43.461 - 5.6 * cos (b4model.time_hole - pi)

            nposy =
                21 - 4.6 * sin (b4model.time_hole - pi)

            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }
    else if b4model.time_hole > 3 * pi  && b4model.time_hole <= (3 * pi + 1.9) then
        let
            nposx =
                54.5
            nposy =
                10 + (b4model.time_hole - 3*pi)*7

            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }
    else
      moveHoleP2_2 b4model

moveHoleP2_2 : BFourModel -> BFourModel
moveHoleP2_2 b4model =
    if b4model.time_hole > (3 * pi + 1.9 ) && b4model.time_hole <= (3.8 * pi + 1.9 ) then
       let
            nposx =
                57.6 - 5 * (cos (b4model.time_hole - 3*pi - 1.9))
            nposy =
                20 + 5 * (sin (b4model.time_hole - 3*pi - 1.9))

            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }

    else if b4model.time_hole > ( 3.8 * pi + 1.9 ) && b4model.time_hole <= (3.8* pi + 3.8) then  
        let
            nposx =
                62.4 
            nposy =
                21.3 - (b4model.time_hole - (4 * pi + 1.9 ))*7
            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }
    else if b4model.time_hole > ( 3.8 * pi + 3.8 ) && b4model.time_hole <= (3.8 * pi + 5.8) then
         let
            nposx =
                70 + cos(85*pi/180) * (b4model.time_hole - 3.8*pi - 3.8)*7
            nposy =
                25.3 - sin(85*pi/180) * (b4model.time_hole - 3.8*pi - 3.8)*7
            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }
    else
       moveHoleP2_3 b4model

moveHoleP2_3 : BFourModel -> BFourModel
moveHoleP2_3 b4model =
    if b4model.time_hole > ( 3.8 * pi + 5.8 ) && b4model.time_hole <= (3.8 * pi + 7.8) then
        let
            nposx =
                72 + cos(85*pi/180) * (b4model.time_hole - 3.8*pi - 5.8)*7
            nposy =
                9.6 + sin(85*pi/180) * (b4model.time_hole - 3.8*pi - 5.8)*7
            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }   
    else if b4model.time_hole > ( 3.8 * pi + 7.8 ) && b4model.time_hole <= (3.8 * pi + 9.8) then
         let
            nposx =
                74 + cos(7*pi/18) * (b4model.time_hole - 3.8*pi - 7.8)*7
            nposy =
                25.3 - sin(7*pi/18) * (b4model.time_hole - 3.8*pi - 7.8)*7
            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }  
    else if b4model.time_hole > ( 3.8 * pi + 9.8 ) && b4model.time_hole <= (3.8 * pi + 11.8) then
        let
            nposx =
                82 - cos(85*pi/180) * (b4model.time_hole - 3.8*pi - 9.8)*7
            nposy =
                9.6 + sin(85*pi/180) * (b4model.time_hole - 3.8*pi - 9.8)*7
            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }
    else
      moveHoleP2_4 b4model
   
moveHoleP2_4 : BFourModel -> BFourModel
moveHoleP2_4 b4model =
    if b4model.time_hole > ( 3.8 * pi + 11.8 ) && b4model.time_hole <= (3.8 * pi + 13.8) then
         let
            nposx =
                88 + cos(85*pi/180) * (b4model.time_hole - 3.8*pi - 11.8)*7
            nposy =
                25.3 - sin(85*pi/180) * (b4model.time_hole - 3.8*pi - 11.8)*7
            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }
    else if b4model.time_hole > ( 3.8 * pi + 13.8 ) && b4model.time_hole <= ( 3.8 * pi + 15.8) then
        let
            nposx =
                90 + cos(85*pi/180) * (b4model.time_hole - 3.8*pi - 13.8)*7
            nposy =
                9.6 + sin(85*pi/180) * (b4model.time_hole - 3.8*pi - 13.8)*7
            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }   
    else if b4model.time_hole > ( 3.8 * pi + 15.8 ) && b4model.time_hole <= (3.8 * pi + 17.8) then
         let
            nposx =
                94 + cos(7*pi/18) * (b4model.time_hole - 3.8*pi - 15.8)*7
            nposy =
                25.3 - sin(7*pi/18) * (b4model.time_hole - 3.8*pi - 15.8)*7
            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }  
    else 
      moveHoleP2_5 b4model