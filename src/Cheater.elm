module Cheater exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)



-- Main


main =
    Browser.sandbox
        { init = initModel
        , view = view
        , update = update
        }



-- Model


type alias Model =
    { letters : String
    , words : List String
    }


initModel =
    Model "tac" [ "act", "cat" ]



-- View


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


update msg model =
    model
