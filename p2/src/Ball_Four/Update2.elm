module Ball_Four.Update2 exposing (changehole)

{-| This module controls the part of the update for the game Break the loop.

# Ball4 Update Function
@docs changehole

-}

import Ball_Four.Ball_Four exposing (Pattern(..))
import Ball_Four.Model exposing (BFourModel)
import Ball_Four.Update3 exposing (moveHoleP2_1)

changeholeP1 : BFourModel -> BFourModel
changeholeP1 b4model =
    moveHoleP1_1 b4model 

moveHoleP1_1 :  BFourModel -> BFourModel
moveHoleP1_1 b4model =
   if b4model.time_hole < 3 then
        let
            nposx =
                     45 - b4model.time_hole*7*cos(85*pi/180)

            nposy =
                    5 + b4model.time_hole*7*sin(85*pi/180)

            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx, hole_posy = nposy }
        in
        { b4model | hole = nhole }
    else if b4model.time_hole >= 3 && b4model.time_hole < 4.7 then
        let
            nposx =
                     43.19 + (b4model.time_hole - 3)*7
 
            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx }
        in
           { b4model | hole = nhole }
    else if b4model.time_hole >= 4.7 && b4model.time_hole < (4.7 + 2*pi) then
        let
            nposx =
                     71.7 - 8 * cos (b4model.time_hole - 4.7 + pi/2)

            nposy =
                     17.5 - 9.5 * sin (b4model.time_hole - 4.7 + pi/2)
 
            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx , hole_posy = nposy}
        in
            { b4model | hole = nhole }
    else
      moveHoleP1_2 b4model


moveHoleP1_2 :  BFourModel -> BFourModel
moveHoleP1_2 b4model =
     if b4model.time_hole >= (4.7 + 2*pi) && b4model.time_hole < (4.7 + 4*pi) then
        let
            nposx =
                     97.5 - 8 * cos ( b4model.time_hole - 4.7 - 2*pi + pi/2 )

            nposy =
                     17.5 - 9.5 * sin ( b4model.time_hole - 4.7 - 2*pi + pi/2 )
 
            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx , hole_posy = nposy}
        in
            { b4model | hole = nhole }
    else if b4model.time_hole >= (4.7 + 4*pi) && b4model.time_hole < (7.5 + 4*pi) then
        let
            nposx =
                     119.5 - (b4model.time_hole - 4.7 - 4*pi )*cos(85*pi/180)*7
            nposy =
                     8 + (b4model.time_hole - 4.7 - 4*pi )*sin(85*pi/180)*7
 
            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx , hole_posy = nposy}
        in
            { b4model | hole = nhole }
    else if b4model.time_hole >= (7.5 + 4*pi) && b4model.time_hole < (7.5 + 4*pi + 6*pi/5) then
        let
            nposx =
                     125 - 6 * cos (b4model.time_hole - 7.7 - pi*4 + pi/2)

            nposy =
                     15 - 5 * sin (b4model.time_hole - 7.7 - pi*4 + pi/2)
 
            tmp_hole =
                b4model.hole

            nhole =
                { tmp_hole | hole_posx = nposx , hole_posy = nposy}
        in
            { b4model | hole = nhole }
    else
         { b4model | time_hole = 0 }






changeholeP2 : BFourModel -> BFourModel
changeholeP2 b4model =
   moveHoleP2_1 b4model

{-|
    This function is for updating the moving hole in different patterns by time.

-}
    
changehole: BFourModel -> BFourModel
changehole b4model =
  case b4model.pattern of
    Pattern1 ->
       changeholeP1 b4model
    Pattern2 ->
       changeholeP2 b4model