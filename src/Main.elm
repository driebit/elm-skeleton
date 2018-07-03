module Main exposing (main)

import Ginger.Media as Media
import Ginger.Resource exposing (Resource)
import Ginger.Rest
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Navigation
import Route exposing (Route)


-- MAIN


main : Program Never Model Msg
main =
    Navigation.program OnNavigation
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { route : Route
    , page : Page
    , data : Maybe Resource
    }


type Page
    = Home
    | Article
    | Loading
    | Unknown


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    updatePage
        { route = Route.fromLocation location
        , page = Loading
        , data = Nothing
        }



-- UPDATE


type Msg
    = OnNavigation Navigation.Location
    | PushUrl Route
    | GotResource (Result Http.Error Resource)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnNavigation location ->
            updatePage { model | route = Route.fromLocation location }

        PushUrl route ->
            ( model, Navigation.newUrl (Route.toUrl route) )

        GotResource result ->
            let
                _ =
                    Debug.log "data" result
            in
            ( { model | data = Result.toMaybe result }, Cmd.none )


updatePage : Model -> ( Model, Cmd Msg )
updatePage model =
    let
        ( page, cmds ) =
            case model.route of
                Route.Root ->
                    ( Home, Cmd.none )

                Route.Article _ ->
                    ( Article, Cmd.none )

                Route.NotFound ->
                    ( Unknown, Cmd.none )
    in
    ( { model | page = page }
    , Http.send GotResource <|
        Ginger.Rest.requestResourceByPath "/"
    )



-- VIEW


view : Model -> Html Msg
view model =
    let
        imageUrl =
            Maybe.andThen (Media.depiction Media.Small) model.data
                |> Maybe.withDefault "fallbackurl"
    in
    main_ []
        [ h1 [] [ text "hello world" ], img [ src imageUrl ] [] ]
