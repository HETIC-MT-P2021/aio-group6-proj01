module Popup.Messages exposing (Msg(..), NavItem, Author)

type alias NavItem =
  { name : String
  , link : String
  }

type alias Author = 
  { name : String
  , mail : String
  }

type Msg
  --popup
  = NoOp
  | ShowPopup
  | HidePopup
  --navbar
  | SetItemsNav (List NavItem)
  --footer
  | SetAuthors (List Author)