module EditPage exposing (Model, Msg(..), init, update, view)

import Html exposing (..)


type alias Model =
    { count : Int }


init =
    ( { count = 0 }, Cmd.none )


type Msg
    = None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view model =
    div []
        [ text (String.fromInt model.count) ]
