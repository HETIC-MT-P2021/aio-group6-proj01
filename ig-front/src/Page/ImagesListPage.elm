module Page.ImagesListPage exposing (..)

import Html exposing (..)
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

renderButtonCreate : Html Msg
renderButtonCreate =
    a [ href "/images/new", class "btn primary" ] [ text "Créer" ]

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
        , a [ href "/image/1/edit", class "icon_container icon_container_edit pointer" ] 
            [ div [ class "icon icon_pen" ] [] ]
        , a [ href "#", class "image_category" ] [ text "Voiture" ]
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
    div [ class "error_message" ] [ text errorMessage ]    

viewImage : Image -> Html Msg
viewImage image =
    {-let
        tags = List.map (\tag -> li [] [ text tag ]) image.tags
    in-}
    div []
        [ p []
            [ text (Images.idToString image.id) ]
        , p []
            [ text image.category ]
        --, ul [] tags
        , p []
            [ text image.path ]
        , p []
            [ text image.description ]
        , p []
            [ text image.addedAt ]
        , p []
            [ text image.updatedAt ]
        ]
  