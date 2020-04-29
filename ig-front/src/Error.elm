module Error exposing (..)

import Html exposing (..)
import Http

buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            "L'erreur suivante est survenue : " ++ message

        Http.Timeout ->
            "Le serveur a pris trop de temps à répondre, merci de réessayer ultérieurement"

        Http.NetworkError ->
            "Impossible de récupérer les informations, merci de réessayer ultérieurement"

        Http.BadStatus statusCode ->
            "La requête n'a pas été effectué (code : " ++ String.fromInt statusCode ++ ")"

        Http.BadBody message ->
            "L'erreur suivante est survenue : " ++ message     