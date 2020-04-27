module Route exposing (Route(..), parseUrl)

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), parse, Parser, oneOf, s, string)

import Images exposing (ImageId)

type Route
    = NotFound
    | Home
    | Images
    | EditImage
    | AddImage
    | Categories
    | AddCategory


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
        , Parser.map EditImage (s "voiture")
        , Parser.map AddImage (s "images" </> s "new")
        , Parser.map Categories (s "categories")
        , Parser.map AddCategory (s "category" </> s "new")
        ]