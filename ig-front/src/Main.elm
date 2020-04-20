module Main exposing (..)

import Browser

-- HTML modules
import Navbar
import Footer

import Page.Home exposing (..)

-- Popup modules
import Popup.Models exposing (model, Model)
import Popup.Messages exposing (Msg)
import Popup.Update exposing (update)

import Page.Home exposing (view)

main =
  Browser.sandbox { init = init, update = update, view = view }

init : Model
init =
  model

