module ViewFrame exposing (viewGame)
{-|
    This module views different games in the frame
# Game View
@docs viewGame
-}
import Basis exposing (GameKind(..))
import Model exposing (Model)
import Msg exposing (Msg(..))
import Html exposing (Html,div)
import ViewKlotski exposing (viewKlotski)
import Ball_Two.View exposing (ballTwoView)
import ViewColor exposing (viewColor)
import Ball_Three.View exposing (ball_Thr)
import Ball_Four.View exposing (ballFourView)
import Ball_One.View exposing (ball_One)

{-|
    This function presents the game in the frame
-}
viewGame : GameKind -> Model -> Html Msg
viewGame kind model =
    case kind of
        Klotski ->
            div
                []
                [ viewKlotski model ]

        BallTwo ->
            div
                []
                [ ballTwoView model.b2model ]

        Color ->
            div
                []
                [ viewColor model ]

        BallThree ->
            div
                []
                [ ball_Thr model.b3model ]

        BallFour ->
            div
                []
                [ ballFourView model.b4model ]

        BallOne ->
            div
                []
                [ ball_One model.b1model ]
