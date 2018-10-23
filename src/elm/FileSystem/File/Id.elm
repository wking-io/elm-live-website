module FileSystem.File.Id exposing (Id, generate)

import FileSystem.File.Extension as Extension exposing (Extension)


type Id
    = Id String


generate : String -> String -> Extension -> Id
generate parent filename filetype =
    parent
        ++ filename
        ++ Extension.toString filetype
        |> Id
