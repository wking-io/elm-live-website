module View.FileSystem exposing (files)

import FileSystem exposing (FileSystem(..), Focus)
import FileSystem.File.Extension as Extension
import FileSystem.File.Id exposing (Id)
import FileSystem.Folder exposing (Visibility(..))
import FileSystem.Node as Node exposing (Node(..))
import Html exposing (Html)
import View.File exposing (viewContent, viewItem)


files : FileSystem -> (Id -> msg) -> Html msg
files (FileSystem focus node) fileMsg =
    Html.div [] (filesHelp focus fileMsg node)


filesHelp : Focus -> (Id -> msg) -> Node -> List (Html msg)
filesHelp focus fileMsg node =
    case node of
        Folder { name, visibility } children ->
            case visibility of
                Open ->
                    [ Html.div []
                        ([ Html.text name ]
                            ++ List.concatMap (filesHelp focus fileMsg) children
                        )
                    ]

                Closed ->
                    [ Html.div []
                        ([ Html.text name ]
                            ++ List.concatMap (filesHelp focus fileMsg) children
                        )
                    ]

        File data ->
            [ viewItem focus data fileMsg ]
