module View.FileSystem exposing (files)

import FileSystem exposing (FileSystem(..), Focus)
import FileSystem.File.Extension as Extension
import FileSystem.Folder exposing (Visibility(..))
import FileSystem.Node as Node exposing (Node(..))
import Html exposing (Html)


files : FileSystem -> Html msg
files (FileSystem focus node) =
    Html.div [] (filesHelp focus node)


filesHelp : Focus -> Node -> List (Html msg)
filesHelp focus node =
    case node of
        Folder { name, visibility } children ->
            case visibility of
                Open ->
                    [ Html.div []
                        ([ Html.text name ]
                            ++ List.concatMap (filesHelp focus) children
                        )
                    ]

                Closed ->
                    [ Html.div []
                        ([ Html.text name ]
                            ++ List.concatMap (filesHelp focus) children
                        )
                    ]

        File { id, extension, name } ->
            [ Html.p [] [ Html.text (name ++ Extension.toString extension) ] ]
