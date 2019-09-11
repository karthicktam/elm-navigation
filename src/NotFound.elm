module NotFound exposing (Model, Msg(..), init, update, view)

import Html exposing (..)


type alias Model =
    { value : String }


init =
    { value = "Not Found Page" }


type Msg
    = NothingPageMsg


update : Msg -> Model -> Model
update msg model =
    model


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.value ] ]
