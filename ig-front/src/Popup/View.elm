module Popup.View exposing (popupView)

import Html exposing (Html, Attribute, h1, p, span, a, button, div, input, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

import Popup.Messages exposing (Msg(..), PopupType(..))
import Popup.Models exposing (Model)

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

popupView : Model -> Html Msg
popupView model =
  case model.isPopupOpen of
    True ->
      renderPopup model "popup_overlay"

    False ->
      renderPopup model "popup_overlay hidden"      