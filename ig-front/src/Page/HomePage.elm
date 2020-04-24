module Page.HomePage exposing (..)

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
  , show : String
  }

type ThumbnailsType
  = ThumbnailsCategories
  | ThumbnailsImages

init : ( Model, Cmd Msg )
init =
    ( { navbar = Navbar.init
      , footer = Footer.init
      , popup = Popup.init
      , show = "False"
      }, Cmd.none )

-- UPDATE

type Msg 
  = NavbarMsg Navbar.Msg
  | FooterMsg Footer.Msg
  | PopupMsg Popup.Msg
  | ChangeShow String

update : Msg -> Model ->( Model, Cmd Msg )
update msg model =
  case msg of
    NavbarMsg navbarMsg ->
      ( { model | navbar = Navbar.update navbarMsg model.navbar }, Cmd.none )

    FooterMsg footerMsg ->
      ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )
    
    PopupMsg popupMsg ->
      ( { model | popup = Popup.update popupMsg model.popup }, Cmd.none )
    
    ChangeShow show ->
      ( { model | show = show }, Cmd.none )

-- VIEW

renderThumbnails : ThumbnailsType -> Html Msg
renderThumbnails thumbnailsType =
  let

    {-
      2 types of popup :
        - EditPopup
        - DeletePopup
      
      Msg ShowPopup takes 2 args :
        - PopupType
        - Title of Popup
    -}
    editPopupMsgImage = PopupMsg (Popup.ShowPopup Popup.EditPopup "Veuillez modifier le titre de l'image ?")
    deletePopupMsgImage = PopupMsg (Popup.ShowPopup Popup.DeletePopup "Voulez-vous supprimer l'image ?")

    editPopupMsgCategory = PopupMsg (Popup.ShowPopup Popup.EditPopup "Veuillez modifier le titre de la catégorie ?")
    deletePopupMsgCategory = PopupMsg (Popup.ShowPopup Popup.DeletePopup "Voulez-vous supprimer la catégorie ?")
  
  in
  case thumbnailsType of
    ThumbnailsCategories ->
      button [ class "home_categories_thumbnail" ] 
        [ p [ class "home_category_name" ] [ text "Voiture" ]
        , button [ class "icon_container pointer", onClick (deletePopupMsgCategory)  ] 
            [ div [ class "icon icon_trash" ] [] ]
        , button [ class "icon_container pointer", onClick (editPopupMsgCategory) ] 
            [ div [ class "icon icon_pen" ] [] ]
        ]

    ThumbnailsImages ->
      button [ class "home_images_thumbnail" ] 
        [ div [ class "home_tags_images" ] 
            [ span [ href "#", class "tag_thumbnails" ] [ text "Rouge" ]
            , span [ href "#", class "tag_thumbnails" ] [ text "BMW" ]
            ]
        , button [ class "icon_container pointer", onClick (deletePopupMsgImage) ] 
            [ div [ class "icon icon_trash" ] [] ]
        , button [ class "icon_container pointer", onClick (editPopupMsgImage) ] 
            [ div [ class "icon icon_pen" ] [] ]
        , a [ href "#", class "home_image_category" ] [ text "Voiture" ]
        ]

view : Model -> Html Msg
view model =
  let 
    isShow = 
      case model.show of
        "False" -> p [] [ text "True" ]
        "True" -> p [] [ text "False" ]
        _ -> p [] [ text "Test" ]
  in        
  div []
    [ isShow
    , map PopupMsg (Popup.view model.popup)
    , map NavbarMsg (Navbar.view model.navbar)
    , div [ class "container" ] 
          [ div [ class "home_categories_section" ] 
            [ h1 [] [ text "catégories" ],
              div [ class "home_categories_thumbnails" ] 
                [ renderThumbnails ThumbnailsCategories
                , renderThumbnails ThumbnailsCategories
                , renderThumbnails ThumbnailsCategories
                ]
              , a [ href "/categories", class "link" ] [ text "Afficher toutes les catégories" ]
              , a [ href "#", class "link" ] [ text "+ Créer une nouvelle catégorie" ]
            ]
          , div [ class "home_images_section" ] 
              [ h1 [] [ text "images" ],
                div [ class "home_images_thumbnails" ] 
                  [ renderThumbnails ThumbnailsImages
                  , renderThumbnails ThumbnailsImages
                  , renderThumbnails ThumbnailsImages
                  ]
              , a [ href "/images", class "link" ] [ text "Afficher toutes les images" ]
              , a [ href "#", class "link" ] [ text "+ Créer une nouvelle image" ]
            ]
          ]
    , map FooterMsg (Footer.view model.footer)
    ]
  