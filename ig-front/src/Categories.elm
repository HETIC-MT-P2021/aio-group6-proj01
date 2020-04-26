module Categories exposing (Category, CategoryId, idToString, categoryDecoder, categoriesDecoder)

import Json.Decode as Decode exposing (Decoder, field, int, list, string)
import Json.Decode.Pipeline exposing (required)

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
    Decode.map CategoryId int

categoriesDecoder : Decoder (List Category)
categoriesDecoder =
    field "hydra:member" (list categoryDecoder)

categoryDecoder : Decoder Category
categoryDecoder =
    Decode.succeed Category
        |> required "id" idDecoder
        |> required "title" string
--        |> required "images" (list)
        |> required "addedAt" string
        |> required "updatedAt" string

idToString : CategoryId -> String
idToString categoryId =
    case categoryId of
        CategoryId id ->
            String.fromInt id

