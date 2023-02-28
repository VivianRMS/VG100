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
    , fruit_pos : ( Int, Int )
    , move_timer : Float
    }



-- MSG


type Msg
    = Key Dir
    | Key_None
    | Place_Fruit ( Int, Int )
    | Tick Float



--MAIN

main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



--INITIALIZATION


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.none )


initModel : Model
initModel =
    let snakee = Snake.Snake [ ( 1, 0 ), ( 0, 0 ) ] Right Alive 0
    in
        Model  snakee ( 1, 1 ) 0



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
        nsnake =
            Snake.legalForward model.snake model.fruit_pos
    in
    if model.move_timer >= stepTime then
        { model | snake=nsnake , move_timer = 0 }

    else
        model


stepTime : Float
stepTime =
    200

updateFruit : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateFruit msg ( model, cmd ) =
    case msg of
        Tick elapsed ->
            if List.member model.fruit_pos (model.snake).snake_body then
                ( { model | fruit_pos = ( -1, -1 ) }, Cmd.batch [ cmd, Random.generate Place_Fruit fruitGen ] )

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
                ( { model | fruit_pos = fruit_pos }, cmd )

        _ ->
            ( model, cmd )

changeDir : Snake -> Dir -> Snake
changeDir snakee ndir =
    if snakee.snake_state == Alive then
        { snakee | snake_dir = ndir }
    else
        snakee



--View


gridColor : Model -> ( Int, Int ) -> String
gridColor model pos =
    if List.member pos (model.snake).snake_body then
        "black"

    else if model.fruit_pos == pos then
        "red"

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



renderInfo : Live_status -> Html Msg
renderInfo state =
    div
        [ style "background" "rgba(75,0,130, 0.7)"
        , style "color" "#00FF00"

        , style "font-family" "Helvetica, Arial, sans-serif"
        , style "font-size" "50px"
        , style "font-weight" "bold"

        , style "line-height" "10"
        , style "position" "absolute"

        , style "top" "10"
        , style "width" "501px"
        , style "height" "501px"
        , style "display"
            (if state == Alive then
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


view : Model -> Html Msg
view model =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]

        [ scoreInfo model.snake
        , renderInfo model.snake.snake_state
        , Svg.svg
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
