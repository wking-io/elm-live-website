module Main exposing (main)

import Browser
import Browser.Dom as Dom exposing (Error(..))
import FileSystem exposing (FileSystem)
import FileSystem.File.Id exposing (Id)
import FileSystem.Options as Options exposing (Options)
import Html exposing (Html)
import Html.Events exposing (onClick)
import Task
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
    | ChangeFocus Id
    | FocusResult (Result Dom.Error ())
    | ToggleFolder


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Compile ->
            ( { model | filesystem = FileSystem.compile model.options }, Cmd.none )

        ChangeFocus id ->
            ( { model | filesystem = FileSystem.updateFocus id filesystem }, Task.attempt FocusResult (Dom.focus id) )

        FocusResult result ->
            case result of
                Err (NotFound id) ->
                    let
                        _ =
                            Debug.log "Failed to find DOM element with the following id:" id
                    in
                    ( model, Cmd.none )

                Ok _ ->
                    ( model, Cmd.none )

        ToggleFolder ->
            ( model, Cmd.none )


view : Model -> Html Msg
view { filesystem } =
    Html.div []
        [ files filesystem ChangeFocus
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
