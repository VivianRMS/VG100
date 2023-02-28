module ColorElements exposing (pieceApple,pieceHint,pieceLeaf,pieceBlueCloth,pieceGrassRing,pieceTE1,pieceTE2)
{-| This module defines basic functions for the game Color Union.

# Basic functions
@docs pieceApple, pieceHint, pieceLeaf, pieceBlueCloth, pieceGrassRing, pieceTE1, pieceTE2

-}

pieceTE1LightPurple : List Float
pieceTE1LightPurple =
    List.concat [ [1,2,44,5,6,48,14,56,98,139] , [140,20,21,63,105,147,26,31,50,92] , [64,106,78,120,37,38,79,80,81,121] , [163,123,164] ]

pieceTE1Purple : List Float
pieceTE1Purple =
    List.concat [ [43,85,3,4,46,7,49,91,133,12] , [54,55,96,97,138,16,58,59,100,101] , [142,71,113,84,126,167,168,103,104,144] , [145,146,25,27,68,69,110,111,152,149] , [150,151,108,109,30,32,73,74,115,116] , [157,159] ]

pieceTE1LightPink : List Float
pieceTE1LightPink =
    List.concat [ [114,155,156,36,33,75,76,117,118,158] , [160,39,40,41,82,83] ]
pieceTE2Pink : List Float
pieceTE2Pink =
    List.concat
    [[5,6,48,90,97,98,139,20],[94,95,136,17,102,103,144,25],[106,107,148,29,32,33,75,117,37,38,80,122]]

pieceTE2Black : List Float
pieceTE2Black =
    List.concat
    [[22,85,86,87,88,89,91,127],[128,129,130,131,132,133,4,46,68],[129,10,52,11,12,13,14,53,54,55,56],[135,137,96,138,19,62,104,146],[27,70,28,23,24,26,64,65,66,67,68],[69,70,108,149,30,72,114,155,36],[78,120,113,115,156,157,39,40,41],[82,83,84,124,166,126,168,112,153],[34,76,118,159,35,77]]


pieceLeafLightBlue : List Float
pieceLeafLightBlue =
    List.concat
    [[43,44,1,2,85,86,127,8,50],[92,87,129,93,135,161,42],[84,126,167,168,34,77,40,83]]

pieceLeafLightGreen : List Float
pieceLeafLightGreen =
    List.concat
    [ [6,7,48,49,90,91,131,132,133,13] , [54,56,96,97,98,137,138,139,18] , [60,61,20,143,103,104,145,24,25,26] , [66,67,68,108,149,150,110,72,31,32] , [74,114,115,116,155,156,157,36,38,78] , [79,120,121,122,162,163,14] ]

pieceHintOrange : List Float
pieceHintOrange =
    let
        piece1 =
            [ 24, 25, 67, 109, 3, 45, 46, 87, 88, 128, 129 ]

        piece2 =
            [ 130, 9, 10, 11, 51, 52, 53, 54, 93, 94, 95 ]

        piece3 =
            [ 96, 134, 135, 136, 137, 138, 64, 106, 148, 29, 71 ]

        piece4 =
            [ 72, 113, 114, 155, 156, 36, 37, 78, 79, 80, 120 ]

        piece5 =
            [ 121, 122, 162, 163, 164, 153, 34, 76, 118, 159, 160 ]

        piece6 =
            [ 40, 41, 82, 83, 124, 125, 165, 166, 60, 149, 152 ]

        piece7 =
            [ 15, 16, 17, 57, 58, 59, 18, 19, 61, 62, 146 ]

        piece8 =
            [ 27, 69, 111, 33, 75, 117, 158, 39, 81, 123, 30 ]

        piece9 =
            [ 73, 115, 157, 38, 99, 141, 22, 65, 107 ]
    in
    List.foldl List.append [] [ piece1, piece2, piece3, piece4, piece5, piece6, piece7, piece8, piece9 ]


pieceHintBlue : List Float
pieceHintBlue =
    let
        piece1 =
            [ 1, 2, 43, 44, 85, 86, 127, 8, 50, 92, 6 ]

        piece2 =
            [ 7, 49, 91, 133, 14, 102, 143, 144, 66, 108, 150 ]

        piece3 =
            [ 68, 110, 151, 161, 42, 84, 126, 167, 168, 4, 5 ]

        piece4 =
            [ 47, 48, 89, 90, 131, 132, 12, 13, 55, 56, 97 ]

        piece5 =
            [ 98, 139, 140, 105, 147, 28, 70, 112, 154, 35, 77 ]

        piece6 =
            [ 119, 20, 21, 63 ]
    in
    List.foldl List.append [] [ piece1, piece2, piece3, piece4, piece5, piece6 ]

{-|
    This function defines number index for different color when the game is in the library hint floor for practice.

-}
pieceHint : List ( List Float )
pieceHint =
    [ pieceHintOrange, pieceHintBlue, pieceHintGreen ]

pieceHintGreen : List Float
pieceHintGreen =
    [ 100, 101, 142, 23, 103, 104, 145, 26, 31, 32, 74, 116 ]

{-|
    This function defines number index for different color when the game serves the purpose of fetching the apple.

-}
pieceApple : List ( List Float )
pieceApple =
    [ pieceAppleOrange, pieceAppleRed, pieceAppleYellow, pieceApplePurple ]

pieceAppleOrange : List Float
pieceAppleOrange =
    let
        colors = List.concat [ pieceAppleRed, pieceAppleYellow, pieceApplePurple ]
        all =
            List.range 1 168
            |> List.map toFloat
    in
        List.filter (\x -> not (List.member x colors) ) all

pieceAppleRed : List Float
pieceAppleRed =
    [92,93,94,134,135,33,34,35,75,76,77]

pieceAppleYellow : List Float
pieceAppleYellow =
    let
        ye1 =
            [95,96,97,98,136,137,138,139]
        ye2 =
            [29,30,31,32,71,72,73,74]
    in
        List.append ye1 ye2

pieceApplePurple : List Float
pieceApplePurple =
    let
        pu1 =
            [17,18,19,20,59,60,61,62]
        pu2 =
            [101,102,103,104,142,143,144,145]
        pu3 =
            [23,24,25,26,65,66,67,68]
        pu4 =
            [107,108,109,110,148,149,150,151]
    in
        List.concat [pu1,pu2,pu3,pu4]

{-|
    This function defines number index for different color when the game serves the purpose of fetching the grass ring.

-}
pieceGrassRing : List (List Float)
pieceGrassRing =
    [ pieceGrassRingLightGreen , pieceGrassRingDarkGreen , pieceGrassRingLightRed ]

pieceGrassRingLightGreen : List Float
pieceGrassRingLightGreen =
    let
        colors = List.concat [ pieceGrassRingDarkGreen, pieceGrassRingLightRed ]
        all =
            List.range 1 168
            |> List.map toFloat
    in
        List.filter (\x -> not (List.member x colors) ) all

pieceGrassRingDarkGreen : List Float
pieceGrassRingDarkGreen =
    let
        dg1 =
            List.concat [ [141,100,58,16,135,94,52,10,11,12] , [53,54,55,97,139,20,63,105,147,28] , [70,112,153,34,76,118,115,116,117,157] ,[158,159,22,65,107,149,30,73] ]
        dg2 =
            List.append [143,102,60,18,61,103,145,26] [68,110,151,109,67,24]
    in
        List.append dg1 dg2

pieceGrassRingLightRed : List Float
pieceGrassRingLightRed =
    List.concat [ [144,25,142,101,59,17,95,96,136,137] , [138,19,62,104,146,27,69,111,152,31] , [32,33,74,75,23,66,108,150] ]

{-|
    This function defines number index for different color when the game serves the purpose of fetching the blue cloth.

-}
pieceBlueCloth : List (List Float)
pieceBlueCloth =
    [ pieceBlueClothBlue , pieceBlueClothLightPurple , pieceBlueClothPurple , pieceBlueClothLightBlue ]

pieceBlueClothLightBlue : List Float
pieceBlueClothLightBlue =
    let
        colors = List.concat [ pieceBlueClothBlue , pieceBlueClothLightPurple , pieceBlueClothPurple ]
        all =
            List.range 1 168
            |> List.map toFloat
    in
        List.filter (\x -> not (List.member x colors) ) all

pieceBlueClothBlue : List Float
pieceBlueClothBlue =
    let
        b1 =
            List.append [43,85,127,8,51,93,135,16] [59,45,2,87,129,10,53]
        b2 =
            List.append [109,151,32,75,117,159,40,83,125,167] [115,157,38,81,123,165]
    in
        List.append b1 b2

pieceBlueClothLightPurple : List Float
pieceBlueClothLightPurple =
    [100,142,23,66,104,146,27,70]

pieceBlueClothPurple : List Float
pieceBlueClothPurple =
    List.append [101,102,103,143,144,145] [24,25,26,67,68,69]

{-|
    This function defines number index for different color when the game serves the purpose of cleaning the pool.

-}
pieceLeaf : List (List Float)
pieceLeaf =
    [ pieceLeafLightBlue , pieceLeafLightGreen , pieceLeafLightRed ]

pieceLeafLightRed : List Float
pieceLeafLightRed =
    let
        colors = List.concat [ pieceLeafLightBlue , pieceLeafLightGreen ]
        all =
            List.range 1 168
            |> List.map toFloat
    in
        List.filter (\x -> not (List.member x colors) ) all


{-|
    This function defines number index for different color when the game is at difficulty level one.

-}
pieceTE1 : List (List Float)
pieceTE1 =
    [ pieceTE1LightPurple , pieceTE1Purple , pieceTE1LightYellow , pieceTE1LightPink]

pieceTE1LightYellow : List Float
pieceTE1LightYellow =
    let
        colors = List.concat [ pieceTE1LightPurple , pieceTE1Purple ,  pieceTE1LightPink ]
        all =
            List.range 1 168
            |> List.map toFloat
    in
        List.filter (\x -> not (List.member x colors) ) all

{-|
    This function defines number index for different color when the game is at difficulty level two.

-}
pieceTE2 : List (List Float)
pieceTE2 =
    [ pieceTE2Yellow , pieceTE2Black , pieceTE2Pink ]

pieceTE2Yellow : List Float
pieceTE2Yellow =
    let
        colors = List.concat [ pieceTE2Black , pieceTE2Pink ]
        all =
            List.range 1 168
            |> List.map toFloat
    in
        List.filter (\x -> not (List.member x colors) ) all