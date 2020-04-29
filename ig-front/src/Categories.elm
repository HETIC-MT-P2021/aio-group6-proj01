module Categories exposing ( Category
                           , CategoryId
                           , idToString
                           , categoryDecoder
                           , categoriesDecoder
                           , emptyCategory
                           , newCategoryEncoder
                           , idParser
                           , categoryEncoder )

import Json.Encode as Encode exposing(..)
import Json.Decode as Decode exposing (Decoder, field, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Url.Parser exposing (Parser, custom)

import Time 

type CategoryId
    = CategoryId Int

type alias Category =
    { id : CategoryId
    , title : String
--    , images : List String
    , addedAt : String
    , updatedAt : String
    }

idDecoder : Decoder CategoryId
idDecoder =
    Decode.map CategoryId Decode.int

categoriesDecoder : Decoder (List Category)
categoriesDecoder =
    field "hydra:member" (Decode.list categoryDecoder)

categoryDecoder : Decoder Category
categoryDecoder =
    Decode.succeed Category
        |> required "id" idDecoder
        |> required "title" Decode.string
--        |> required "images" (Decode.list Decode.string)
        |> required "addedAt" Decode.string
        |> required "updatedAt" Decode.string

idToString : CategoryId -> String
idToString categoryId =
    case categoryId of
        CategoryId id ->
            String.fromInt id

emptyCategory : Category 
emptyCategory =
    { id = emptyCategoryId
    , title = ""
--    , images = [""]
    , addedAt = "2020-04-25"
    , updatedAt = "2020-04-25"
    }

emptyCategoryId : CategoryId
emptyCategoryId =
    CategoryId -1

newCategoryEncoder : Category -> Encode.Value
newCategoryEncoder category =
  let 
    today = "2020-04-25"
  in
  Encode.object
    [ ( "title", Encode.string category.title )
    , ( "addedAt", Encode.string category.addedAt )
    , ( "updatedAt", Encode.string category.updatedAt )
    ]

idParser : Parser (CategoryId -> a) a
idParser =
    custom "IMAGEID" <|
        \categoryId ->
            Maybe.map CategoryId (String.toInt categoryId)

categoryEncoder : Category -> Encode.Value
categoryEncoder category =
    let 
        today = "2020-04-25"
    in
    Encode.object
        [ ( "id", encodeId category.id )
        , ( "title", Encode.string category.title )
        , ( "addedAt", Encode.string today )
        , ( "addedAt", Encode.string today )
        ]

encodeId : CategoryId -> Encode.Value
encodeId (CategoryId id) =
    Encode.int id