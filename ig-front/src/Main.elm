module Main exposing (..)

import Browser
import Html exposing (Html, h1, p, span, a, button, div, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

-- HTML modules
import Navbar
import Footer

main =
  Browser.sandbox { init = 0, update = update, view = view }





--update





update : msg -> number -> number
update msg num = num





--view





type ThumbnailsType
  = ThumbnailsCategories
  | ThumbnailsImages


renderThumbnails : ThumbnailsType -> Html msg
renderThumbnails msg = 
  case msg of
    ThumbnailsCategories ->
      a [ href "#", class "home_categories_thumbnail" ] 
        [ p [ class "home_category_name" ] [ text "Voiture" ]
        , a [ href "#", class "icon_container" ] 
            [ div [ class "icon icon_trash" ] [] ]
        , a [ href "#", class "icon_container" ] 
            [ div [ class "icon icon_pen" ] [] ]
        ]

    ThumbnailsImages ->
      a [ href "#", class "home_images_thumbnail" ] 
        [ div [ class "home_tags_images" ] 
            [ span [ href "#", class "tag_thumbnails" ] [ text "Rouge" ]
            , span [ href "#", class "tag_thumbnails" ] [ text "BMW" ]
            ]
        , a [ href "#", class "icon_container" ] 
            [ div [ class "icon icon_trash" ] [] ]
        , a [ href "#", class "icon_container" ] 
            [ div [ class "icon icon_pen" ] [] ]
        , a [ href "#", class "home_image_category" ] [ text "Voiture" ]
        ]
        

view model =
  div []
    [ Navbar.main
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
    , Footer.main
    ]