module Popup.Models exposing (Model, model)

import Popup.Messages exposing (PopupType(..), NavItem, Author)

type alias Model =
  { --popup
    title : String
  , isPopupOpen : Bool
  , popupType : PopupType
    --navbar
  , itemsNav : List NavItem
    --footer
  , authors : List Author
  }

model : Model
model =
  { --popup
    title = "Test"
  , isPopupOpen = False
  , popupType = EmptyPopup
    --navbar
  , itemsNav = [ { name = "Accueil"
                 , link = "/"
                 }
               , { name = "Images"
                 , link = "/images"
                 }
               , { name = "Catégories"
                 , link = "/categories"
                 }
               ]
    --footer
  , authors = [ { name = "Valentin"
                , mail = "valentin.moretpro1@gmail.com" }
              , { name = "Oussama"
                , mail = "oussama.ferarma@gmail.com" }
              , { name = "Wyllis"
                , mail = "wyllismonteiro@gmail.com" }
              ]  
  }