module Route exposing (Route(..), parseUrl, pushUrl)

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), parse, Parser, oneOf, s, string)

import Browser.Navigation as Nav

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

        EditImage ->
            "/images"
        
        AddImage ->
            "/images/add"        
        
        Categories ->
            "/categories"                
        
        AddCategory ->
            "/category/new"
        