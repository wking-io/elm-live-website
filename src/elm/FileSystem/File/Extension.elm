module FileSystem.File.Extension exposing (Extension(..), toString)


type Extension
    = Js
    | Json
    | Elm
    | Css
    | Html


toString : Extension -> String
toString extension =
    case extension of
        Js ->
            ".js"

        Json ->
            ".json"

        Elm ->
            ".elm"

        Css ->
            ".css"

        Html ->
            ".html"
