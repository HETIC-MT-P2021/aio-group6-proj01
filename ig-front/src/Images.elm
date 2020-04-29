module Images exposing ( ImageGET
                        , ImagePOST
                        , ImageId
                        , idToString
                        , imageDecoderGET
                        , imageDecoderPOST
                        , imagesDecoder
                        , emptyImage
                        , idParser
                        , newImageEncoder )

import Json.Encode as Encode exposing(..)
import Json.Decode as Decode exposing (Decoder, field, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Url.Parser exposing (Parser, custom)

import Time 

type ImageId
    = ImageId Int

-- GET

type alias ImageGET =
    { id : ImageId
    , category : ImageCategory
    , path : String
    }

type alias ImageCategory =
    { title : String
    }

imagesDecoder : Decoder (List ImageGET)
imagesDecoder =
    field "hydra:member" (Decode.list imageDecoderGET)

imageDecoderGET : Decoder ImageGET
imageDecoderGET =
    Decode.succeed ImageGET
        |> required "id" idDecoder
        |> required "category" imageCategoryDecoder
        |> required "path" Decode.string

imageCategoryDecoder : Decoder ImageCategory
imageCategoryDecoder =
    Decode.succeed ImageCategory
        |> required "title" Decode.string

-- POST

type alias ImagePOST =
    { category : String
    , path : String
    }

emptyImage : ImagePOST
emptyImage =
    { category = ""
    , path = ""
    }

imageDecoderPOST : Decoder ImagePOST
imageDecoderPOST =
    Decode.succeed ImagePOST
        |> required "category" Decode.string
        |> required "path" Decode.string

newImageEncoder : ImagePOST -> Encode.Value
newImageEncoder image =
  Encode.object
    [ ( "category", Encode.string "/api/categories/2" )
    , ( "path", Encode.string "test.jpg" )
    ]

--

idDecoder : Decoder ImageId
idDecoder =
    Decode.map ImageId Decode.int

idToString : ImageId -> String
idToString imageId =
    case imageId of
        ImageId id ->
            String.fromInt id

emptyImageId : ImageId
emptyImageId =
    ImageId -1

idParser : Parser (ImageId -> a) a
idParser =
    custom "IMAGEID" <|
        \imageId ->
            Maybe.map ImageId (String.toInt imageId)

{-imageEncoder : Image -> String -> Encode.Value
imageEncoder image filepath =
    Encode.object
        [ ( "id", encodeId image.id )
        , ( "category", Encode.string image.category )
        , ( "path", Encode.string filepath )
        , ( "description", Encode.string image.description )
        --, ( "addedAt", Encode.string image.addedAt )
        --, ( "addedAt", Encode.string image.updatedAt )
        ]-}

encodeId : ImageId -> Encode.Value
encodeId (ImageId id) =
    Encode.int id
