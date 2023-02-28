module Func exposing (..)
func1 : Int -> List Int
func1 y =
          List.range 0 (y-1)
          |> List.map (\a->2*a)

func2 : List Int -> Int -> Int
func2 l z =
           List.length ( List.filter (\a->a==z) l )

func3 :  (Int, Int) -> List (List Int)
func3 x =
    let f = Tuple.first x
        s = Tuple.second x
    in
    List.repeat f ( List.range 0 (s-1) )

func4 :  Int -> List Int -> Maybe Int
func4 x l =
    if List.length l < x then
        Nothing
    else
        List.drop (x-1) l
        |> List.head

func5 : Int -> List Int
func5 x =
    if x==1 then
        [1]
    else if x==2 then
        [1,1]
    else
        let l=func5 (x-1)
            t=List.reverse l
              |> List.take 2
        in
        l++[List.sum t]

func6 :  List Int -> List Int
func6 l =
    List.filter (\a->((func2 l a)==1)) l

func7 : List (String, Int) -> (String, Int) -> List (String, Int)
func7 l sample =
    List.map (changetuple7 sample (" ",0)) l

changetuple7 : (String,Int) -> (String,Int) -> (String,Int) -> (String,Int)
changetuple7 sample result t =
    if (sample==t) then
        result
    else
        t

func8 : List a -> List (List a)
func8 l =
    let m=List.length l
        l_=List.take (m-1) l
        l_prev=func8 l_
        last=List.sum (List.take 1 (List.reverse l))
    in
        if m==1 then
            l
        else
