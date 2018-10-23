module FileSystem.Options exposing (ElmSource(..), FileSystemState(..), Options(..), Output(..), compile, default)


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


compile : Options -> Options
compile options =
    case options of
        Raw flags ->
            Compiled flags

        Compiled flags ->
            Compiled flags


default : Options
default =
    Raw (FileSystemState Global Default)
