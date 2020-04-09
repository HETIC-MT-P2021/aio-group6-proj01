module Navbar exposing (..)

import Html exposing (Html, a, button, div, text, p)
import Html.Attributes exposing (class, href)

type alias Model =
  { home : String
  , images : String
  , categories : String
  }

type Msg
  = Home String
  | Images String
  | Categories String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Home home ->
      { model | home = home }

    Images images ->
      { model | images = images }

    Categories categories ->
      { model | categories = categories }

view model =
  div [ class "navbar_container" ]
    [ a [ class "item_nav", href "/"] [ text model.home ],
      a [ class "item_nav", href "/images"] [ text model.images ],
      a [ class "item_nav", href "/categories"] [ text model.categories ] ]

main =
    view { home = "Accueil", images = "Images", categories = "Catégories" }