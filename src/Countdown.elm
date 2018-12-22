module Countdown exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
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
    , lookup : ( Bool, String )
    }


initialModel : Model
initialModel =
    Model "" [] ( False, "" )



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
            word |> String.length |> (\n -> (n * 6) + 2) |> toString
    in
    a
        [ class "button is-outlined  is-primary"
        , style [ ( "font-size", size ++ "px" ) ]
        , onClick (ShowDefinition word)
        ]
        [ text word ]



-- Update


type Msg
    = ChangeLetters String
    | NewWords (Result Http.Error (List String))
    | HideDefinition
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
            ( { model | words = [ toString error ] }, Cmd.none )

        ShowDefinition word ->
            ( { model | lookup = ( True, word ) }, Cmd.none )



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
