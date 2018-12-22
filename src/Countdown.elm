module Countdown exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Http
import Json.Decode as Decode exposing (Decoder, field)



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
    Model "" []



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
    | NewWords (Result Http.Error (List String))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeLetters input ->
            if String.length input < 3 then
                ( { model | letters = String.toLower input, words = [] }, Cmd.none )

            else if String.length input < 10 then
                ( { model | letters = String.toLower input }, getAllAnagrams input )

            else
                ( model, Cmd.none )

        NewWords (Ok anagrams) ->
            ( { model | words = anagrams }, Cmd.none )

        NewWords (Err error) ->
            ( { model | words = [ toString error ] }, Cmd.none )



-- Commands


getAllAnagrams : String -> Cmd Msg
getAllAnagrams letters =
    anagramsDecoder
        |> Http.get ("http://localhost:3000/anagrams/all-words-for/" ++ letters)
        |> Http.send NewWords



-- Encoders / Decoders


anagramsDecoder : Decoder (List String)
anagramsDecoder =
    field "anagrams" (Decode.list Decode.string)
