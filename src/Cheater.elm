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


initModel =
    { name = "Swearengen" }



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
                []
            ]
        , section [ id "controls" ]
            [ input
                [ placeholder "Type scrambled letters here" ]
                []
            ]
        , hr [] []
        , section [ id "found-words", class "section" ]
            []
        ]



-- Update


update msg model =
    model
