module Main exposing (main)

import Browser
import Browser.Dom as Dom exposing (Error(..))
import FileSystem exposing (FileSystem)
import FileSystem.Id as Id exposing (Id)
import FileSystem.Options as Options exposing (Options)
import Html exposing (Html)
import Html.Attributes as HA
import Html.Events exposing (onClick)
import Task
import View.FileSystem exposing (contents, files)


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
    | ToggleFolder Id


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Compile ->
            ( { model | filesystem = FileSystem.compile model.options }, Cmd.none )

        ChangeFocus id ->
            ( { model | filesystem = FileSystem.updateFocus id model.filesystem }, Task.attempt FocusResult (Dom.focus (Id.toString id)) )

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

        ToggleFolder id ->
            ( { model | filesystem = FileSystem.toggleFolder id model.filesystem }, Cmd.none )


view : Model -> Html Msg
view { filesystem } =
    Html.div []
        [ Html.div [ HA.class "flex" ]
            [ files filesystem ChangeFocus
            , contents filesystem
            ]
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
