module Popup.Messages exposing (Msg(..), PopupType(..), NavItem, Author)

type alias NavItem =
  { name : String
  , link : String
  }

type alias Author = 
  { name : String
  , mail : String
  }

type PopupType
  = EmptyPopup
  | EditPopup
  | DeletePopup

type Msg
  --popup
  = NoOp
  | ShowPopup PopupType String
  | HidePopup
  --navbar
  | SetItemsNav (List NavItem)
  --footer
  | SetAuthors (List Author)