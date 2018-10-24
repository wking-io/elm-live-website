module FileSystem.File.Id exposing (Id, equal, generate, toString)

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


equal : Id -> Id -> Bool
equal (Id x) (Id y) =
    x == y
