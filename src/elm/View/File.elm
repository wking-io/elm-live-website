module View.File exposing (viewContent, viewItem)

import FileSystem exposing (Focus)
import FileSystem.File as File
import FileSystem.File.Extension as Extension
import FileSystem.File.Id as Id exposing (Id)
import Html exposing (Html)
import Html.Attributes as HA
import Html.Events exposing (onClick)


viewItem : Focus -> File.Data -> (Id -> msg) -> Html msg
viewItem focus { id, name, extension } msg =
    Html.li [ HA.attribute "role" "presentation" ]
        [ Html.a
            [ HA.id (Id.toString id ++ "-tab")
            , HA.attribute "role" "tab"
            , HA.attribute "aria-controls" (Id.toString id)
            , onClick (msg id)
            ]
            [ Html.text (name ++ Extension.toExtension extension) ]
        ]


viewContent : File.Data -> Html msg
viewContent { id, contents } =
    Html.div
        [ HA.attribute "role" "tabpanel"
        , HA.attribute "aria-labelledby" (Id.toString id ++ "-tab")
        , HA.id (Id.toString id)
        ]
        [ Html.text contents ]
