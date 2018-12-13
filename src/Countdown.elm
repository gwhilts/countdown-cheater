module Countdown exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)



-- Program


main : Program Never Model msg
main =
    Html.beginnerProgram { model = initialModel, view = view, update = update }



-- Model


type alias Model =
    { letters : String
    , words : List String
    }


initialModel : Model
initialModel =
    Model "" []



-- View


view : Model -> Html msg
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
                [ button [ class "letterbox" ] [ text "A" ]
                , button [ class "letterbox" ] [ text "T" ]
                , button [ class "letterbox" ] [ text "C" ]
                ]
            ]
        , section [ id "controls" ]
            [ input [ placeholder "Type scrambled letters here" ]
                []
            ]
        , hr [] []
        , section [ id "found-words", class "section" ]
            [ a [ class "button is-outlined  is-primary" ]
                [ text "act" ]
            , a [ class "button is-outlined  is-primary" ]
                [ text "cat" ]
            ]
        ]



-- Update


update : msg -> Model -> Model
update msg model =
    model
