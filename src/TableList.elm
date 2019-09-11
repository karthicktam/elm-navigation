module TableList exposing (Model, Msg(..), Person, init, listView, update, view)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Table as Table
import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias Model =
    { person : List Person
    , key : Nav.Key
    -- messages : List String
    }



-- init : Modal


init key =
    ( Model [] key , Cmd.none )


personList =
    [ { name = "Kumar", age = 20, position = "Manager" }
    , { name = "Kathir", age = 30, position = "Team Leader" }
    , { name = "Venkat", age = 25, position = "Developer" }
    ]


type alias Person =
    { name : String
    , age : Int
    , position : String
    }


type Msg
    = NavigateTo String



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavigateTo route ->
            ( model, Nav.pushUrl model.key route )
    -- ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- listView : Modal -> Table.Row Msg


listView person =
    Table.tr []
        [ Table.td [] [ text person.name ]
        , Table.td [] [ text (String.fromInt person.age) ]
        , Table.td [] [ text person.position ]
        ]


view model =
    Grid.container [ style "marginTop" "100px" ]
        [ CDN.stylesheet
        , button [ onClick <| NavigateTo <| "/editPage"
                 , style "backgroundColor" "black"
                 , style "border" "none"
                 , style "color" "white"
                 , style "padding" "10px 20px"
                 , style "float" "right"
                 , style "margin" "10px"
                 ] 
                 [ text "Edit" ]

        -- , Button.button [ Button.dark ] 
        --                 [ a [ href "/editPage", style "textDecoration" "none" ] [ text "Edit" ]
        --                 ]

        -- , a [ href "/editPage" ] [ text "Edit" ]
        , Table.simpleTable
            ( Table.simpleThead
                [ Table.th [] [ text "Name" ]
                , Table.th [] [ text "Age" ]
                , Table.th [] [ text "Position" ]
                ]
            , Table.tbody []
                (List.map listView personList)
            )
        ]



-- main =
--     Browser.sandbox
--         { init = init
--         , update = update
--         , view = view
--         }
-- Grid.container [ style "marginTop" "100px" ]
--     [ CDN.stylesheet
--     , Table.simpleTable
--         ( Table.simpleThead
--             [ Table.th [] [ text "Name" ]
--             , Table.th [] [ text "Age" ]
--             , Table.th [] [ text "Position" ]
--             ]
--         , Table.tbody []
--             [ Table.tr []
--                 [ Table.td [] [ text "Hello" ]
--                 , Table.td [] [ text "Hello" ]
--                 , Table.td [] [ text "Hello" ]
--                 ]
--             , Table.tr []
--                 [ Table.td [] [ text "There" ]
--                 , Table.td [] [ text "There" ]
--                 , Table.td [] [ text "There" ]
--                 ]
--             , Table.tr []
--                 [ Table.td [] [ text "Dude" ]
--                 , Table.td [] [ text "Dude" ]
--                 , Table.td [] [ text "Dude" ]
--                 ]
--             ]
--         )
--     ]
