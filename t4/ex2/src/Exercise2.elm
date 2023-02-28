module Exercise2 exposing (..)
func4 :  Int -> List Int -> Maybe Int
func4 x l =
    if List.length l < x then
        Nothing
    else
        List.drop ( x - 1 ) l
        |> List.head