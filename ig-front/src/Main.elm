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

import Page.HomePage as HomePage

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
    | HomePage HomePage.Model

-- UPDATE

type UrlRequest
  = Internal Url
  | External String

type Msg
    = HomePageMsg HomePage.Msg
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( HomePageMsg subMsg, HomePage pageModel ) ->
          let
              ( updatedPageModel, updatedCmd ) =
                HomePage.update subMsg pageModel
          in
          ( { model | page = HomePage updatedPageModel }
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
                HomePage.init
            in
            ( HomePage pageModel, Cmd.map HomePageMsg pageCmds )
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
          HomePage.view pageModel
            |> Html.map HomePageMsg

notFoundView : Html msg
notFoundView =
    h3 [] [ text "Oops! The page you requested was not found!" ]