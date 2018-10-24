module FileSystem.Folder exposing (Data, Visibility(..), mapClosed, mapOpen)

import FileSystem.Id exposing (Id)


type alias Data =
    { id : Id
    , name : String
    , visibility : Visibility
    }


type Visibility
    = Open
    | Closed


map3 : (Visibility -> a -> b -> c) -> Visibility -> (a -> b -> c)
map3 f vis =
    f vis


mapOpen : (Visibility -> a -> b -> c) -> (a -> b -> c)
mapOpen f =
    map3 f Open


mapClosed : (Visibility -> a -> b -> c) -> (a -> b -> c)
mapClosed f =
    map3 f Closed
