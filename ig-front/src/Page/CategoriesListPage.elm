module Page.CategoriesListPage exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

import Http
import Json.Decode exposing (Decoder, field, string, int)
import Json.Encode as Encode
import RemoteData exposing (WebData)

import Browser.Navigation as Nav

import Navbar
import Footer
import Popup

import ApiEndpoint
import Error
import Categories exposing ( Category
                           , CategoryId
                           , categoriesDecoder
                           , emptyCategory
                           , newCategoryEncoder )

-- MODEL

type GetData
  = Failure
  | Loading
  | Success String

type alias Model =
    { navbar : Navbar.Model
    , footer : Footer.Model
    , popup : Popup.Model
    , categories : WebData (List Category)
    , saveError : Maybe String
    , navKey : Nav.Key
    }

init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( { navbar = Navbar.init
      , footer = Footer.init
      , popup = Popup.init 
      , categories = RemoteData.Loading
      , saveError = Nothing
      , navKey = navKey
      }, fetchCategories )

fetchCategories : Cmd Msg
fetchCategories =
  Http.request
    { method = "GET"
    , headers = []
    , url = ApiEndpoint.getCategoriesList
    , body = Http.emptyBody
    , expect = categoriesDecoder
                |> Http.expectJson (RemoteData.fromResult >> CategoriesReceived)
    , timeout = Nothing
    , tracker = Nothing
    }

-- UPDATE

type Msg 
    = NavbarMsg Navbar.Msg
    | FooterMsg Footer.Msg
    | PopupMsg Popup.Msg
    -- GET CATEGORIES
    | FetchCategories
    | CategoriesReceived (WebData (List Category))

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavbarMsg navbarMsg ->
            ( { model | navbar = Navbar.update navbarMsg model.navbar }, Cmd.none )

        FooterMsg footerMsg ->
            ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )
        
        PopupMsg popupMsg ->
            ( { model | popup = Popup.update popupMsg model.popup }, Cmd.none )

        -- GET CATEGORIES

        FetchCategories ->
            ( { model | categories = RemoteData.Loading }, fetchCategories )

        CategoriesReceived response ->
            ( { model | categories = response }, Cmd.none )

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ map PopupMsg (Popup.view model.popup)
    , map NavbarMsg (Navbar.view model.navbar)
    , viewCategories model.categories
    , div [ class "container" ] 
          [ div [ class "categories_section" ] 
            [ div [ class "categories_head" ] 
                [ h1 [] [ text "catégories" ]
                , renderButtonCreate
                ]
            , div [ class "categories_thumbnails" ] 
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
    let
        createPopupMsg = PopupMsg (Popup.ShowPopup Popup.CreatePopup "Entrez le titre de la nouvelle catégorie")
    in
        a [ href "/category/new", class "btn primary" ] [ text "Créer" ]
        
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

        deletePopupMsg = PopupMsg (Popup.ShowPopup Popup.DeletePopup "Voulez-vous supprimer la catégorie ?")
  
    in
        button [ class "categories_thumbnail" ] 
        [ p [ class "category_name" ] [ text "Voiture" ]
        , button [ class "icon_container icon_container_trash pointer", onClick (deletePopupMsg) ] 
            [ div [ class "icon icon_trash" ] [] ]
        , a [ href "/category/1/edit", class "icon_container icon_container_edit pointer" ] 
            [ div [ class "icon icon_pen" ] [] ]
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
              , ul []
                  (List.map viewCategory actualCategories)
              ]

        RemoteData.Failure httpError ->
          viewFetchError (Error.buildErrorMessage httpError)

viewFetchError : String -> Html Msg
viewFetchError errorMessage =
    div [ class "error_message" ] [ text errorMessage ] 

viewCategory : Category -> Html Msg
viewCategory category =
    {-let
        images = List.map (\image -> li [] [ text image ]) category.images
    in-}
  div []
    [ p []
        [ text (Categories.idToString category.id) ]
    , p []
        [ text category.title ]
    --, ul [] images
    , p []
        [ text category.addedAt ]
    , p []
        [ text category.updatedAt ]
    ]
  