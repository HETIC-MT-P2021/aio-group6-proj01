module Main exposing (..)

import Browser exposing (application, UrlRequest, Document)
import Browser.Navigation exposing (Key, load, pushUrl)
import Html exposing (button, div, h3, text, a, Html, p)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Url exposing (Url, toString)
import Browser.Navigation as Nav


import Route exposing (Route)

-- PAGES

import Page.HomePage as Home
import Page.ImagesListPage as ImagesList
import Page.EditImagePage as EditImage
import Page.AddImagePage as AddImage
import Page.CategoriesListPage as CategoriesList

-- MAIN

main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }

-- MODEL

type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    }

type Page
    = NotFoundPage
    | HomePage Home.Model
    | ImagesListPage ImagesList.Model
    | EditImagePage EditImage.Model
    | AddImagePage AddImage.Model
    | CategoriesListPage CategoriesList.Model

-- UPDATE

type UrlRequest
  = Internal Url
  | External String

type Msg
    = HomePageMsg Home.Msg
    | ImagesListPageMsg ImagesList.Msg
    | EditImagePageMsg EditImage.Msg
    | AddImagePageMsg AddImage.Msg
    | CategoriesListPageMsg CategoriesList.Msg
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case ( msg, model.page ) of
    ( HomePageMsg subMsg, HomePage pageModel ) ->
      let
          ( updatedPageModel, updatedCmd ) =
            Home.update subMsg pageModel
      in
      ( { model | page = HomePage updatedPageModel }
      , Cmd.none
      )

    ( ImagesListPageMsg subMsg, ImagesListPage pageModel ) ->
      let
          ( updatedPageModel, updatedCmd ) =
            ImagesList.update subMsg pageModel
      in
      ( { model | page = ImagesListPage updatedPageModel }
      , Cmd.none
      )

    ( CategoriesListPageMsg subMsg, CategoriesListPage pageModel ) ->
      let
          ( updatedPageModel, updatedCmd ) =
            CategoriesList.update subMsg pageModel
      in
      ( { model | page = CategoriesListPage updatedPageModel }
      , Cmd.none
      )

    ( EditImagePageMsg subMsg, EditImagePage pageModel ) ->
      let
          ( updatedPageModel, updatedCmd ) =
            EditImage.update subMsg pageModel
      in
      ( { model | page = EditImagePage updatedPageModel }
      , Cmd.none
      )

    ( AddImagePageMsg subMsg, AddImagePage pageModel ) ->
      let
          ( updatedPageModel, updatedCmd ) =
            AddImage.update subMsg pageModel
      in
      ( { model | page = AddImagePage updatedPageModel }
      , Cmd.none
      )

    ( LinkClicked urlRequest, _ ) ->
      case urlRequest of
        Browser.Internal url ->
          ( model
          , Nav.pushUrl model.navKey (Url.toString url)
          )

        Browser.External url ->
          ( model
          , Nav.load url
          )

    ( UrlChanged url, _ ) ->
      let
        newRoute =
            Route.parseUrl url
      in
      ( { model | route = newRoute }, Cmd.none )
        |> initCurrentPage
    
    ( _, _ ) ->
      ( model, Cmd.none )

init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            }
    in
    initCurrentPage ( model, Cmd.none )

initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
      ( currentPage, mappedPageCmds ) =
        case model.route of
          Route.NotFound ->
            ( NotFoundPage, Cmd.none )

          Route.Home ->
            let
              ( pageModel, pageCmds ) =
                Home.init
            in
            ( HomePage pageModel, Cmd.map HomePageMsg pageCmds )

          Route.Images ->
            let
              ( pageModel, pageCmds ) =
                ImagesList.init
            in
            ( ImagesListPage pageModel, Cmd.none )

          Route.EditImage ->
            let
              ( pageModel, pageCmds ) =
                EditImage.init
            in
            ( EditImagePage pageModel, Cmd.none )

          Route.AddImage ->
            let
              ( pageModel, pageCmds ) =
                AddImage.init
            in
            ( AddImagePage pageModel, Cmd.none )

          Route.Categories ->
            let
              ( pageModel, pageCmds ) =
                CategoriesList.init
            in
            ( CategoriesListPage pageModel, Cmd.none )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )

-- VIEW

view : Model -> Document Msg
view model =
    { title = "Image Gallery App"
    , body = [ currentView model ]
    }

currentView : Model -> Html Msg
currentView model =
  case model.page of
    NotFoundPage ->
      notFoundView

    HomePage pageModel ->
      Home.view pageModel
        |> Html.map HomePageMsg

    ImagesListPage pageModel ->
      ImagesList.view pageModel
        |> Html.map ImagesListPageMsg

    EditImagePage pageModel ->
      EditImage.view pageModel
        |> Html.map EditImagePageMsg

    AddImagePage pageModel ->
      AddImage.view pageModel
        |> Html.map AddImagePageMsg

    CategoriesListPage pageModel ->
      CategoriesList.view pageModel
        |> Html.map CategoriesListPageMsg

notFoundView : Html msg
notFoundView =
    h3 [] [ text "Oops! The page you requested was not found!" ]