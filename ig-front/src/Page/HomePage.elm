module Page.HomePage exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, string, int)
import Json.Encode as Encode
import Images exposing (ImageGET, ImageId, imagesDecoder)
import RemoteData exposing (WebData)

import Navbar
import Footer
import Popup

import ApiEndpoint
import Error

-- MODEL

type GetData
  = Failure
  | Loading
  | Success String

type alias Model =
  { navbar : Navbar.Model
  , footer : Footer.Model
  , popup : Popup.Model
  , images : WebData (List ImageGET)
  }

init : ( Model, Cmd Msg )
init =
    ( { navbar = Navbar.init
      , footer = Footer.init
      , popup = Popup.init
      , images = RemoteData.Loading
      }, fetchImages )

fetchImages : Cmd Msg
fetchImages =
  Http.request
    { method = "GET"
    , headers = []
    , url = ApiEndpoint.getImagesList
    , body = Http.emptyBody
    , expect = imagesDecoder
                |> Http.expectJson (RemoteData.fromResult >> ImagesReceived)
    , timeout = Nothing
    , tracker = Nothing
    }

-- UPDATE

type Msg 
  = NavbarMsg Navbar.Msg
  | FooterMsg Footer.Msg
  | PopupMsg Popup.Msg
  -- FetchData
  | FetchImages
  | ImagesReceived (WebData (List ImageGET))

update : Msg -> Model ->( Model, Cmd Msg )
update msg model =
  case msg of
    NavbarMsg navbarMsg ->
      ( { model | navbar = Navbar.update navbarMsg model.navbar }, Cmd.none )

    FooterMsg footerMsg ->
      ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )
    
    PopupMsg popupMsg ->
      ( { model | popup = Popup.update popupMsg model.popup }, Cmd.none )
    
    -- FetchData

    FetchImages ->
      ( { model | images = RemoteData.Loading }, fetchImages )

    ImagesReceived response ->
      ( { model | images = response }, Cmd.none )

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ map PopupMsg (Popup.view model.popup)
    , map NavbarMsg (Navbar.view model.navbar)
--    , viewMsg model
    , div [ class "container" ] 
          [ div [ class "home_categories_section" ] 
            [ h1 [] [ text "catégories" ],
              thumbsCategoriesView model.images 
              , a [ href "/categories", class "link" ] [ text "Afficher toutes les catégories" ]
              , a [ href "category/new", class "link" ] [ text "+ Créer une nouvelle catégorie" ]
            ]
          , div [ class "home_images_section" ] 
              [ h1 [] [ text "images" ],
                div [ class "home_images_thumbnails" ] 
                  [ renderThumbnails
                  , renderThumbnails
                  , renderThumbnails
                  ]
              , a [ href "/images", class "link" ] [ text "Afficher toutes les images" ]
              , a [ href "/image/new", class "link" ] [ text "+ Créer une nouvelle image" ]
            ]
          ]
    , map FooterMsg (Footer.view model.footer)
    ]

hrefEditImgsPage : String -> String
hrefEditImgsPage id =
  "/category/" ++ id ++ "/edit"

thumbsCategoriesView : WebData (List ImageGET) -> Html Msg
thumbsCategoriesView images =
  case images of
    RemoteData.NotAsked ->
        text ""

    RemoteData.Loading ->
        h3 [] [ text "Chargement..." ]

    RemoteData.Success actualImages ->
        div [ class "home_categories_thumbnails" ] (List.map thumbCategoryView actualImages)
        
    RemoteData.Failure httpError ->
          viewFetchError (Error.buildErrorMessage httpError)

thumbCategoryView : ImageGET -> Html Msg
thumbCategoryView image =
  button [ class "home_categories_thumbnail" ] 
    [ p [ class "home_category_name" ] [ text "Voiture" ]
    , a [ class "icon_container pointer" ] 
        [ div [ class "icon icon_trash" ] [] ]
    , a [ href (hrefEditImgsPage (Images.idToString image.id)), class "icon_container pointer" ] 
        [ div [ class "icon icon_pen" ] [] ]
    ]

renderThumbnails : Html Msg
renderThumbnails =
  button [ class "home_images_thumbnail" ] 
    [ div [ class "home_tags_images" ] 
        [ span [ href "#", class "tag_thumbnails" ] [ text "Rouge" ]
        , span [ href "#", class "tag_thumbnails" ] [ text "BMW" ]
        ]
    , button [ class "icon_container pointer" ] 
        [ div [ class "icon icon_trash" ] [] ]
    , button [ class "icon_container pointer" ] 
        [ div [ class "icon icon_pen" ] [] ]
    , a [ href "#", class "home_image_category" ] [ text "Voiture" ]
    ]

viewFetchError : String -> Html Msg
viewFetchError errorMessage =
    case errorMessage of
      "" -> div [ class "error_message hidden" ] [ text errorMessage ]
      _ -> div [ class "error_message" ] [ text errorMessage ] 

  