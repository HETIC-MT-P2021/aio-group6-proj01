module Page.HomePage exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, string, int)
import Json.Encode as Encode
import Images exposing (Image, ImageId, imagesDecoder)
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
  , images : WebData (List Image)
  }

type ThumbnailsType
  = ThumbnailsCategories
  | ThumbnailsImages

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
  | ImagesReceived (WebData (List Image))

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
    , viewImages model.images
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

viewImages : WebData (List Image) -> Html Msg
viewImages images =
    case images of
        RemoteData.NotAsked ->
            text "test"

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success actualImages ->
            div [] 
              [ h3 [] [ text "Posts" ]
              , ul []
                  (List.map viewImage actualImages)
              ]

        RemoteData.Failure httpError ->
          viewFetchError (Error.buildErrorMessage httpError)

viewFetchError : String -> Html Msg
viewFetchError errorMessage =
    case errorMessage of
      "" -> div [ class "error_message hidden" ] [ text errorMessage ]
      _ -> div [ class "error_message" ] [ text errorMessage ] 

viewImage : Image -> Html Msg
viewImage image = 
  {-let
    tags = List.map (\tag -> li [] [ text tag ]) image.tags
  in-}
  div [] [
    p [] [ text (Images.idToString image.id) ]
  , p [] [ text image.category ]
  --, ul [] tags
  , p [] [ text image.path ]
  , p [] [ text image.description ]
  , p [] [ text image.addedAt ]
  , p [] [ text image.updatedAt ]
  ]
  