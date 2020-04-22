module Popup.Update exposing (update)

import Browser
import Url

import Popup.Models exposing (Model, model)
import Popup.Messages exposing (Msg(..))

update : Msg -> Model -> Model
update msg model =
  case msg of
    NoOp ->
      model

    ShowPopup popupType title ->
      { model | isPopupOpen = True, popupType = popupType, title = title }
      
    HidePopup ->
      { model | isPopupOpen = False }

    SetItemsNav items ->
      { model | itemsNav = items }

    SetAuthors items ->
      { model | authors = items }