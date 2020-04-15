module Popup exposing (..)

import Html exposing (Html, a, ul, li, div, text, p, button)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)





--model





--All data needed to load Footer
type alias Model =
    { title : String
    , popupType : PopupType
    , display : String
    }
    

type PopupType
    = Nothing
    | Delete
    | Edit


--When footer loaded init function launched
init : Model
init = 
    { title = ""
    , popupType = Nothing
    , display = "popup_overlay"
    }





--update





type Msg
    = UpdateTitle String
    | UpdatePopupType PopupType
    | DisplayPopup String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateTitle title ->
            { model | title = title }
        UpdatePopupType popupType ->
            { model | popupType = popupType }
        DisplayPopup value ->
            if model.display == "popup_overlay" 
                then { model | display = "popup_overlay hidden" }
                else { model | display = "popup_overlay" }





--view





view model =
  div [ class model.display ]
    [ div [ class "popup_container" ]
        [ a [ href "#", class "icon icon_close", onClick DisplayPopup ] []
        , p [ class "popup_title" ] [ text "Voulez-vous supprimez cette image ?" ]
        , div [ class "buttons_container" ]
            [ button [ class "btn danger" ] [ text "Annuler" ]
            , button [ class "btn primary" ] [ text "Supprimer" ] 
            ]
        ] 
    ]





main =
    view init