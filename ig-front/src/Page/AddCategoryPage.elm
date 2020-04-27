module Page.AddCategoryPage exposing (Model, update, view, init, Msg(..))

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
    , createError : Maybe String
    , navKey : Nav.Key
    }

init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( { navbar = Navbar.init
      , footer = Footer.init
      , category = emptyCategory
      , createError = Nothing
      , navKey = navKey
      }, Cmd.none )

-- UPDATE

type Msg 
    = NavbarMsg Navbar.Msg
    | FooterMsg Footer.Msg
    | ChangeTitleCategory String
    -- ADD CATEGORY
    | AddCategory
    | CategoryCreated (Result Http.Error Category)

addCategory : Category -> Cmd Msg
addCategory category =
  Http.request
    { method = "POST"
    , headers = []
    , url = "http://localhost:8001/api/categories"
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

        ChangeTitleCategory title ->
          let
              oldCategory =
                model.category

              updateTitle =
                { oldCategory | title = title }
          in
          ( { model | category = updateTitle }, Cmd.none )
        
        CategoryCreated (Ok category) ->
          ( { model | category = category, createError = Nothing }
          , Route.pushUrl Route.Categories model.navKey )

        CategoryCreated (Err error) ->
          ( { model | createError = Just (buildErrorMessage error) }, Cmd.none )

        AddCategory ->
          ( model, addCategory model.category )

type InputType
    = Text
    | Submit

renderInput : String -> InputType -> Html Msg
renderInput title inputType=
    case inputType of
        Text ->
            div [ class "input_container" ]
                [ label [ ] [ text title ]
                , input [ type_ "text", placeholder title, onInput ChangeTitleCategory ] []
                ]

        Submit ->
            button [ class "btn primary", onClick AddCategory ] [ text "Confirmer" ]

viewError : Maybe String -> Html Msg
viewError maybeError =
    case maybeError of
        Just error ->
            text error

        Nothing ->
            text ""

view : Model -> Html Msg
view model =
    div [] 
        [ map NavbarMsg (Navbar.view model.navbar)
        , viewError model.createError
        , ul [] 
            [ li [] [ text model.category.title ]
            , li [] [ text model.category.addedAt ]
            , li [] [ text model.category.updatedAt ]
            ]
        , div [ class "container" ]
            [ div [ class "add_category_section" ] 
                [ h1 [] [ text "Ajout de catégorie" ]
                , div [ class "add_category_form" ]
                    [ renderInput "Titre" Text
                    , renderInput "" Submit
                    ]
                ]
            ]
        , map FooterMsg (Footer.view model.footer)
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
