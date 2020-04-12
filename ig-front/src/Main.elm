module Main exposing (..)

import Browser
import Html exposing (Html, h1, p, a, button, div, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

-- HTML modules
import Navbar
import Footer

main =
  Browser.sandbox { init = 0, update = update, view = view }

-- Not useful for project
-- Delete when homepage is done
type Msg = Increment | Decrement

-- Methods to change model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

-- Show view
view model =
  div []
    [ Navbar.main,
      div [ class "container" ] 
        [ div [ class "home_categories_section" ] 
          [ h1 [] [ text "catégories" ],
            div [ class "home_categories_thumbnails" ] 
              [ a [ href "#", class "home_categories_thumbnail" ] 
                  [ p [ class "home_category_name" ] [ text "Voiture" ],
                    a [ href "#", class "icon_container" ] 
                      [ div [ class "icon icon_trash" ] [] ],
                    a [ href "#", class "icon_container" ] 
                      [ div [ class "icon icon_pen" ] [] ]
                  ],
                a [ href "#", class "home_categories_thumbnail" ] 
                  [ p [ class "home_category_name" ] [ text "Animaux" ],
                    a [ href "#", class "icon_container" ] 
                      [ div [ class "icon icon_trash" ] [] ],
                    a [ href "#", class "icon_container" ] 
                      [ div [ class "icon icon_pen" ] [] ]
                  ],
                a [ href "#", class "home_categories_thumbnail" ]
                  [ p [ class "home_category_name" ] [ text "Motos" ],
                    a [ href "#", class "icon_container" ] 
                      [ div [ class "icon icon_trash" ] [] ],
                    a [ href "#", class "icon_container" ] 
                      [ div [ class "icon icon_pen" ] [] ]
                  ]
              ],
            a [ href "#", class "link" ] [ text "Afficher toutes les catégories" ],
            a [ href "#", class "link" ] [ text "+ Créer une nouvelle catégorie" ]
          ],
          div [ class "home_images_section" ] 
            [ h1 [] [ text "images" ],
              div [ class "home_images_thumbnails" ] 
                [ a [ href "#", class "home_images_thumbnail" ] 
                    [ a [ href "#", class "icon_container" ] 
                        [ div [ class "icon icon_trash" ] [] ],
                      a [ href "#", class "icon_container" ] 
                        [ div [ class "icon icon_pen" ] [] ],
                      a [ href "#", class "home_image_category" ] [ text "Voiture" ]
                    ],
                  a [ href "#", class "home_images_thumbnail" ] 
                    [ a [ href "#", class "icon_container" ] 
                        [ div [ class "icon icon_trash" ] [] ],
                      a [ href "#", class "icon_container" ] 
                        [ div [ class "icon icon_pen" ] [] ],
                      a [ href "#", class "home_image_category" ] [ text "Voiture" ]                      
                  ],
                  a [ href "#", class "home_images_thumbnail" ]
                    [ a [ href "#", class "icon_container" ] 
                        [ div [ class "icon icon_trash" ] [] ],
                      a [ href "#", class "icon_container" ] 
                        [ div [ class "icon icon_pen" ] [] ],
                      a [ href "#", class "home_image_category" ] [ text "Voiture" ]                      
                  ]
              ],
            a [ href "#", class "link" ] [ text "Afficher toutes les images" ],
            a [ href "#", class "link" ] [ text "+ Créer une nouvelle image" ]
          ]
        ],
      Footer.main
    ]