module FileSystem.File.Id exposing (Id, generate, toString)

import FileSystem.File.Extension as Extension exposing (Extension)


type Id
    = Id String


generate : String -> String -> Extension -> Id
generate parent filename filetype =
    parent
        ++ filename
        ++ Extension.toString filetype
        |> Id


toString : Id -> String
toString (Id id) =
    id
