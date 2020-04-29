module Page.CategoriesListPage exposing (..)

import Html exposing (Html, Attribute, h1, p, span, a, button, div, text, map)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

import Navbar
import Footer
import Popup

-- MODEL

type alias Model =
    { navbar : Navbar.Model
    , footer : Footer.Model
    , popup : Popup.Model
    }

init : ( Model, Cmd Msg )
init =
    ( { navbar = Navbar.init
      , footer = Footer.init
      , popup = Popup.init
      }, Cmd.none )

-- UPDATE

type Msg 
    = NavbarMsg Navbar.Msg
    | FooterMsg Footer.Msg
    | PopupMsg Popup.Msg

update : Msg -> Model ->( Model, Cmd Msg )
update msg model =
    case msg of
        NavbarMsg navbarMsg ->
            ( { model | navbar = Navbar.update navbarMsg model.navbar }, Cmd.none )

        FooterMsg footerMsg ->
            ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )
        
        PopupMsg popupMsg ->
            ( { model | popup = Popup.update popupMsg model.popup }, Cmd.none )

-- VIEW

renderButtonCreate : Html Msg
renderButtonCreate =
    let
        createPopupMsg = PopupMsg (Popup.ShowPopup Popup.CreatePopup "Entrez le titre de la nouvelle catégorie")
    in
        button [ class "btn primary", onClick createPopupMsg ] [ text "Créer" ]
        
renderThumbnails : Html Msg
renderThumbnails =
    let
        {-
        3 types of popup :
            - EditPopup
            - CreatePopup
            - DeletePopup
        
        Msg ShowPopup takes 2 args :
            - PopupType
            - Title of Popup
        -}

        editPopupMsg = PopupMsg (Popup.ShowPopup Popup.EditPopup "Veuillez modifier le titre de la catégorie ?")
        deletePopupMsg = PopupMsg (Popup.ShowPopup Popup.DeletePopup "Voulez-vous supprimer la catégorie ?")
  
    in
        button [ class "categories_thumbnail" ] 
        [ p [ class "category_name" ] [ text "Voiture" ]
        , button [ class "icon_container pointer", onClick (deletePopupMsg) ] 
            [ div [ class "icon icon_trash" ] [] ]
        , button [ class "icon_container pointer", onClick (editPopupMsg) ] 
            [ div [ class "icon icon_pen" ] [] ]
        ]

view : Model -> Html Msg
view model =
  div []
    [ map PopupMsg (Popup.view model.popup)
    , map NavbarMsg (Navbar.view model.navbar)
    , div [ class "container" ] 
          [ div [ class "categories_section" ] 
            [ div [ class "categories_head" ] 
                [ h1 [] [ text "catégories" ]
                , renderButtonCreate
                ]
            , div [ class "categories_thumbnails" ] 
                [ renderThumbnails
                , renderThumbnails
                , renderThumbnails
                ]
            ]
          ]
    , map FooterMsg (Footer.view model.footer)
    ]
  