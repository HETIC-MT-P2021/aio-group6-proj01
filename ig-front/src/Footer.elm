module Footer exposing (..)

import Browser
import Html exposing (Html, a, ul, li, div, text, p)
import Html.Attributes exposing (class, href)





--model





--All data needed to load Footer
type alias Model =
    { name : String
    , mail : String
    , authors : List Author
    }
    

--Create new alias type instead of object
--Object does not exit in ELM
type alias Author = 
    { name : String
    , mail : String
    }


--When footer loaded init function launched
init : Model
init = 
    { name = ""
    , mail = ""
    , authors = [
                    { name = "Valentin", mail = "valentin.moretpro1@gmail.com" },
                    { name = "Oussama", mail = "oussama.ferarma@gmail.com" },
                    { name = "Wyllis", mail = "wyllismonteiro@gmail.com" }
                ]
    }





--update





type Msg
    = UpdateName String
    | UpdateMail String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateName name ->
            { model | name = name }
        UpdateMail mail ->
            { model | mail = mail }





--view





renderMailto : String -> String
renderMailto mail =
    String.append "mailto:" mail


renderAuthor : Author -> Html msg
renderAuthor author =
    a [ href (renderMailto author.mail), class "link" ] [ text author.name ]


renderAuthors : List Author -> Html msg
renderAuthors authors =
    let 
        author =
            List.map renderAuthor authors
    in
        ul [] author


view model =
  div [ class "footer_container" ]
    [ p [] [ text "Image Gallery" ],
      renderAuthors model.authors ]





main =
    view init