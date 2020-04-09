module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

-- HTML modules
import Navbar 

main =
  Browser.sandbox { init = 0, update = update, view = view }

-- Not useful for project
-- Delete when homepage is done
type Msg = Increment | Decrement

-- Methods to change model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

-- Show view
view model =
  div []
    [ Navbar.main ]