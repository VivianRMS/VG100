module Main exposing (main)
import Snake exposing (Snake,Dir(..),Movable(..),Live_status(..))
import Fruit exposing (..)
import Grid exposing (..)
import Browser
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown)
import Debug exposing (toString)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import Random
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr



type alias Model =
    { snake : Snake
    , fruit: Fruit
    , fruit_interval : Int
    , move_timer : Float
    }



-- MSG


type Msg
    = Key Dir
    | Key_None
    | Place_Fruit ( Int, Int )
    | Tick Float
    | Set_Interval Int



--MAIN

main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



--INITIALIZATION


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Random.generate Set_Interval Fruit.fruit_intervalGen )


initModel : Model
initModel =
    let snakee = Snake.Snake [ ( 1, 0 ), ( 0, 0 ) ] Right Alive 0 5 1
        fruitt=Fruit.Fruit (1,1) "grape"
    in
        Model  snakee fruitt 0 0



--UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
        |> updateSnake msg
        |> updateFruit msg


updateSnake : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateSnake msg ( model, cmd ) =
    case msg of
        Tick elapsed ->
            ( { model | move_timer = model.move_timer + elapsed }
                |> timedForward
            , cmd
            )
        _ ->
            ( model, cmd )


timedForward : Model -> Model
timedForward model =
    let
        nheart =
            if ( model.snake.snake_state==Dead && model.snake.heart>=0) then
                model.snake.heart+1
            else
                model.snake.heart
        snakee = model.snake
        nsnake = {snakee | heart = nheart }
        nnsnake =
            Snake.legalForward nsnake model.fruit
    in
    if model.move_timer >= stepTime then
        { model | snake=nnsnake , move_timer = 0 }

    else
        model


stepTime : Float
stepTime =
    200

updateFruit : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateFruit msg ( model, cmd ) =
    case msg of
        Tick elapsed ->
            if List.member model.fruit.fruit_pos (model.snake).snake_body then
            let nfruit = Fruit.Fruit (-1,-1) model.fruit.fruit_type
            in
                ( { model | fruit = nfruit }, Cmd.batch [ cmd, Random.generate Place_Fruit fruitGen] )

            else
                ( model, cmd )

        Key newdir ->
            ( { model | snake = changeDir model.snake newdir }
            , cmd
            )

        Place_Fruit fruit_pos ->
            if List.member fruit_pos (model.snake).snake_body then
                ( model, Cmd.batch [ cmd, Random.generate Place_Fruit fruitGen ] )

            else
                let
                    fruit_typee =
                         case modBy model.fruit_interval model.snake.fruitnum of
                               0->
                                   "apple"
                               _->
                                   "grape"
                    nfruit = Fruit.Fruit fruit_pos fruit_typee
                in
                ( { model | fruit=nfruit }, cmd )

        Set_Interval interval ->
            ( { model | fruit_interval = interval } , Cmd.none)

        _ ->
            ( model, cmd )

changeDir : Snake -> Dir -> Snake
changeDir snakee ndir =
    if ( snakee.heart >= 0 && snakee.snake_state == Alive ) then
        { snakee | snake_dir = ndir }
    else if ( snakee.heart >= 0 && snakee.snake_state == Dead ) then
        { snakee | snake_state = Alive , snake_dir = ndir}
    else
         snakee



--View


gridColor : Model -> ( Int, Int ) -> String
gridColor model pos =
    if List.member pos (model.snake).snake_body then
        "black"
    else if (model.fruit.fruit_pos == pos && model.fruit.fruit_type == "apple" ) then
        "red"
    else if (model.fruit.fruit_pos == pos && model.fruit.fruit_type == "grape" ) then
        "purple"
    else
        "white"

viewGrid : Model -> ( Int, Int ) -> Svg Msg
viewGrid model pos =
    let
        ( x, y ) =
            pos
    in
    Svg.rect
        [ SvgAttr.width (toString gridsize)
        , SvgAttr.height (toString gridsize)
        , SvgAttr.x (toString (x * gridsize))
        , SvgAttr.y (toString (y * gridsize))
        , SvgAttr.fill (gridColor model pos)
        , SvgAttr.stroke "blue"
        ]
        []

--wellInfo :

renderInfo : Model -> Html Msg
renderInfo model =
    div
        [ style "background" "rgba(75,0,130, 0.7)"
        , style "color" "#00FF00"

        , style "font-family" "Helvetica, Arial, sans-serif"
        , style "font-size" "50px"
        , style "font-weight" "bold"

        , style "line-height" "10"
        , style "position" "fixed"

        , style "top" "10"
        , style "width" "501px"
        , style "height" "501px"
        , style "display"
            (if  ( model.snake.heart >= 0 ) then
                "none"

             else
                "block"
            )
        ]
        [ text "You Died!"
        ]

scoreInfo : Snake -> Html Msg
scoreInfo snakee =
    div
        [ style "color" "green" ]
        [ text "Score: "
        , text (String.fromInt snakee.score)]

intervalInfo : Model -> Html Msg
intervalInfo model =
    div
        [ style "color" "red"]
        [ text "Interval: "
        , text (String.fromInt model.fruit_interval)]


oneHeart : Int ->Html Msg
oneHeart xxx =
    div
       [ style "width" "100%"
       , style "height" "100%"
       , style "position" "fixed"
       , style "left" "300px"
       , style "top" "5px"
       ]
       [ Svg.svg
         [ SvgAttr.width "100%"
         , SvgAttr.height "100%"
         ]
         [ Svg.rect
           [ SvgAttr.x ( String.fromInt ( xxx * 30 ) ++ "px" )
           , SvgAttr.y "10px"
           , SvgAttr.width "10"
           , SvgAttr.height "10"
           , SvgAttr.rx "5"
           , SvgAttr.ry "5"
           , SvgAttr.fill ("rgb(225, 141, 141)")
           ]
           []
          , Svg.rect
            [ SvgAttr.x ( String.fromInt ( xxx * 30 + 8 ) ++ "px" )
            , SvgAttr.y "10px"
            , SvgAttr.width "10"
            , SvgAttr.height "10"
            , SvgAttr.rx "5"
            , SvgAttr.ry "5"
            , SvgAttr.fill ("rgb(225, 141, 141)")
            ]
            []
          , Svg.polygon
            [ SvgAttr.points (String.fromInt ( xxx * 30  ) ++ ", 16 " ++ String.fromInt ( xxx * 30 + 18  ) ++ ", 16 " ++ String.fromInt ( xxx * 30 + 9 ) ++ ", 36 ")
            , SvgAttr.fill ("rgb(225, 141, 141)")
            ]
            []
         ]
       ]

hearts : Model -> List (Html Msg)
hearts model =
    let heartIntList = List.range 0 model.snake.heart
    in
    List.map oneHeart heartIntList

heartInfo : Model -> Html Msg
heartInfo model =
    div
        []
        ( hearts model)


view : Model -> Html Msg
view model =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "300px"
        , HtmlAttr.style "top" "50px"

        ]

        [ scoreInfo model.snake
        , intervalInfo model
        , renderInfo model
        , heartInfo model
        ,
            Svg.svg
             [ SvgAttr.width "100%"
             , SvgAttr.height "100%"
             ]
             (List.map (viewGrid model) (range2d mapsize))

        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ onAnimationFrameDelta Tick
        , onKeyDown (Decode.map key keyCode)
        ]


key : Int -> Msg
key keycode =
    case keycode of
        38 ->
            Key Up

        40 ->
            Key Down

        37 ->
            Key Left

        39 ->
            Key Right

        _ ->
            Key_None
