module Images exposing (Image, ImageId, idToString, imageDecoder, imagesDecoder)

import Json.Decode as Decode exposing (Decoder, field, int, list, string)
import Json.Decode.Pipeline exposing (required)

type ImageId
    = ImageId Int

type alias Image =
    { id : ImageId
    , category : String
--    , tags : List String
    , path : String
    , description : String
    , addedAt : String
    , updatedAt : String
    }

idDecoder : Decoder ImageId
idDecoder =
    Decode.map ImageId int

imagesDecoder : Decoder (List Image)
imagesDecoder =
    field "hydra:member" (list imageDecoder)

imageDecoder : Decoder Image
imageDecoder =
    Decode.succeed Image
        |> required "id" idDecoder
        |> required "category" string
--        |> required "tags" (list)
        |> required "path" string
        |> required "description" string
        |> required "addedAt" string
        |> required "updatedAt" string

idToString : ImageId -> String
idToString imageId =
    case imageId of
        ImageId id ->
            String.fromInt id