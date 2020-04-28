module Images exposing ( Image
                        , ImageId
                        , idToString
                        , imageDecoder
                        , imagesDecoder
                        , emptyImage
                        , newImageEncoder
                        , idParser
                        , imageEncoder )

import Json.Encode as Encode exposing(..)
import Json.Decode as Decode exposing (Decoder, field, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Url.Parser exposing (Parser, custom)

import Time 

type ImageId
    = ImageId Int

type alias Image =
    { id : ImageId
    , category : String
    , path : String
    , description : String
--    , tags : List String
    , addedAt : String
    , updatedAt : String
    }

idDecoder : Decoder ImageId
idDecoder =
    Decode.map ImageId Decode.int

imagesDecoder : Decoder (List Image)
imagesDecoder =
    field "hydra:member" (Decode.list imageDecoder)

imageDecoder : Decoder Image
imageDecoder =
    Decode.succeed Image
        |> required "id" idDecoder
        |> required "category" Decode.string
--        |> required "tags" (Decode.list Decode.string)
        |> required "path" Decode.string
        |> required "description" Decode.string
        |> required "addedAt" Decode.string
        |> required "updatedAt" Decode.string

idToString : ImageId -> String
idToString imageId =
    case imageId of
        ImageId id ->
            String.fromInt id

emptyImage : Image
emptyImage =
    { id = emptyImageId
    , category = ""
    , path = ""
    , description = ""
--    , tags = [""]
    , addedAt = "2020-04-25"
    , updatedAt = "2020-04-25"
    }

emptyImageId : ImageId
emptyImageId =
    ImageId -1

newImageEncoder : Image -> String -> Encode.Value
newImageEncoder image filepath =
  let 
    today = "2020-04-25"
  in
  Encode.object
    [ ( "category", Encode.string image.category )
    , ( "path", Encode.string filepath )
    , ( "description", Encode.string image.description )
    , ( "addedAt", Encode.string image.addedAt )
    , ( "updatedAt", Encode.string image.updatedAt )
    ]

idParser : Parser (ImageId -> a) a
idParser =
    custom "IMAGEID" <|
        \imageId ->
            Maybe.map ImageId (String.toInt imageId)

imageEncoder : Image -> String -> Encode.Value
imageEncoder image filepath =
    Encode.object
        [ ( "id", encodeId image.id )
        , ( "category", Encode.string image.category )
        , ( "path", Encode.string filepath )
        , ( "description", Encode.string image.description )
        , ( "addedAt", Encode.string image.addedAt )
        , ( "addedAt", Encode.string image.updatedAt )
        ]


encodeId : ImageId -> Encode.Value
encodeId (ImageId id) =
    Encode.int id


