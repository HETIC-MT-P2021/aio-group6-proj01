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

import Navbar
import Footer

import Images exposing (Image, ImageId, imageDecoder)

-- MODEL

type alias Model =
    { navbar : Navbar.Model
    , footer : Footer.Model
    , navKey : Nav.Key
    , image : WebData Image
    , fileImage : List File
    }

init : ImageId -> Nav.Key -> ( Model, Cmd Msg )
init imageId navKey =
    ( { navbar = Navbar.init
      , footer = Footer.init
      , navKey = navKey
      , image = RemoteData.Loading
      , fileImage = []
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
    | ImageReceived (WebData Image)
    | ChangeCategoryImage String
    | ChangeDescImage String
    | GotFiles (List File)

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

renderInputText : String -> WebData Image -> Html Msg
renderInputText title image =
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
        , input [ type_ "text", placeholder title, value valInput ] []
        ]

renderInputFile : Html Msg
renderInputFile =
    div [ class "input_container" ]
        [ label [] []
        , input [ type_ "file" ] []
        ]

renderInputSubmit : Html Msg
renderInputSubmit =
    button [ class "btn primary" ] [ text "Confirmer" ]

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
        , div [ class "container" ]
            [ div [ class "edit_image_section" ] 
                [ h1 [] [ text "Edition d'image" ]
                , form [ class "edit_image_form" ]
                    [ renderInputText "Catégorie" model.image
                    , renderInputText "Description" model.image
                    , renderSelect "Tags"
                    , div [ class "edit_image_tags" ]
                        [ renderInputFile ]
                    , renderInputSubmit
                    ]
                ]
            ]
        , Html.map FooterMsg (Footer.view model.footer)
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