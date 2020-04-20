module Page.Home exposing (..)

import Html exposing (Html, Attribute, h1, p, span, a, button, div, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

import Popup.Models exposing (model, Model)
import Popup.Messages exposing (Msg(..))

import Popup.View exposing (popupView)
import Navbar exposing (navbarView)
import Footer exposing (footerView)

type ThumbnailsType
  = ThumbnailsCategories
  | ThumbnailsImages

--view
renderThumbnails : ThumbnailsType -> Html Msg
renderThumbnails thumbnailsType = 
  case thumbnailsType of
    ThumbnailsCategories ->
      a [ href "#", class "home_categories_thumbnail" ] 
        [ p [ class "home_category_name" ] [ text "Voiture" ]
        , button [ class "icon_container pointer", onClick ShowPopup ] 
            [ div [ class "icon icon_trash" ] [] ]
        , button [ class "icon_container pointer" ] 
            [ div [ class "icon icon_pen" ] [] ]
        ]

    ThumbnailsImages ->
      a [ href "#", class "home_images_thumbnail" ] 
        [ div [ class "home_tags_images" ] 
            [ span [ href "#", class "tag_thumbnails" ] [ text "Rouge" ]
            , span [ href "#", class "tag_thumbnails" ] [ text "BMW" ]
            ]
        , button [ class "icon_container pointer", onClick ShowPopup ] 
            [ div [ class "icon icon_trash" ] [] ]
        , button [ class "icon_container pointer" ] 
            [ div [ class "icon icon_pen" ] [] ]
        , a [ href "#", class "home_image_category" ] [ text "Voiture" ]
        ]

view : Model -> Html Msg
view model =
  div []
    [ popupView model
    , navbarView model
    , div [ class "container" ] 
        [ div [ class "home_categories_section" ] 
          [ h1 [] [ text "catégories" ],
            div [ class "home_categories_thumbnails" ] 
              [ renderThumbnails ThumbnailsCategories
              , renderThumbnails ThumbnailsCategories
              , renderThumbnails ThumbnailsCategories
              ]
            , a [ href "#", class "link" ] [ text "Afficher toutes les catégories" ]
            , a [ href "#", class "link" ] [ text "+ Créer une nouvelle catégorie" ]
          ]
        , div [ class "home_images_section" ] 
            [ h1 [] [ text "images" ],
              div [ class "home_images_thumbnails" ] 
                [ renderThumbnails ThumbnailsImages
                , renderThumbnails ThumbnailsImages
                , renderThumbnails ThumbnailsImages
                ]
            , a [ href "#", class "link" ] [ text "Afficher toutes les images" ]
            , a [ href "#", class "link" ] [ text "+ Créer une nouvelle image" ]
          ]
        ]
    , footerView model
    ]