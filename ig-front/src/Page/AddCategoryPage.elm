module Page.AddCategoryPage exposing (Model, update, view, init, Msg(..))

import Html exposing (Html, p, h1, div, form, input, label, select, option, button, text, map)
import Html.Attributes exposing (class, type_, placeholder, value, name, id, for)

import Navbar
import Footer

-- MODEL

type alias Model =
    { navbar : Navbar.Model
    , footer : Footer.Model
    }

init : ( Model, Cmd Msg )
init =
    ( { navbar = Navbar.init
      , footer = Footer.init
      }, Cmd.none )

-- UPDATE

type Msg 
    = NavbarMsg Navbar.Msg
    | FooterMsg Footer.Msg

update : Msg -> Model ->( Model, Cmd Msg )
update msg model =
    case msg of
        NavbarMsg navbarMsg ->
            ( { model | navbar = Navbar.update navbarMsg model.navbar }, Cmd.none )

        FooterMsg footerMsg ->
            ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )

type InputType
    = Text
    | Submit

renderInput : String -> InputType -> Html Msg
renderInput title inputType=
    case inputType of
        Text ->
            div [ class "input_container" ]
                [ label [ ] [ text title ]
                , input [ type_ "text", placeholder title ] []
                ]

        Submit ->
            button [ class "btn primary" ] [ text "Confirmer" ]

view : Model -> Html Msg
view model =
    div [] 
        [ map NavbarMsg (Navbar.view model.navbar)
        , div [ class "container" ]
            [ div [ class "add_category_section" ] 
                [ h1 [] [ text "Ajout de catégorie" ]
                , form [ class "add_category_form" ]
                    [ renderInput "Titre" Text
                    , renderInput "" Submit
                    ]
                ]
            ]
        , map FooterMsg (Footer.view model.footer)
        ]
