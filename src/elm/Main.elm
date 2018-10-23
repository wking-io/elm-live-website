module Main exposing (main)

import Browser
import FileSystem exposing (FileSystem)
import FileSystem.Options as Options exposing (Options)
import Html exposing (Html)
import Html.Events exposing (onClick)
import View.FileSystem exposing (files)


type alias Model =
    { filesystem : FileSystem
    , options : Options
    }


initialModel : () -> ( Model, Cmd Msg )
initialModel flags =
    ( { filesystem = FileSystem.default, options = Options.default }, Cmd.none )


type Msg
    = NoOp
    | Compile


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Compile ->
            ( { model | filesystem = FileSystem.compile model.options }, Cmd.none )


view : Model -> Html Msg
view { filesystem } =
    Html.div []
        [ files filesystem
        , Html.button [ onClick Compile ] [ Html.text "Compile" ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
