module View.FileSystem exposing (contents, files)

import FileSystem exposing (FileSystem(..), Focus(..))
import FileSystem.File.Extension as Extension
import FileSystem.File.Id as Id exposing (Id)
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


contents : FileSystem -> Html msg
contents (FileSystem focus node) =
    Html.div [] (contentsHelp focus node)


contentsHelp : Focus -> Node -> List (Html msg)
contentsHelp focus node =
    case node of
        Folder { name, visibility } children ->
            List.concatMap (contentsHelp focus) children

        File data ->
            case focus of
                None ->
                    [ viewContent False data ]

                Focus theFocus ->
                    [ viewContent (Id.equal theFocus.id data.id) data ]
