module Update exposing (..)

import Types exposing (..)
import Maybe exposing (withDefault)

appear_time : Float
appear_time = 300

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( animate (min time 2) model, Cmd.none )

        Noop ->
            ( { ships = [ init_ship Main ], blasts = [], ship_time = 0 , state = Process } , Cmd.none )

        Go dir ->
            ( { model | ships = List.map (change_dir dir) model.ships }, Cmd.none )


animate :
    Float
    -> Model
    -> Model
    
animate elapsed model =
    if model.state == Process then
    let

        ( fltr_ships, fltr_blasts ) =
            List.foldl shoot ( [] , model.blasts ) model.ships

        (upd_ships, upd_blasts) =
            ( List.filter ( \nship -> nship.health >= 0 ) fltr_ships )
            |> create_ship model.ship_time
            |> List.foldl ( update_ship elapsed ) (fltr_ships, fltr_blasts)


        enemies =
            List.filter ( \x -> x.ship_type == Enemy) upd_ships
            |> List.map change_dir_enemy

        upd_ships2 =
            List.filter (\x -> x.ship_type==Main) upd_ships
            |> List.append enemies

        (upd_ships3, upd_blasts2) =
            (\(ships, blasts) -> (List.filter filter_pos ships, List.filter filter_pos blasts) )
            (upd_ships2, upd_blasts)
    in
    checkEnd
    { model
        | ships = upd_ships3
        , blasts = List.map move_blast upd_blasts2
        , ship_time =
            if model.ship_time > appear_time then
                0

            else
                model.ship_time + 0.5 * elapsed
    }
    else
        model

checkEnd : Model -> Model
checkEnd model =
    let
        mainShip =
            List.head ( List.filter ( \x -> x.ship_type == Main ) model.ships )
    in
        case mainShip of
            Nothing ->
                { model | state = End }
            Just ship ->
                if ship.health <=0 then
                    { model | state = End }
                else
                    model

create_ship : Float -> List Ship -> List Ship
create_ship timer ships =
    if timer > appear_time then
        init_ship Enemy :: ships
    else
        ships

init_ship : ShipType -> Ship
init_ship stype =
    let
        ( pos , point ) =
            if stype == Main then
                ( ( 0, 500 ) , 20 )

            else
                ( ( 1800, 500 ) , 5 )
    in
        Ship pos point stype Down 0

update_ship : Float -> Ship -> (List Ship, List Blast) -> ( List Ship, List Blast )
update_ship elapsed ship (ships, blasts)=
    let

--        (newdir, newpos) = move_ship ship.dir ship.pos ship.ship_type

        nship =
            List.filter ( \x -> x/= ship ) ships

        def_time =
            case ship.ship_type of
                Main ->
                    20
                Enemy ->
                    10

        time =
            if ship.blast_time > def_time then
                0

            else
                ship.blast_time + 0.5 * elapsed

        ( sx, sy ) =
                    ship.pos

        new_blasts =
            if time > def_time then
                (Blast ( sx + 75, sy + 35 ) ship.ship_type) :: blasts
            else
                blasts

        new_ships = { ship |  blast_time = time } :: nship
    in
        (new_ships, new_blasts)

move_ship : Dir -> (Float, Float) -> ShipType -> (Dir, (Float, Float))
move_ship dir (sx, sy) stype =
    let
        newdir =
                    if sy < 0 then
                        Down

                    else
                        dir

        newpos =
                    if stype /= Main then

                        ( sx, sy )

                    else if dir == Up then

                        ( sx - 1, sy - 3 )

                    else

                        ( sx - 1, sy + 3 )
    in
        (newdir, newpos)

shoot :
    Ship ->
    ( List Ship, List Blast )
    -> ( List Ship, List Blast )
shoot ship ( ships, blasts ) =
    let
        surv_blasts =
            List.map (check_hit ship) blasts
            |> List.filter (\( _, elem ) -> not elem )

        hit_ship =
            { ship
                | health =
                    if List.length blasts /= List.length surv_blasts then
                        ship.health - 1

                    else
                        ship.health
            }
    in
    if hit_ship.health <= 0 then
    ( ships, Tuple.first (List.unzip surv_blasts) )
    else
    ( hit_ship :: ships, Tuple.first (List.unzip surv_blasts) )


check_hit : Ship -> Blast -> ( Blast, Bool )
check_hit ship blast =
    let
        ( bx, by ) =
            blast.pos

        ( sx, sy ) =
            ship.pos

        result =
            if
            ship.ship_type /= blast.ship_type then
                (bx + 20 >= sx && bx <= sx + 130)
                && (by + 5 >= sy && by <= sy + 70)

            else
                False
    in
    ( blast, result )


filter_pos: { a| pos : ( Float, Float ) } -> Bool
filter_pos {pos} =
    let
        ( posx, _ ) = pos
    in
        posx > 0 || posx < 2500


move_blast : Blast -> Blast
move_blast blast =
    let
        ( x, y ) =
            blast.pos
    in
    if blast.ship_type == Main then
        { blast | pos = ( x + 15, y ) }

    else
        { blast | pos = ( x - 15, y ) }


change_dir : Dir -> Ship -> Ship
change_dir dir ship =
    let
        ( x, y ) =
            ship.pos

        npos =
            case ship.ship_type of
                Main ->
                    case dir of
                        Up ->
                            ( x, y - 10 )
                        Down ->
                            ( x, y + 10 )

                _ ->
                    ( x , y )


    in
    { ship | pos = npos }

change_dir_enemy : Ship -> Ship
change_dir_enemy enemy =
    let
        ( x, y ) = enemy.pos

        (npos,ndir) =
            if y < 0 then
                ( ( x - 1 , y + 4 ) , Down )
            else if y > 780 then
                ( ( x - 1 , y - 4 ) , Up )
            else
                case enemy.dir of
                    Down ->
                        ( ( x - 1 , y + 4 ) , enemy.dir )
                    Up ->
                        ( ( x - 1 , y - 4 ) , enemy.dir )
    in
    { enemy | pos = npos , dir = ndir }