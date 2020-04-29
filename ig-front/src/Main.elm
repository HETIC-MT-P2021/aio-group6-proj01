module Main exposing (..)

import Browser exposing (application, UrlRequest, Document)
import Browser.Navigation exposing (Key, load, pushUrl)
import Html exposing (h3, text, Html)
import Url exposing (Url, toString)
import Browser.Navigation as Nav

import Route exposing (Route)

-- PAGES

import Page.HomePage as Home
import Page.ImagesListPage as ImagesList
import Page.AddImagePage as AddImage


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

type Page
  = NotFoundPage
  | HomePage Home.Model
  | ImagesListPage ImagesList.Model
  | AddImagePage AddImage.Model

-- UPDATE

type UrlRequest
  = Internal Url
  | External String

type Msg
  -- MSG PAGE
  = HomePageMsg Home.Msg
  | ImagesListPageMsg ImagesList.Msg
  | AddImagePageMsg AddImage.Msg
  -- MANAGE URL
  | LinkClicked Browser.UrlRequest
  | UrlChanged Url

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case ( msg, model.page ) of

    -- UPDATE PAGE

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
      , Cmd.map ImagesListPageMsg updatedCmd
      )

    ( AddImagePageMsg subMsg, AddImagePage pageModel ) ->
      let
        ( updatedPageModel, updatedCmd ) =
          AddImage.update subMsg pageModel
      in
      ( { model | page = AddImagePage updatedPageModel }
      , Cmd.map AddImagePageMsg updatedCmd
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

initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
  let
    ( currentPage, mappedPageCmds ) =
      
      -- SHOW PAGES

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
            ( ImagesListPage pageModel, Cmd.map ImagesListPageMsg pageCmds )

        Route.AddImage ->
          let
            ( pageModel, pageCmds ) =
              AddImage.init model.navKey
          in
            ( AddImagePage pageModel, Cmd.map AddImagePageMsg pageCmds )

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
    
    AddImagePage pageModel ->
      AddImage.view pageModel
        |> Html.map AddImagePageMsg

notFoundView : Html msg
notFoundView =
    h3 [] [ text "Cette page n'a pas été trouvé" ]
