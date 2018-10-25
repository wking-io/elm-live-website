module View.Pure.Checkbox exposing (view)

import Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as HA
import Html.Styled.Events exposing (onClick)


type alias Config msg =
    { id : String
    , msg : msg
    , name : String
    }


view : Config msg -> Html msg
view { msg, name, id } =
    Html.styled Html.div
        [ Css.overflow Css.hidden ]
        []
        [ checkboxLabel [ HA.for id, onClick msg ] [ Html.text name ]
        , checkboxInput [ HA.id id, HA.type_ "checkbox", onClick msg ] []
        ]


checkboxInput : List (Attribute msg) -> List (Html msg) -> Html msg
checkboxInput =
    Html.styled Html.input
        [ Css.position Css.absolute
        , Css.left (Css.px -9999)
        ]


checkboxLabel : List (Attribute msg) -> List (Html msg) -> Html msg
checkboxLabel =
    Html.styled Html.label
        [ Css.padding2 (Css.rem 1) (Css.rem 3) ]
