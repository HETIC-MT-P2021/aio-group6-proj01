module Page.AddImagePage exposing (Model, update, view, init, Msg(..))

import Html exposing (..)
import Html.Attributes exposing (class, type_, placeholder, value, name, id, for)
import Html.Events exposing (onClick, onInput, on)

import Http
import Json.Decode as Decode exposing (Decoder, field, string, int, map)
import Json.Encode as Encode
import RemoteData exposing (WebData)
import File exposing (File)
import Regex

import Browser.Navigation as Nav

import Navbar
import Footer

import Route

import ApiEndpoint
import Error
import Images exposing ( Image
                       , ImageId
                       , imagesDecoder
                       , imageDecoder
                       , emptyImage
                       , newImageEncoder )

-- MODEL

type alias Model =
    { navbar : Navbar.Model
    , footer : Footer.Model
    , image : Image
    , fileImage : List File
    , createError : Maybe String
    , navKey : Nav.Key
    }

init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( { navbar = Navbar.init
      , footer = Footer.init
      , image = emptyImage
      , fileImage = []
      , createError = Nothing
      , navKey = navKey
      }, Cmd.none )

-- UPDATE

type Msg 
    = NavbarMsg Navbar.Msg
    | FooterMsg Footer.Msg
    | ChangeCategoryImage String
    | ChangeDescImage String
    | GotFiles (List File)
    -- ADD IMAGE
    | AddImage
    | ImageCreated (Result Http.Error Image)

addImage : Model -> Cmd Msg
addImage model =
    let 
        filepath = "/images/" ++ getFilename model.fileImage
    in 
    Http.request
        { method = "POST"
        , headers = []
        , url = ApiEndpoint.postImage
        , body =  Http.jsonBody (newImageEncoder model.image filepath)
        , expect = Http.expectJson ImageCreated imageDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

update : Msg -> Model ->( Model, Cmd Msg )
update msg model =
    case msg of
        NavbarMsg navbarMsg ->
            ( { model | navbar = Navbar.update navbarMsg model.navbar }, Cmd.none )

        FooterMsg footerMsg ->
            ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )

        -- ADD IMAGE

        ChangeCategoryImage category ->
          let
              oldImage =
                model.image

              updateCategory =
                { oldImage | category = category }
          in
          ( { model | image = updateCategory }, Cmd.none )
        
        ChangeDescImage description ->
          let
              oldImage =
                model.image

              updateDesc =
                { oldImage | description = description }
          in
          ( { model | image = updateDesc }, Cmd.none )

        GotFiles files ->
            ( { model | fileImage = files }, Cmd.none)
        
        ImageCreated (Ok image) ->
          ( { model | image = image, createError = Nothing }
          , Route.pushUrl Route.Images model.navKey )

        ImageCreated (Err error) ->
          ( { model | createError = Just (Error.buildErrorMessage error) }, Cmd.none )

        AddImage ->
          ( model, addImage model )

renderInputText : String -> (String -> Msg) -> Html Msg
renderInputText title msg =
    div [ class "input_container" ]
        [ label [] [ text title ]
        , input [ type_ "text", placeholder title, onInput msg ] []
        ]

renderInputFile : Html Msg
renderInputFile =
    div [ class "input_container" ]
        [ label [] []
        , input [ type_ "file", on "change" (Decode.map GotFiles filesDecoder) ] []
        ]

renderInputSubmit : Html Msg
renderInputSubmit =
    button [ class "btn primary", onClick AddImage ] [ text "Confirmer" ]

renderSelect : String -> Html Msg
renderSelect label_txt =
    div [ class "input_container" ]
        [ label [ for "tags" ] [ text label_txt ]
        , select [ name "tags", id "tags" ]
            [ option [ value "" ] [ text "Choisir" ]
            , option [ value "" ] [ text "Choisir" ]
            ]
        ]

viewError : Maybe String -> Html Msg
viewError maybeError =
    case maybeError of
        Just error ->
            text error

        Nothing ->
            text ""

getFilename : List File -> String
getFilename files =
    let
        filename = (Debug.toString files)
        filenameReplaceStart = String.replace "[<" "" filename
        filenameReplaceEnd = String.replace ">]" "" filenameReplaceStart
    in
        filenameReplaceEnd

view : Model -> Html Msg
view model =
    div [] 
        [ Html.map NavbarMsg (Navbar.view model.navbar)
        , div [ class "error_message" ] [ viewError model.createError ]
        , ul [] 
            [ li [] [ text model.image.category ]
            , li [] [ text model.image.description ]
            , li [] [ text model.image.addedAt ]
            , li [] [ text model.image.updatedAt ]
            ]
        , div [ class "container" ]
            [ div [ class "add_image_section" ] 
                [ h1 [] [ text "Ajout d'image" ]
                , div [ class "add_image_form" ]
                    [ renderInputText "Catégorie" ChangeCategoryImage
                    , renderInputText "Description" ChangeDescImage
                    , renderSelect "Tags"
                    , div [ class "add_image_tags" ]
                        [ renderInputFile ]
                    , renderInputSubmit
                    ]
                ]
            ]
        , Html.map FooterMsg (Footer.view model.footer)
        ]

filesDecoder : Decode.Decoder (List File)
filesDecoder =
  Decode.at ["target","files"] (Decode.list File.decoder)