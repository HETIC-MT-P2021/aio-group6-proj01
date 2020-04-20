module Navbar exposing (navbarView)

import Html exposing (Html, a, button, div, text, p)
import Html.Attributes exposing (class, href)

import Popup.Messages exposing (NavItem)
import Popup.Models exposing (Model)


--view
renderItem : NavItem -> Html msg
renderItem item = 
  a [ class "item_nav", href item.link] [ text item.name ]

navbarView : Model -> Html msg
navbarView model =
  let 
    navbar =
      List.map renderItem model.itemsNav
    in
      div [ class "navbar_container" ] navbar