module Page.CategoriesListPage exposing (..)

import Html exposing (Html, Attribute, h1, h3, table, tr, th, td, p, span, a, button, div, text, map)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

import Http
import Json.Decode exposing (Decoder, field, string, int)
import Json.Encode as Encode
import RemoteData exposing (WebData)

import Navbar
import Footer
import Popup

import Categories exposing (Category, CategoryId, categoriesDecoder)


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
    }

init : ( Model, Cmd Msg )
init =
    ( { navbar = Navbar.init
      , footer = Footer.init
      , popup = Popup.init
      , categories = RemoteData.Loading
      }, fetchCategories )

fetchCategories : Cmd Msg
fetchCategories =
  Http.request
    { method = "GET"
    , headers = []
    , url = "http://localhost:8001/api/categories"
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
    -- Fetch categories
    | FetchCategories
    | CategoriesReceived (WebData (List Category))

update : Msg -> Model ->( Model, Cmd Msg )
update msg model =
    case msg of
        NavbarMsg navbarMsg ->
            ( { model | navbar = Navbar.update navbarMsg model.navbar }, Cmd.none )

        FooterMsg footerMsg ->
            ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )
        
        PopupMsg popupMsg ->
            ( { model | popup = Popup.update popupMsg model.popup }, Cmd.none )

        FetchCategories ->
            ( { model | categories = RemoteData.Loading }, fetchCategories )

        CategoriesReceived response ->
            ( { model | categories = response }, Cmd.none )

-- VIEW

renderButtonCreate : Html Msg
renderButtonCreate =
    let
        createPopupMsg = PopupMsg (Popup.ShowPopup Popup.CreatePopup "Entrez le titre de la nouvelle catégorie")
    in
        button [ class "btn primary", onClick createPopupMsg ] [ text "Créer" ]
        
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

        editPopupMsg = PopupMsg (Popup.ShowPopup Popup.EditPopup "Veuillez modifier le titre de la catégorie ?")
        deletePopupMsg = PopupMsg (Popup.ShowPopup Popup.DeletePopup "Voulez-vous supprimer la catégorie ?")
  
    in
        button [ class "categories_thumbnail" ] 
        [ p [ class "category_name" ] [ text "Voiture" ]
        , button [ class "icon_container pointer", onClick (deletePopupMsg) ] 
            [ div [ class "icon icon_trash" ] [] ]
        , button [ class "icon_container pointer", onClick (editPopupMsg) ] 
            [ div [ class "icon icon_pen" ] [] ]
        ]

viewTableHeader : Html Msg
viewTableHeader =
  tr []
      [ th []
          [ text "id" ]
      , th []
          [ text "title" ]
      , th []
          [ text "addedAt" ]
      , th []
          [ text "updatedAt" ]
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
              , table []
                  ([ viewTableHeader ] ++ List.map viewCategory actualCategories)
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

viewCategory : Category -> Html Msg
viewCategory category =
  tr []
    [ td []
        [ text (Categories.idToString category.id) ]
    , td []
        [ text category.title ]
    , td []
        [ text category.addedAt ]
    , td []
        [ text category.updatedAt ]
    ]

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
  