module Cheater exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, id)



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
    div
        []
        [ h1 [] [ text ("Hello, " ++ model.name) ]
        ]



-- Update


update msg model =
    model
