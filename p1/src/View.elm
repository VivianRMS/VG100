module View exposing (view)

{- Here including all our view functions; almost everything that we deal with Html and stuff -}

import Background.Ball exposing (BallState(..), makeBalls)
import Background.Bricks exposing (makeBricks)
import Background.Paddle exposing (makePaddle)
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (autoplay, controls, id, loop, src, style)
import Html.Events exposing (onClick)
import Markdown exposing (toHtml)
import Message exposing (KeyInput(..), Msg(..))
import Model exposing (CurrentState(..), GameStatus, Model, WinOrFailure(..))



-- view of game interface


displayBackground : GameStatus -> Html Msg
displayBackground status =
    Html.div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        , style "top" "0px"
        , style "left" "0px"
        , style "background-image" "url(assets/images/background.png)"
        , style "background-size" "cover"
        , style "background-repeat" "no-repeat"
        , style "background-position" "center"
        , style "background-attachment" "fixed"
        ]
        (List.concat
            [ makeBalls status.balls
            , [ makePaddle status.paddle ]
            , makeBricks status.bricks
            ]
        )



-- display the team logo before shifting to the game page


displayIntro : Html Msg
displayIntro =
    Html.div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        , style "top" "0px"
        , style "left" "0px"
        , style "background-image" "url(assets/images/logo.png)"
        , style "background-size" "cover"
        , style "background-repeat" "no-repeat"
        , style "background-position" "center"
        , style "background-attachment" "fixed"
        ]
        []



-- display game over and restart button


showLifeStatus : Model -> Html Msg
showLifeStatus model =
    div
        [ style "background" "rgba(191, 153, 248, .8)"
        , style "color" "red"
        , style "font-family" "alagard"
        , style "font-size" "50px"
        , style "font-weight" "bold"
        , style "line-height" "50px"
        , style "position" "absolute"
        , style "top" "500"
        , style "width" "100%"
        , style "height" "100%"
        , style "text-align" "center"
        , style "display"
            (if model.winOrFailure == Failure then
                "block"

             else
                "none"
            )
        ]
        [ toHtml [] """
Magma Roars ...

Brick Shakes ...

Darkness Whispers ...

Young Man Combats Endless Despair ...
"""
        , button
            (style "background" "#a6001b"
                :: style "border" "2"
                :: style "color" "white"
                :: style "cursor" "pointer"
                :: style "display" "block"
                :: style "font-family" "alagard"
                :: style "font-size" "50px"
                :: style "font-weight" "400"
                :: style "bottom" "80px"
                :: style "height" "80px"
                :: style "width" "200px"
                :: style "line-height" "50px"
                :: style "outline" "none"
                :: style "position" "absolute"
                :: style "text-align" "center"
                :: style "right" "120px"
                :: [ onClick Replay ]
            )
            --The result of the elf robot. This is hideous but can pass the check.
            [ text "Restart" ]
        ]



-- display text when passing level


showVictoryStatus : Model -> Html Msg
showVictoryStatus model =
    let
        txt1 =
            case model.level of
                3 ->
                    toHtml [] """
Magma Roars But Melodic

Brick Shakes But Stable

Darkness Whispers But Boring

Light Has Come

Home Is Near
"""

                _ ->
                    toHtml [] """
Magma Roars ...

Brick Shakes ...

Darkness Whispers ...

Light Is Coming

Young Man Keeps Fighting
"""

        txt2 =
            case model.level of
                3 ->
                    "Replay"

                _ ->
                    "Next Level"

        message =
            case model.level of
                3 ->
                    Replay

                _ ->
                    Pass model.level
    in
    div
        (style "background" "rgba(247,214,153, .8)"
            :: style "color" "red"
            :: style "font-family" "alagard"
            :: style "font-size" "40px"
            :: style "font-weight" "bold"
            :: style "line-height" "50px"
            :: style "position" "absolute"
            :: style "top" "500"
            :: style "width" "100%"
            :: style "height" "100%"
            :: style "text-align" "center"
            :: [ style "display"
                    (if model.winOrFailure == Victory then
                        "block"

                     else
                        "none"
                    )
               ]
        )
        --The result of the elf robot. This is hideous but can pass the check.
        [ txt1
        , button
            (onClick message
                :: style "background" "#a6001b"
                :: style "border" "2"
                :: style "color" "white"
                :: style "cursor" "pointer"
                :: style "display" "block"
                :: style "font-family" "alagard"
                :: style "font-size" "40px"
                :: style "font-weight" "400"
                :: style "bottom" "80px"
                :: style "height" "160px"
                :: style "width" "200px"
                :: style "line-height" "70px"
                :: style "outline" "none"
                :: style "position" "absolute"
                :: style "text-align" "center"
                :: [ style "right" "120px" ]
            )
            --The result of the elf robot. This is hideous but can pass the check.
            [ text txt2 ]
        ]



-- set button to alter game state


showButton : Model.CurrentState -> Html Msg
showButton state =
    let
        ( txt, msg ) =
            case state of
                Model.Stopped ->
                    ( "Start", Start )

                Model.Playing ->
                    ( "Pause", Pause )

                Model.Paused ->
                    ( "Continue", Continue )

                Model.BeforeStart ->
                    ( "Next", Next )

                Model.BeforeWholeGame ->
                    ( "Next", Next )

                Model.PreAnimation ->
                    ( "Next", Next )

                Model.RuleExplanation ->
                    ( "Next", Next )

        left =
            case txt of
                "Next" ->
                    120

                _ ->
                    40

        bottom =
            case txt of
                "Next" ->
                    80

                _ ->
                    20
    in
    button
        (style "background" "#a6001b"
            :: style "border" "2"
            :: style "bottom" (String.fromInt bottom ++ "px")
            :: style "color" "white"
            :: style "cursor" "pointer"
            :: style "display" "block"
            :: style "font-family" "alagard"
            :: style "font-size" "30px"
            :: style "font-weight" "400"
            :: style "height" "70px"
            :: style "left" (String.fromInt left ++ "px")
            :: style "line-height" "60px"
            :: style "outline" "none"
            :: style "position" "absolute"
            :: style "width" "140px"
            :: [ onClick msg ]
        )
        --The result of the elf robot. This is hideous but can pass the check.
        [ text txt ]



-- display slogan before level


levelSlogan : Model -> Html Msg
levelSlogan model =
    let
        attributes =
            [ style "position" "absolute"
            , style "text-align" "center"
            , style "top" "70px"
            , style "width" "100%"
            , style "height" "100%"
            , style "line-height" "50px"
            , style "font-family" "alagard"
            , style "font-size" "50px"
            , style "font-weight" "bold"
            , style "color" "#642D0FFF"
            ]

        txt =
            case model.level of
                1 ->
                    toHtml attributes """
Magma Roars ...

Bricks Shake ...

Darkness Whispers ...

Good Things Never Die ...

"""

                2 ->
                    toHtml attributes """
Magma Roars ...

Bricks Shake ...

Darkness Whispers ...

Don't Go Gentle into That Scaring Night ...
"""

                3 ->
                    toHtml attributes """
Magma Roars ...

Bricks Shake ...

Darkness Whispers ...

A Man Can Die But Never Yield ...
"""

                _ ->
                    toHtml attributes """
                    """
    in
    div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        , style "top" "0px"
        , style "left" "0px"
        , style "background-image" "url(assets/images/level_intro.png)"
        , style "background-size" "cover"
        , style "background-repeat" "no-repeat"
        , style "background-position" "center"
        , style "background-attachment" "fixed"
        ]
        [ txt
        ]



-- level description


levelInformation : Model -> Html Msg
levelInformation model =
    let
        attributes =
            [ style "position" "absolute"
            , style "text-align" "center"
            , style "top" "70px"
            , style "left" "0px"
            , style "width" "100%"
            , style "height" "100%"
            , style "line-height" "50px"
            , style "font-family" "alagard"
            , style "font-size" "50px"
            , style "font-weight" "bold"
            , style "color" "#642D0FFF"
            ]

        txt =
            case model.level of
                1 ->
                    toHtml attributes """
LEVEL ONE

Use Your Balls to Fight Your Way Out !

Magma and Rocks Are Getting Closer ...

The Brave, Shoot A Path Out !
"""

                2 ->
                    toHtml attributes """
LEVEL TWO

After Some Time, You Are Getting Familiar ...

Magma and Rocks Are Falling Faster ...

Temperature Is Rising, One Path is Not Enough ...

The Brave, Shoot Two Paths Out !
"""

                3 ->
                    toHtml attributes """
LEVEL THREE

Getting Brighter ... Victory Seems Close

You Are Stressed Out ...

Lava Drips Overhead ... Rocks Brush Past ...

For The Ultimate Victory, Keep Going !
"""

                _ ->
                    toHtml attributes """
"""
    in
    div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        , style "top" "0px"
        , style "left" "0px"
        , style "background-image" "url(assets/images/level_intro.png)"
        , style "background-size" "cover"
        , style "background-repeat" "no-repeat"
        , style "background-position" "center"
        , style "background-attachment" "fixed"
        ]
        [ txt
        ]



-- top left display level


renderLevel : Model -> Html Msg
renderLevel model =
    div
        [ style "color" "indianred"
        , style "font-family" "alagard"
        , style "font-size" "30px"
        , style "position" "absolute"
        , style "left" "50px"
        , style "top" "10px"
        , style "width" "501px"
        , style "height" "501px"
        ]
        [ text ("Current Level: " ++ String.fromInt model.level) ]



--  display game background at the state Beforewholegame


gameInformation : Html Msg
gameInformation =
    Html.div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        , style "top" "0px"
        , style "left" "0px"
        , style "background-image" "url(assets/images/game_cover.png)"
        , style "background-size" "cover"
        , style "background-repeat" "no-repeat"
        , style "background-position" "center"
        , style "background-attachment" "fixed"
        ]
        []



-- main description


ruleInformation : Html Msg
ruleInformation =
    let
        attributes =
            [ style "position" "absolute"
            , style "text-align" "center"
            , style "top" "70px"
            , style "width" "100%"
            , style "height" "100%"
            , style "line-height" "50px"
            , style "font-family" "alagard"
            , style "font-size" "50px"
            , style "font-weight" "bold"
            , style "color" "#642D0FFF"
            ]

        txt =
            toHtml attributes """
HONG HONG HONG ...

Magma Is Splashing Everywhere

Waking Up, Finding Scaring Flames

in Endless Darkness

Only Having Some Solid Balls At Hand ...

To Live Or To Die Is A Question
"""
    in
    div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        , style "top" "0px"
        , style "left" "0px"
        , style "background-image" "url(assets/images/level_intro.png)"
        , style "background-size" "cover"
        , style "background-repeat" "no-repeat"
        , style "background-position" "center"
        , style "background-attachment" "fixed"
        ]
        [ txt
        ]



--This sets a a style featuring the Font. I set it here so we don't have to deal with the .html files.


foreView : Html Msg
foreView =
    Html.node "style" [] [ Html.text "@font-face {font-family: 'alagard';src: url('assets/fonts/alagard.ttf');}" ]



--credit to Hewett Tsoi for the font (https://www.dafont.com/alagard.font?back=bitmap)

-- different states of game

view : Model -> Html Msg
view model =
    let
        subDiv =
            case model.state of
                PreAnimation ->
                    displayIntro

                BeforeWholeGame ->
                    div
                        []
                        [ gameInformation
                        , showButton BeforeStart
                        ]

                RuleExplanation ->
                    div
                        []
                        [ ruleInformation
                        , showButton BeforeStart
                        ]

                BeforeStart ->
                    div
                        []
                        [ levelInformation model
                        , showButton model.state
                        ]

                Stopped ->
                    div
                        []
                        [ levelSlogan model
                        , button
                            (style "background" "#a6001b"
                                :: style "border" "2"
                                :: style "color" "white"
                                :: style "cursor" "pointer"
                                :: style "display" "block"
                                :: style "font-family" "alagard"
                                :: style "font-size" "50px"
                                :: style "font-weight" "400"
                                :: style "bottom" "80px"
                                :: style "height" "80px"
                                :: style "width" "200px"
                                :: style "line-height" "70px"
                                :: style "outline" "none"
                                :: style "position" "absolute"
                                :: style "text-align" "center"
                                :: style "right" "120px"
                                :: [ onClick Start ]
                            )
                            [ text " Start" ]
                        , playBGM model
                        ]

                Playing ->
                    div
                        [ style "width" "100%"
                        , style "height" "100%"
                        , style "position" "fixed"
                        , style "left" "0"
                        , style "top" "0"
                        , style "font-family" "alagard"
                        ]
                        ([ displayBackground model
                         , renderLevel model

                         -- , renderTime model
                         , showButton model.state
                         , showLifeStatus model
                         , showVictoryStatus model
                         , playBGM model
                         ]
                            ++ playSoundEffect
                        )

                Paused ->
                    div
                        [ style "width" "100%"
                        , style "height" "100%"
                        , style "position" "fixed"
                        , style "left" "0"
                        , style "top" "0"
                        , style "font-family" "alagard"
                        ]
                        ([ displayBackground model
                         , showButton model.state
                         , playBGM model
                         ]
                            ++ playSoundEffect
                        )
    in
    div
        []
        [ foreView, subDiv ]



-- bgm settings
{- Idea here is to first load everything at the very beginning, including every sound effects.
   So that we don't need to call html msg for SFX, but instead, we can make use of the update function, which
   deals with the Cmd msg, exactly what we want to deal with JS.
-}


playBGM : Model -> Html Msg
playBGM model =
    let
        visualControl =
            case model.state of
                Playing ->
                    False

                _ ->
                    True
    in
    playSomeThing visualControl "bgm"



--Load everything in


playSoundEffect : List (Html Msg)
playSoundEffect =
    let
        names =
            [ "bigBall", "bigPaddle", "Dead", "Forted", "GameOver", "magma", "rock", "paddleHit" ]
    in
    List.map (playSomeThing False) names


playSomeThing : Bool -> String -> Html Msg
playSomeThing visualControl name =
    let
        looping =
            if name == "bgm" && not visualControl then
                True

            else
                False
    in
    Html.audio
        [ controls visualControl
        , src ("assets/audio/" ++ name ++ ".ogg")
        , autoplay looping
        , id name
        , loop looping
        ]
        []
