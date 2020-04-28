module Page.EditCategoryPage exposing (Model, update, view, init, Msg(..))

import Html exposing (..)
import Html.Attributes exposing (class, type_, placeholder, value, name, id, for)
import Html.Events exposing (onClick, onInput)

import Http
import Json.Decode exposing (Decoder, field, string, int)
import Json.Encode as Encode
import RemoteData exposing (WebData)

import Browser.Navigation as Nav

import Navbar
import Footer

import Route

import ApiEndpoint
import Error
import Categories exposing ( Category
                           , CategoryId
                           , categoriesDecoder
                           , categoryDecoder
                           , emptyCategory
                           , newCategoryEncoder )

-- MODEL

type alias Model =
    { navbar : Navbar.Model
    , footer : Footer.Model
    , category : Category
    , saveError : Maybe String
    , navKey : Nav.Key
    }

init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( { navbar = Navbar.init
      , footer = Footer.init
      , category = emptyCategory
      , saveError = Nothing
      , navKey = navKey
      }, Cmd.none )

fetchCategory : CategoryId -> Cmd Msg
fetchCategory categoryId =
    Http.get
        { url = ApiEndpoint.getCategory ++ Categories.idToString categoryId
        , expect =
            categoryDecoder
                |> Http.expectJson (RemoteData.fromResult >> CategoryReceived)
        }

-- UPDATE

type Msg 
    = NavbarMsg Navbar.Msg
    | FooterMsg Footer.Msg
    | ChangeTitleCategory String
    -- GET CATEGORY/{ID}    
    | CategoryReceived WebData Category
    -- PUT CATEGORY/{ID}

addCategory : Category -> Cmd Msg
addCategory category =
  Http.request
    { method = "POST"
    , headers = []
    , url = ApiEndpoint.postCategory
    , body =  Http.jsonBody (newCategoryEncoder category)
    , expect = Http.expectJson CategoryCreated categoryDecoder
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
        
        -- ADD CATEGORY

        ChangeTitleCategory newTitle ->
            let
                updateTitle =
                    RemoteData.map
                        (\imageData ->
                            { imageData | title = newTitle }
                        )
                        model.category
            in
            ( { model | category = updateTitle }, Cmd.none )
        
        CategoryReceived category ->
            ( { model | category = category }, Cmd.none )

-- VIEW

view : Model -> Html Msg
view model =
    div [] 
        [ map NavbarMsg (Navbar.view model.navbar)
        , div [ class "error_message" ] [ viewError model.createError ]
        , ul [] 
            [ li [] [ text model.category.title ]
            , li [] [ text model.category.addedAt ]
            , li [] [ text model.category.updatedAt ]
            ]
        , div [ class "container" ]
            [ div [ class "add_category_section" ] 
                [ h1 [] [ text "Ajout de catégorie" ]
                , div [ class "add_category_form" ]
                    [ renderInputText "Titre" model.category ChangeTitleCategory
                    , renderInputSubmit
                    ]
                ]
            ]
        , map FooterMsg (Footer.view model.footer)
        ]

renderInputText : String -> WebData Category -> (String -> Msg) -> Html Msg
renderInputText title category msg =
    let 
        valInput =
            case category of
                RemoteData.NotAsked ->
                    ""

                RemoteData.Loading ->
                    ""

                RemoteData.Success categoryData ->
                    case title of
                        "Title" ->
                            categoryData.title
                        _ ->
                            ""

                RemoteData.Failure httpError ->
                    ""
    in
    div [ class "input_container" ]
        [ label [] [ text title ]
        , input [ type_ "text", placeholder title, value valInput, onInput msg ] []
        ]

renderInputSubmit : Html Msg
renderInputSubmit =
    --button [ class "btn primary", onClick SaveImage ] [ text "Confirmer" ]

viewError : Maybe String -> Html Msg
viewError maybeError =
    case maybeError of
        Just error ->
            text error

        Nothing ->
            text ""
