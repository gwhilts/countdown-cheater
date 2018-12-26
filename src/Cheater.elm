module Cheater exposing (main)

import Browser
import Html exposing (text)



-- Main


main =
    Browser.sandbox
        { init = initModel
        , view = view
        , update = update
        }



-- Model


initModel =
    { name = "Bullock" }



-- View


view model =
    text ("Hello, " ++ initModel.name)



-- Update


update msg model =
    model
