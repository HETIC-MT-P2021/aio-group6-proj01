module Page.HomePage exposing (..)

import Html exposing (Html, Attribute, h1, p, span, a, button, div, tr, th, td, h3, table, text, map)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

import Http
import Json.Decode exposing (Decoder, field, string, int)
import Json.Encode as Encode
import RemoteData exposing (WebData)

import Images exposing (Image, ImageId, imagesDecoder)
import Categories exposing (Category, CategoryId, categoriesDecoder)

import Navbar
import Footer
import Popup

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
  , categories : WebData (List Category)
  }

type ThumbnailsType
  = ThumbnailsCategories
  | ThumbnailsImages

init : ( Model, (Cmd Msg, Cmd Msg) )
init =
    ( { navbar = Navbar.init
      , footer = Footer.init
      , popup = Popup.init
      , images = RemoteData.Loading
      , categories = RemoteData.Loading
      }, fetchAll )

fetchAll : (Cmd Msg, Cmd Msg)
fetchAll =
  (Http.request
    { method = "GET"
    , headers = []
    , url = "http://localhost:8001/api/images"
    , body = Http.emptyBody
    , expect = imagesDecoder
                |> Http.expectJson (RemoteData.fromResult >> ImagesReceived)
    , timeout = Nothing
    , tracker = Nothing
    },

    Http.request
      { method = "GET"
      , headers = []
      , url = "http://localhost:8001/api/categories"
      , body = Http.emptyBody
      , expect = categoriesDecoder
                  |> Http.expectJson (RemoteData.fromResult >> CategoriesReceived)
      , timeout = Nothing
      , tracker = Nothing
      })

fetchImages : (Cmd Msg, Cmd Msg)
fetchImages =
  (Http.request
    { method = "GET"
    , headers = []
    , url = "http://localhost:8001/api/images"
    , body = Http.emptyBody
    , expect = imagesDecoder
                |> Http.expectJson (RemoteData.fromResult >> ImagesReceived)
    , timeout = Nothing
    , tracker = Nothing
    }, Cmd.none)

fetchCategories : (Cmd Msg, Cmd Msg)
fetchCategories =
  (Cmd.none,
   Http.request
    { method = "GET"
    , headers = []
    , url = "http://localhost:8001/api/categories"
    , body = Http.emptyBody
    , expect = categoriesDecoder
                |> Http.expectJson (RemoteData.fromResult >> CategoriesReceived)
    , timeout = Nothing
    , tracker = Nothing
    })

-- UPDATE

type Msg 
  = NavbarMsg Navbar.Msg
  | FooterMsg Footer.Msg
  | PopupMsg Popup.Msg
  -- Fetch all
  | FetchAll
  | AllReceived (WebData (List Image), WebData (List Category))
  -- Fetch images
  | FetchImages
  | ImagesReceived (WebData (List Image))
  -- Fetch categories
  | FetchCategories
  | CategoriesReceived (WebData (List Category))

update : Msg -> Model -> ( Model, (Cmd Msg, Cmd Msg) )
update msg model =
  case msg of
    NavbarMsg navbarMsg ->
      ( { model | navbar = Navbar.update navbarMsg model.navbar }, (Cmd.none, Cmd.none) )

    FooterMsg footerMsg ->
      ( { model | footer = Footer.update footerMsg model.footer }, (Cmd.none,Cmd.none) )
    
    PopupMsg popupMsg ->
      ( { model | popup = Popup.update popupMsg model.popup }, (Cmd.none, Cmd.none) )
    
    -- Fetch images

    FetchImages ->
      ( { model | images = RemoteData.Loading }, fetchImages )

    ImagesReceived response ->
      ( { model | images = response }, (Cmd.none, Cmd.none) )

    -- Fetch categories

    FetchCategories ->
      ( { model | categories = RemoteData.Loading }, fetchCategories )

    CategoriesReceived response ->
      ( { model | categories = response }, (Cmd.none, Cmd.none) )

    -- Fetch all

    FetchAll ->
      ( { model | images = RemoteData.Loading, categories = RemoteData.Loading }, fetchAll )

    AllReceived (images, categories) ->
      ( { model | images = images, categories = categories }, (Cmd.none, Cmd.none) )

{-    GotText result ->
      case result of
        Ok fullText ->
          ({ model | text = (Success fullText)  }, Cmd.none)

        Err _ ->
          ({ model | text = (Failure)  }, Cmd.none)
-}
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

-- view images

viewTableHeaderImages : Html Msg
viewTableHeaderImages =
  tr []
      [ th []
          [ text "id" ]
      , th []
          [ text "category" ]
      , th []
          [ text "path" ]
      , th []
          [ text "description" ]
      , th []
          [ text "addedAt" ]
      , th []
          [ text "updatedAt" ]
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
              , table []
                  ([ viewTableHeaderImages ] ++ List.map viewImage actualImages)
              ]

        RemoteData.Failure httpError ->
          viewFetchError (buildErrorMessage httpError)

viewFetchError : String -> Html Msg
viewFetchError errorMessage =
    let
        errorHeading =
            "Couldn't fetch posts at this time."
    in
    div []
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ errorMessage)
        ]

buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message

viewImage : Image -> Html Msg
viewImage image =
  tr []
    [ td []
        [ text (Images.idToString image.id) ]
    , td []
        [ text image.category ]
    , td []
        [ text image.path ]
    , td []
        [ text image.description ]
    , td []
        [ text image.addedAt ]
    , td []
        [ text image.updatedAt ]
    ]

-- view categories


viewTableHeaderCategories : Html Msg
viewTableHeaderCategories =
  tr []
      [ th []
          [ text "id" ]
      , th []
          [ text "title" ]
      , th []
          [ text "addedAt" ]
      , th []
          [ text "updatedAt" ]
      ]

viewCategories : WebData (List Category) -> Html Msg
viewCategories categories =
    case categories of
        RemoteData.NotAsked ->
            text "test"

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success actualCategories ->
            div [] 
              [ h3 [] [ text "Posts" ]
              , table []
                  ([ viewTableHeaderCategories ] ++ List.map viewCategory actualCategories)
              ]

        RemoteData.Failure httpError ->
          viewFetchError (buildErrorMessage httpError)

viewCategory : Category -> Html Msg
viewCategory category =
  tr []
    [ td []
        [ text (Categories.idToString category.id) ]
    , td []
        [ text category.title ]
    , td []
        [ text category.addedAt ]
    , td []
        [ text category.updatedAt ]
    ]

view : Model -> Html Msg
view model =
  div []
    [ map PopupMsg (Popup.view model.popup)
    , map NavbarMsg (Navbar.view model.navbar)
--    , viewMsg model
    , viewImages model.images
    , viewCategories model.categories
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
  