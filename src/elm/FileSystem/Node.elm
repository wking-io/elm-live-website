module FileSystem.Node exposing (Node(..), makeClosedFolder, makeCssFile, makeElmFile, makeHtmlFile, makeJsFile, makeJsonFile, makeOpenFolder, sort)

import FileSystem.File as File
import FileSystem.File.Extension exposing (Extension(..))
import FileSystem.File.Id as Id
import FileSystem.Folder as Folder


type Node
    = Folder Folder.Data (List Node)
    | File File.Data


sort : Node -> String
sort node =
    case node of
        Folder { name } nodes ->
            "a" ++ name

        File { name } ->
            "b" ++ name


makeFile : Extension -> String -> String -> String -> Node
makeFile extension parent name contents =
    File
        { id = Id.generate parent name extension
        , extension = extension
        , name = name
        , contents = contents
        }


makeJsFile : String -> String -> String -> Node
makeJsFile =
    makeFile Js


makeJsonFile : String -> String -> String -> Node
makeJsonFile =
    makeFile Json


makeElmFile : String -> String -> String -> Node
makeElmFile =
    makeFile Elm


makeCssFile : String -> String -> String -> Node
makeCssFile =
    makeFile Css


makeHtmlFile : String -> String -> String -> Node
makeHtmlFile =
    makeFile Html


makeFolder : Folder.Visibility -> String -> List Node -> Node
makeFolder visibility name children =
    Folder { visibility = visibility, name = name } children


makeOpenFolder : String -> List Node -> Node
makeOpenFolder =
    Folder.mapOpen makeFolder


makeClosedFolder : String -> List Node -> Node
makeClosedFolder =
    Folder.mapClosed makeFolder
