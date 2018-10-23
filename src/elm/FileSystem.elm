module FileSystem exposing (FileSystem(..), Focus, Options, compile, default, defaultOptions, fromOptions)

import FileSystem.File as File
import FileSystem.File.Content as Content
import FileSystem.Node as Node exposing (Node)


type FileSystem
    = FileSystem Focus Node


type Focus
    = None
    | Focus File.Data


type Options
    = Raw FileSystemState
    | Compiled FileSystemState


type FileSystemState
    = FileSystemState ElmSource Output


type ElmSource
    = Local
    | Global


type Output
    = Default
    | Build
    | CustomBuild
    | BuildDir
    | CustomBuildDir


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
    fromOptions defaultOptions


defaultOptions : Options
defaultOptions =
    Raw (FileSystemState Global Default)


compile : Options -> Options
compile options =
    case options of
        Raw flags ->
            Compiled flags

        Compiled flags ->
            Compiled flags
