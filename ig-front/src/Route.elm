module Route exposing (Route(..), parseUrl, pushUrl)

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), parse, Parser, oneOf, s, string, int)

import Browser.Navigation as Nav

import Images exposing (ImageId, idParser)
import Categories exposing (CategoryId, idParser)

type Route
    = NotFound
    | Home
    | Images
    | AddImage

parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound

matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Home (s "home")
        , Parser.map Images (s "images")
        , Parser.map AddImage (s "images" </> s "new")
        ]

-- MAKE REDIRECTION TO routeToString

pushUrl : Route -> Nav.Key -> Cmd msg
pushUrl route navKey =
    routeToString route
        |> Nav.pushUrl navKey


routeToString : Route -> String
routeToString route =
    case route of
        NotFound ->
            "/not-found"

        Home ->
            "/home"

        Images ->
            "/images"

        AddImage ->
            "/images/add"