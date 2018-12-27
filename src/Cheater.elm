module Cheater exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode exposing (Decoder, field)



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
    , lookup : ( Bool, String )
    , words : List String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" ( False, "" ) [], Cmd.none )



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
        , popUpDef model.lookup
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


popUpDef : ( Bool, String ) -> Html Msg
popUpDef ( show, word ) =
    if show then
        div [ class "definition modal is-active" ]
            [ div [ class "modal-background" ]
                []
            , div [ class "modal-card" ]
                [ header [ class "modal-card-head" ]
                    [ button [ class "button is-large is-primary" ] [ text word ]
                    , p [ class "modal-card-title" ] [ text " " ]
                    , button [ class "delete", onClick HideDefinition ] [ text "close" ]
                    ]
                , section [ class "modal-card-body" ]
                    [ iframe [ class "dict-frame", src ("https://www.merriam-webster.com/dictionary/" ++ word) ]
                        []
                    ]
                ]
            ]

    else
        text ""


wordboxFor : String -> Html Msg
wordboxFor word =
    let
        size =
            word |> String.length |> (\n -> (n * 6) + 2) |> String.fromInt
    in
    a
        [ class "button is-outlined  is-primary"
        , style "font-size" (size ++ "px")
        , onClick (ShowDefinition word)
        ]
        [ text word ]



-- Update


type Msg
    = ChangeLetters String
    | HideDefinition
    | NewWords (Result Http.Error (List String))
    | ShowDefinition String


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

        HideDefinition ->
            ( { model | lookup = ( False, "" ) }, Cmd.none )

        NewWords (Ok anagrams) ->
            ( { model | words = anagrams }, Cmd.none )

        NewWords (Err error) ->
            ( { model | words = [ Debug.toString error ] }, Cmd.none )

        ShowDefinition word ->
            ( { model | lookup = ( True, word ) }, Cmd.none )



-- Commands


getAllAnagrams : String -> Cmd Msg
getAllAnagrams letters =
    anagramsDecoder
        |> Http.get ("http://localhost:3000/anagrams/all-words-for/" ++ letters)
        |> Http.send NewWords



-- JSON Encoder/Decoders


anagramsDecoder : Decoder (List String)
anagramsDecoder =
    field "anagrams" (Decode.list Decode.string)



-- Subscriptions
