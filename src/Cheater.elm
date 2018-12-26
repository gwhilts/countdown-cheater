module Cheater exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- Main


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- Model


type alias Model =
    { letters : String
    , words : List String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "tac" [ "act", "cat" ], Cmd.none )



-- View


view : Model -> Html Msg
view model =
    div [ id "app" ]
        [ header [ id "header", class "hero is-primary" ]
            [ div [ id "title", class "hero-body" ]
                [ h1 [ class "title has-text-centered" ]
                    [ text "Countdown Cheater" ]
                ]
            ]
        , section [ id "letters", class "columns" ]
            [ div [ class "column has-text-centered" ]
                (letterboxes model.letters)
            ]
        , section [ id "controls" ]
            [ input
                [ placeholder "Type scrambled letters here"
                , value model.letters
                , onInput ChangeLetters
                ]
                []
            ]
        , hr [] []
        , section [ id "found-words", class "section" ]
            (List.map wordboxFor model.words)
        ]



-- View Helpers


letterboxes : String -> List (Html msg)
letterboxes letters =
    letters
        |> String.toUpper
        |> String.toList
        |> List.map letterboxFor


letterboxFor : Char -> Html msg
letterboxFor letter =
    button [ class "letterbox" ] [ text (String.fromChar letter) ]


wordboxFor : String -> Html msg
wordboxFor word =
    a
        [ class "button is-outlined  is-primary"
        , style "font-size" "30px"
        ]
        [ text word ]



-- Update


type Msg
    = ChangeLetters String


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        ChangeLetters newLetters ->
            if String.length newLetters < 10 then
                ( { model | letters = newLetters }, Cmd.none )

            else
                ( model, Cmd.none )
