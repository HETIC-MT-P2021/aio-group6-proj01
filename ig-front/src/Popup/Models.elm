module Popup.Models exposing (Model, model)

import Popup.Messages exposing (NavItem, Author)

type alias Model =
  { --popup
    title : String
  , isPopupOpen : Bool
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