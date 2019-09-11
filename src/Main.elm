module Main exposing (main)

-- import NotFound

import Browser exposing (Document)
import Browser.Navigation as Nav
import EditPage
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy)
import TableList
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, int, map, oneOf, parse, s, string)


type alias Model =
    { page : Page
    , key : Nav.Key
    }


type Page
    = TableListPage TableList.Model
    | EditPageRoute EditPage.Model
    | NotFound


type Route
    = TableList
    | EditPage


view : Model -> Document Msg
view model =
    let
        content =
            case model.page of
                TableListPage tables ->
                    TableList.view tables
                        |> Html.map GotTableListMsg

                EditPageRoute edit ->
                    EditPage.view edit
                        |> Html.map GotEditPageMsg

                NotFound ->
                    text "Not Found"
    in
    { title = "Single Page Application"
    , body =
        [ lazy viewHeader model.page
        , content
        , viewFooter
        ]
    }


viewHeader : Page -> Html Msg
viewHeader page =
    let
        -- _ =
        --     Debug.log "Running viewHeader with" page
        logo =
            h1 [] [ text "Tables" ]

        links =
            ul []
                [ navLink TableList { url = "/", caption = "TableList" }
                , navLink EditPage { url = "/editPage", caption = "EditPage" }
                ]

        navLink : Route -> { url : String, caption : String } -> Html msg
        navLink targetPage { url, caption } =
            li [ classList [ ( "active", isActive { link = targetPage, page = page } ) ] ]
                [ a [ href url ] [ text caption ] ]

        -- navLink : Page -> { url : String, caption : String } -> Html msg
        -- navLink targetPage { url, caption } =
        --     li [ classList [ ( "active", isActive { link = targetPage, page = page } ) ] ]
        --         [ a [ href url ] [ text caption ] ]
        -- li [ classList [ ( "active", page == targetPage ) ] ]
        --     [ a [ href url ] [ text caption ] ]
    in
    nav [] [ logo, links ]


isActive : { link : Route, page : Page } -> Bool
isActive { link, page } =
    case ( link, page ) of
        ( EditPage, EditPageRoute _ ) ->
            True

        ( EditPage, _ ) ->
            False

        ( TableList, TableListPage _ ) ->
            True

        ( TableList, _ ) ->
            False



-- ( _, NotFound ) ->
--     False
-- nav [ onMouseOver NothingYet ] [ logo, links ]


viewFooter : Html msg
viewFooter =
    footer [] [ text "One is never alone with a rubber duck. -Douglas Adams" ]



-- type Msg
--     = NothingYet


type Msg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url
    | GotTableListMsg TableList.Msg
    | GotEditPageMsg EditPage.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedLink urlRequest ->
            case urlRequest of
                Browser.External href ->
                    ( model, Nav.load href )

                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

        ChangedUrl url ->
            updateUrl url model

        -- ( { model | page = urlToPage url }, Cmd.none )
        GotTableListMsg tablesMsg ->
            case model.page of
                TableListPage tables ->
                    toTables model (TableList.update tablesMsg tables)

                -- tablesMsg ->
                --     ( model, Nav.pushUrl model.key tablesMsg )    

                _ ->
                    ( model, Cmd.none )       
       

        GotEditPageMsg editMsg ->
            case model.page of
                EditPageRoute edit ->
                    toEdit model (EditPage.update editMsg edit)

                _ ->
                    ( model, Cmd.none )


toTables : Model -> ( TableList.Model, Cmd TableList.Msg ) -> ( Model, Cmd Msg )
toTables model ( tables, cmd ) =
    ( { model | page = TableListPage tables }
    , Cmd.map GotTableListMsg cmd
    )


toEdit : Model -> ( EditPage.Model, Cmd EditPage.Msg ) -> ( Model, Cmd Msg )
toEdit model ( edit, cmd ) =
    ( { model | page = EditPageRoute edit }
    , Cmd.map GotEditPageMsg cmd
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
-- init flags url key =
--     ( { page = urlToPage url, key = key }, Cmd.none )
-- case url.path of
--     "/editPage" ->
--         ( { page = EditPage }, Cmd.none )
--     "/" ->
--         ( { page = TableList }, Cmd.none )
--     _ ->
--         ( { page = NotFound }, Cmd.none )
-- urlToPage : Url -> Page
-- urlToPage url =
--     Parser.parse parser url
--         |> Maybe.withDefault NotFound


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    updateUrl url { page = NotFound, key = key }


updateUrl : Url -> Model -> ( Model, Cmd Msg )
updateUrl url model =
    case Parser.parse parser url of
        Just EditPage ->
            toEdit model EditPage.init

        Just TableList ->
            toTables model ( TableList.init model.key )

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )



-- urlToPage : Url -> Page
-- urlToPage url =
--     case Parser.parse parser url of
--         Just EditPage ->
--             EditPageRoute EditPage.init
--         Just TableList ->
--             TableListPage TableList.init
--         Nothing ->
--             NotFound


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map TableList Parser.top
        , Parser.map EditPage (s "editPage")
        ]



--Parser.map SelectedPhoto (s "photos" </> Parser.string)
-- main : Program () Model Msg


main =
    Browser.application
        { init = init
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        , subscriptions = subscriptions
        , update = update
        , view = view
        }



-- Browser.application
--     { init = \_ -> ( { page = TableList }, Cmd.none )
--     , onUrlRequest = \_ -> Debug.log "handle url request"
--     , onUrlChange = \_ -> Debug.log "handle url changes"
--     , subscriptions = subscriptions
--     , update = update
--     , view = view
--     }
-- module Main exposing (main)
-- import Browser
-- import Browser.Navigation as Nav
-- import EditPage
-- import Html exposing (..)
-- import Html.Attributes exposing (..)
-- import Html.Events exposing (onClick)
-- import NotFound
-- import TableList
-- import Url
-- import Url.Parser as UP exposing ((</>), Parser, int, map, oneOf, parse, s, string)
-- type alias Model =
--     { page : Page
--     , key : Nav.Key
--     , url : Url.Url
--     }
-- -- init : () -> Url.Url -> Nav.Key -> ( Model, Cmd msg )
-- -- init =
-- --     ( { page = TableList }, Cmd.none )
-- init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
-- init _ url key =
--     ( { key = key, url = url, page = urlToRoute url }, Cmd.none )
-- type Page
--     = TableList
--     | EditPage
--     | NotFound
-- routeParser : UP.Parser (Page -> a) a
-- routeParser =
--     UP.oneOf
--         [ UP.map TableList UP.top
--         , UP.map EditPage (UP.s "editpage")
--         ]
-- urlToRoute : Url.Url -> Page
-- urlToRoute url =
--     url
--         |> UP.parse routeParser
--         |> Maybe.withDefault NotFound
-- type Msg
--     = UrlRequested Browser.UrlRequest
--     | UrlChanged Url.Url
-- update : Msg -> Model -> ( Model, Cmd Msg )
-- update msg model =
--     case msg of
--         UrlRequested urlRequest ->
--             case urlRequest of
--                 Browser.Internal url ->
--                     ( model, Nav.pushUrl model.key (Url.toString url) )
--                 Browser.External href ->
--                     ( model, Nav.load href )
--         UrlChanged url ->
--             ( { model | url = url, page = urlToRoute url }
--             , Cmd.none
--             )
-- subscriptions : Model -> Sub Msg
-- subscriptions model =
--     Sub.none
-- -- view : Model -> Document Msg
-- view model =
--     let
--         page =
--             case model.page of
--                 TableList ->
--                     TableList.view
--                 EditPage ->
--                     EditPage.view
--         -- NotFound ->
--         --     NotFound.view
--     in
--     { title = "Simple Routing"
--     , body =
--         [ text "The Current Url is: "
--         , b [] [ text (Url.toString model.url) ]
--         , ul []
--             [ li [] [ a [ href "/" ] [ text "tableList" ] ]
--             , li [] [ a [ href "/editPage" ] [ text "Editpage" ] ]
--             ]
--         --  [ viewLink "/" "tableList"
--         --  , viewLink "/editpage" "editPage"
--         --  ]
--         ]
--             ++ page
--     }
-- --  viewLink : String -> String -> Html Msg
-- --  viewLink path pathText =
-- --      li [] [ a [ href path ] [ text pathText ] ]
-- main =
--     Browser.application
--         { init = init
--         , view = view
--         , update = update
--         , subscriptions = subscriptions
--         , onUrlChange = UrlChanged
--         , onUrlRequest = UrlRequested
--         }
-- module Main exposing (main)
-- import Browser
-- import Browser.Navigation as Nav
-- import Html exposing (..)
-- import Html.Attributes exposing (..)
-- import Html.Events exposing (onClick)
-- import Url
-- type alias Model =
--     { page : Page
--     , key : Nav.Key
--     , url : Url.Url
--     }
-- -- init : () -> Url.Url -> Nav.Key -> ( Model, Cmd msg )
-- -- init =
-- --     ( { page = TableList }, Cmd.none )
-- init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
-- init _ url key =
--     ( { key = key, url = url, page = urlToRoute url }, Cmd.none )
-- type Page
--     = TableList
--     | EditPage
--     | NotFound
-- subscriptions : Model -> Sub msg
-- subscriptions model =
--     Sub.none
-- main =
--     text "Hello World!"
