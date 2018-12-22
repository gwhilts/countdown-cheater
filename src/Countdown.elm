module Countdown exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- Program


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- Model


type alias Model =
    { letters : String
    , words : List String
    }


initialModel : Model
initialModel =
    Model "edar" [ "read", "dear", "ade", "are", "ear", "rad" ]



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
    a [ class "button is-outlined  is-primary" ]
        [ text word ]



-- Update


type Msg
    = ChangeLetters String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeLetters input ->
            if String.length input < 10 then
                ( { model | letters = input }, Cmd.none )

            else
                ( model, Cmd.none )
