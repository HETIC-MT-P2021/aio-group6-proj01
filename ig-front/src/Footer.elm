module Footer exposing (footerView)

import Html exposing (Html, a, ul, li, div, text, p)
import Html.Attributes exposing (class, href)

import Popup.Messages exposing (Author)
import Popup.Models exposing (Model)

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

footerView : Model -> Html msg
footerView model =
  div [ class "footer_container" ]
    [ p [] [ text "Image Gallery" ],
      renderAuthors model.authors ]
