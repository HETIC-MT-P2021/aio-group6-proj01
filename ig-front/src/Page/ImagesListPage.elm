module Page.ImagesListPage exposing (..)

import Html exposing (Html, Attribute, h1, h3, p, table, th, td, tr, span, a, button, div, text, map)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

import Http
import Json.Decode exposing (Decoder, field, string, int)
import Json.Encode as Encode
import RemoteData exposing (WebData)

import Navbar
import Footer
import Popup

import Images exposing (Image, ImageId, imagesDecoder)

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
    , url = "http://localhost:8001/api/images"
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
    -- Fetch images
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

        -- Fetch images

        FetchImages ->
            ( { model | images = RemoteData.Loading }, fetchImages )

        ImagesReceived response ->
            ( { model | images = response }, Cmd.none )

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

        deletePopupMsg = PopupMsg (Popup.ShowPopup Popup.DeletePopup "Voulez-vous supprimer l'image ?")
  
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

viewTableHeader : Html Msg
viewTableHeader =
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
                  ([ viewTableHeader ] ++ List.map viewImage actualImages)
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

view : Model -> Html Msg
view model =
  div []
    [ map PopupMsg (Popup.view model.popup)
    , map NavbarMsg (Navbar.view model.navbar)
    , viewImages model.images
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
  