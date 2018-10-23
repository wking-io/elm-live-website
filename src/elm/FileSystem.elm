module FileSystem exposing (FileSystem(..), Focus, compile, default, fromOptions)

import FileSystem.File as File
import FileSystem.File.Content as Content
import FileSystem.File.Id as Id exposing (Id)
import FileSystem.Node as Node exposing (Node)
import FileSystem.Options as Options exposing (FileSystemState(..), Options(..), Output(..))


type FileSystem
    = FileSystem Focus Node


type Focus
    = None
    | Focus File.Data


updateFocus : Id -> FileSystem -> FileSystem
updateFocus newId ((FileSystem focus node) as filesystem) =
    case focus of
        None ->
            FileSystem (findFocus id node) node

        Focus { id } ->
            if id == newId then
                filesystem

            else
                FileSystem (findFocus id node) node


findFocus : Id -> Node -> Focus
findFocus id node =
    case Node.find id node of
        Ok data ->
            Focus data

        Err _ ->
            let
                _ =
                    Debug.log "No file found with id of:" id
            in
            None


outputNode : String -> FileSystemState -> List Node
outputNode parent (FileSystemState _ flags) =
    case flags of
        Default ->
            [ Node.makeHtmlFile parent "index" "Compiled Elm Here" ]

        Build ->
            [ Node.makeJsFile parent "elm" "Compiled Elm Here"
            , Node.makeHtmlFile parent "index" Content.htmlMain
            ]

        CustomBuild ->
            [ Node.makeHtmlFile parent "custom" Content.htmlMain
            , Node.makeJsFile parent "elm" "Compiled Elm Here"
            ]

        BuildDir ->
            [ Node.makeClosedFolder "build"
                [ Node.makeJsFile parent "elm" "Compiled Elm Here"
                , Node.makeHtmlFile parent "index" Content.htmlMain
                ]
            ]

        CustomBuildDir ->
            [ Node.makeClosedFolder "build"
                [ Node.makeHtmlFile parent "custom" Content.htmlMain
                , Node.makeJsFile parent "elm" "Compiled Elm Here"
                ]
            ]


generate : String -> Options -> List Node
generate parent options =
    case options of
        Raw flags ->
            [ Node.makeClosedFolder "src" [ Node.makeElmFile parent "Main" Content.elmMain ]
            , Node.makeJsonFile parent "elm" Content.elmJson
            , Node.makeCssFile parent "style" Content.styleCss
            , Node.makeJsonFile parent "package" Content.packageJson
            ]

        Compiled flags ->
            outputNode parent flags
                ++ [ Node.makeClosedFolder "src" [ Node.makeElmFile parent "Main" Content.elmMain ]
                   , Node.makeJsonFile parent "elm" Content.elmJson
                   , Node.makeCssFile parent "style" Content.styleCss
                   , Node.makeJsonFile parent "package" Content.packageJson
                   ]


fromOptions : Options -> FileSystem
fromOptions options =
    options
        |> generate "my-project"
        |> List.sortBy Node.sort
        |> Node.makeOpenFolder "my-project"
        |> FileSystem None


default : FileSystem
default =
    fromOptions Options.default


compile : Options -> FileSystem
compile options =
    Options.compile options
        |> fromOptions
