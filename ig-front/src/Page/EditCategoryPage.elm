module Page.EditCategoryPage exposing (Model, update, view, init, Msg(..))

import Html exposing (..)
import Html.Attributes exposing (class, type_, placeholder, value, name, id, for)
import Html.Events exposing (onClick, onInput)

import Http
import Json.Decode as Decode exposing (Decoder, field, string, int, map)
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
                           , newCategoryEncoder
                           , categoryEncoder )

-- MODEL

type alias Model =
    { navbar : Navbar.Model
    , footer : Footer.Model
    , category : WebData Category
    , saveError : Maybe String
    , navKey : Nav.Key
    }

init : CategoryId -> Nav.Key -> ( Model, Cmd Msg )
init categoryId navKey =
    ( { navbar = Navbar.init
      , footer = Footer.init
      , category = RemoteData.Loading
      , saveError = Nothing
      , navKey = navKey
      }, fetchCategory categoryId )

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
    | CategoryReceived (WebData Category)
    -- PUT CATEGORY/{ID}
    | SaveCategory
    | CategorySaved (Result Http.Error Category)


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
                        (\categoryData ->
                            { categoryData | title = newTitle }
                        )
                        model.category
            in
            ( { model | category = updateTitle }, Cmd.none )
        
        CategoryReceived category ->
            ( { model | category = category }, Cmd.none )

        SaveCategory ->
            ( model, saveCategory model.category )

        CategorySaved (Ok categoryData) ->
            let
                category =
                    RemoteData.succeed categoryData
            in
            ( { model | category = category, saveError = Nothing }
            , Route.pushUrl Route.Categories model.navKey
            )
        
        CategorySaved (Err error) ->
            ( { model | saveError = Just (Error.buildErrorMessage error) }
            , Cmd.none
            )

saveCategory : WebData Category -> Cmd Msg
saveCategory category =
    case category of
        RemoteData.Success categoryData ->
            let
                editCategoryUrl =
                    ApiEndpoint.putCategory ++ Categories.idToString categoryData.id
            in
            Http.request
                { method = "PUT"
                , headers = []
                , url = editCategoryUrl
                , body = Http.jsonBody (categoryEncoder categoryData)
                , expect = Http.expectJson CategorySaved categoryDecoder
                , timeout = Nothing
                , tracker = Nothing
                }

        _ ->
            Cmd.none


-- VIEW

view : Model -> Html Msg
view model =
    div [] 
        [ Html.map NavbarMsg (Navbar.view model.navbar)
        , div [ class "error_message" ] [ viewError model.saveError ]
        , div [ class "container" ]
            [ div [ class "add_category_section" ] 
                [ h1 [] [ text "Ajout de catégorie" ]
                , div [ class "add_category_form" ]
                    [ renderInputText "Titre" model.category ChangeTitleCategory
                    , renderInputSubmit
                    ]
                ]
            ]
        , Html.map FooterMsg (Footer.view model.footer)
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
                        "Titre" ->
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
    button [ class "btn primary", onClick SaveCategory ] [ text "Confirmer" ]

viewError : Maybe String -> Html Msg
viewError maybeError =
    case maybeError of
        Just error ->
            text error

        Nothing ->
            text ""
