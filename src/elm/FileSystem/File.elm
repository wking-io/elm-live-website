module FileSystem.File exposing (Data)

import FileSystem.File.Extension exposing (Extension(..))
import FileSystem.File.Id as Id exposing (Id)


type alias Data =
    { id : Id
    , extension : Extension
    , name : String
    , contents : String
    }
