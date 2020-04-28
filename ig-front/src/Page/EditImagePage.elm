module Page.EditImagePage exposing (Model, update, view, init, Msg(..))

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

import Route

import Navbar
import Footer

import Images exposing (Image, ImageId, imageDecoder, imageEncoder)

-- MODEL

type alias Model =
    { navbar : Navbar.Model
    , footer : Footer.Model
    , navKey : Nav.Key
    , image : WebData Image
    , fileImage : List File
    , saveError : Maybe String
    }

init : ImageId -> Nav.Key -> ( Model, Cmd Msg )
init imageId navKey =
    ( { navbar = Navbar.init
      , footer = Footer.init
      , navKey = navKey
      , image = RemoteData.Loading
      , fileImage = []
      , saveError = Nothing
      }, fetchImage imageId )

fetchImage : ImageId -> Cmd Msg
fetchImage imageId =
    Http.get
        { url = "http://localhost:8001/api/images/" ++ Images.idToString imageId
        , expect =
            imageDecoder
                |> Http.expectJson (RemoteData.fromResult >> ImageReceived)
        }

-- UPDATE

type Msg 
    = NavbarMsg Navbar.Msg
    | FooterMsg Footer.Msg
    | ChangeCategoryImage String
    | ChangeDescImage String
    | GotFiles (List File)
    -- GET IMAGE/{ID}
    | ImageReceived (WebData Image)
    -- PUT IMAGE/{ID}
    | SaveImage
    | ImageSaved (Result Http.Error Image)

update : Msg -> Model ->( Model, Cmd Msg )
update msg model =
    case msg of
        NavbarMsg navbarMsg ->
            ( { model | navbar = Navbar.update navbarMsg model.navbar }, Cmd.none )

        FooterMsg footerMsg ->
            ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )

        ImageReceived image ->
            ( { model | image = image }, Cmd.none )

        ChangeCategoryImage newCategory ->
            let
                updateCategory =
                    RemoteData.map
                        (\imageData ->
                            { imageData | category = newCategory }
                        )
                        model.image
            in
            ( { model | image = updateCategory }, Cmd.none )
        
        ChangeDescImage newDescription ->
            let
                updateDesc =
                    RemoteData.map
                        (\imageData ->
                            { imageData | description = newDescription }
                        )
                        model.image
            in
            ( { model | image = updateDesc }, Cmd.none )

        GotFiles files ->
            ( { model | fileImage = files }, Cmd.none)

        SaveImage ->
            ( model, saveImage model )

        ImageSaved (Ok imageData) ->
            let
                image =
                    RemoteData.succeed imageData
            in
            ( { model | image = image, saveError = Nothing }
            , Route.pushUrl Route.Images model.navKey
            )
        
        ImageSaved (Err error) ->
            ( { model | saveError = Just (buildErrorMessage error) }
            , Cmd.none
            )

saveImage : Model -> Cmd Msg
saveImage model =
    case model.image of
        RemoteData.Success imageData ->
            let
                editImageUrl =
                    "http://localhost:8001/api/images/"
                        ++ Images.idToString imageData.id

                filepath = ""
            in
            Http.request
                { method = "PUT"
                , headers = []
                , url = editImageUrl
                , body = Http.jsonBody (imageEncoder imageData filepath)
                , expect = Http.expectJson ImageSaved imageDecoder
                , timeout = Nothing
                , tracker = Nothing
                }

        _ ->
            Cmd.none

renderInputText : String -> WebData Image -> (String -> Msg) -> Html Msg
renderInputText title image msg =
    let 
        valInput =
            case image of
                RemoteData.NotAsked ->
                    ""

                RemoteData.Loading ->
                    ""

                RemoteData.Success imageData ->
                    case title of
                        "Catégorie" ->
                            imageData.category
                        "Description" ->
                            imageData.description
                        _ ->
                            ""

                RemoteData.Failure httpError ->
                    ""
    in
    div [ class "input_container" ]
        [ label [] [ text title ]
        , input [ type_ "text", placeholder title, value valInput, onInput msg ] []
        ]

renderInputFile : Html Msg
renderInputFile =
    div [ class "input_container" ]
        [ label [] []
        , input [ type_ "file" ] []
        ]

renderInputSubmit : Html Msg
renderInputSubmit =
    button [ class "btn primary", onClick SaveImage ] [ text "Confirmer" ]

renderSelect : String -> Html Msg
renderSelect label_txt =
    div [ class "input_container" ]
        [ label [ for "tags" ] [ text label_txt ]
        , select [ name "tags", id "tags" ]
            [ option [ value "" ] [ text "Choisir" ]
            , option [ value "" ] [ text "Choisir" ]
            ]
        ]

view : Model -> Html Msg
view model =
    div [] 
        [ Html.map NavbarMsg (Navbar.view model.navbar)
        , viewError model.saveError
        , div [ class "container" ]
            [ div [ class "edit_image_section" ] 
                [ h1 [] [ text "Edition d'image" ]
                , div [ class "edit_image_form" ]
                    [ renderInputText "Catégorie" model.image ChangeCategoryImage
                    , renderInputText "Description" model.image ChangeDescImage
                    , renderSelect "Tags"
                    , div [ class "edit_image_tags" ]
                        [ renderInputFile ]
                    , renderInputSubmit
                    ]
                ]
            ]
        , Html.map FooterMsg (Footer.view model.footer)
        ]

viewError : Maybe String -> Html Msg
viewError maybeError =
    case maybeError of
        Just error ->
            text error

        Nothing ->
            text ""

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