module Popup exposing (init, update, Msg(..), Model, view, PopupType(..))

import Html exposing (Html, a, ul, li, div, text, p, button, input)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, href)

-- MODEL

type PopupType
    = EmptyPopup
    | EditPopup
    | DeletePopup

type alias Model =
    { title : String
    , isPopupOpen : Bool
    , popupType : PopupType
    }

init : Model
init = 
    { title = "Test"
    , isPopupOpen = False
    , popupType = EmptyPopup
    }

-- UPDATE

type Msg
  = NoOp
  | ShowPopup PopupType String
  | HidePopup

update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        ShowPopup popupType title ->
            { model | isPopupOpen = True, popupType = popupType, title = title }
        
        HidePopup ->
            { model | isPopupOpen = False }

-- VIEW

renderPopup : Model -> String -> Html Msg
renderPopup model classname =
  case model.popupType of
    EmptyPopup ->
      div [] []
    
    EditPopup ->
      renderEditPopup model classname

    DeletePopup ->
      renderDeletePopup model classname

renderEditPopup : Model -> String -> Html Msg
renderEditPopup model classname = 
  div [ class classname ]
    [ div [ class "popup_container" ]
      [ button [ class "btn icon icon_close", onClick HidePopup ] []
      , p [ class "popup_title"] [ text model.title ]
      , input [ class "popup_input" ] [ text "Write Name" ]
      , button [ class "btn primary" ] [ text "Confirmer" ]
      ]
    ]

renderDeletePopup : Model -> String -> Html Msg
renderDeletePopup model classname = 
  div [ class classname ]
    [ div [ class "popup_container" ]
      [ button [ class "btn icon icon_close", onClick HidePopup ] []
      , p [ class "popup_title"] [ text model.title ]
      , div [ class "buttons_container" ] 
        [ button [ class "btn danger" ] [ text "Annuler" ]
        , button [ class "btn primary" ] [ text "Supprimer" ]
        ]
      ]
    ]

view : Model -> Html Msg
view model =
  case model.isPopupOpen of
    True ->
      renderPopup model "popup_overlay"
    
    False ->
      renderPopup model "popup_overlay hidden"