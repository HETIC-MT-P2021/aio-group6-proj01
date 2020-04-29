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
    , deleteError : Maybe String
    }

init : ( Model, Cmd Msg )
init =
    ( { navbar = Navbar.init
      , footer = Footer.init
      , popup = Popup.init
      , images = RemoteData.Loading
      , deleteError = Nothing
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
    -- FETCH IMAGES
    | FetchImages
    | ImagesReceived (WebData (List Image))
    -- DELETE IMAGE
    | DeleteImage ImageId
    | ImageDeleted (Result Http.Error String)

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

        -- DELETE IMAGE

        DeleteImage imageId ->
            ( model, deleteImage imageId )

        ImageDeleted (Ok _) ->
            ( model, fetchImages )

        ImageDeleted (Err error) ->
            ( { model | deleteError = Just (Error.buildErrorMessage error) }
            , Cmd.none
            )

deleteImage : ImageId -> Cmd Msg
deleteImage imageId =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = ApiEndpoint.deleteImage ++ Images.idToString imageId
        , body = Http.emptyBody
        , expect = Http.expectString ImageDeleted
        , timeout = Nothing
        , tracker = Nothing
        }

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ map PopupMsg (Popup.view model.popup)
    , map NavbarMsg (Navbar.view model.navbar)
    , viewImages model.images
    , viewFetchError (viewDeleteError model.deleteError)
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
    button [ class "images_thumbnail" ] 
    [ div [ class "image_tags" ] 
        [ span [ class "tag_thumbnails" ] [ text "Rouge" ]
        , span [ class "tag_thumbnails" ] [ text "BMW" ]
        ]
    , button [ class "icon_container icon_container_trash pointer" ] 
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
    case errorMessage of
        "" -> div [ class "error_message hidden" ] [ text errorMessage ]
        _ -> div [ class "error_message" ] [ text errorMessage ]  

viewDeleteError : Maybe String -> String
viewDeleteError maybeError =
    case maybeError of
        Just error ->
            "La suppression n'a pas été effectué, veuillez réeesayer"

        Nothing ->
            ""  

viewImage : Image -> Html Msg
viewImage image =
    {-let
        tags = List.map (\tag -> li [] [ text tag ]) image.tags
    in-}
    div []
        [ button [ onClick (DeleteImage image.id) ]
            [ text (Images.idToString image.id) ]
        , p []
            [ text image.category.title ]
        --, ul [] tags
        , p []
            [ text image.path ]
        , p []
            [ text image.description ]
        --, p []
        --    [ text image.addedAt ]
        --, p []
        --    [ text image.updatedAt ]
        ]
  