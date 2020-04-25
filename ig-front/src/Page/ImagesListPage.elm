module Page.ImagesListPage exposing (..)

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
    a [ href "/add", class "btn primary" ] [ text "Créer" ]

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
        button [ class "images_thumbnail" ] 
        [ div [ class "image_tags" ] 
            [ span [ class "tag_thumbnails" ] [ text "Rouge" ]
            , span [ class "tag_thumbnails" ] [ text "BMW" ]
            ]
        , button [ class "icon_container icon_container_trash pointer", onClick (deletePopupMsg) ] 
            [ div [ class "icon icon_trash" ] [] ]
        , a [ href "/voiture", class "icon_container icon_container_edit pointer" ] 
            [ div [ class "icon icon_pen" ] [] ]
        , a [ href "#", class "image_category" ] [ text "Voiture" ]
        ]

view : Model -> Html Msg
view model =
  div []
    [ map PopupMsg (Popup.view model.popup)
    , map NavbarMsg (Navbar.view model.navbar)
    , div [ class "container" ] 
          [ div [ class "images_section" ] 
            [ div [ class "images_head" ] 
                [ h1 [] [ text "images" ]
                , renderButtonCreate
                ]
            , div [ class "images_thumbnails" ] 
                [ renderThumbnails
                , renderThumbnails
                , renderThumbnails
                ]
            ]
          ]
    , map FooterMsg (Footer.view model.footer)
    ]
  