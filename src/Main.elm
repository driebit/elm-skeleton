module Main exposing (main)

import Html exposing (..)
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
        }



-- UPDATE


type Msg
    = OnNavigation Navigation.Location
    | PushUrl Route


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnNavigation location ->
            updatePage { model | route = Route.fromLocation location }

        PushUrl route ->
            ( model, Navigation.newUrl (Route.toUrl route) )


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
    ( { model | page = page }, cmds )



-- VIEW


view : Model -> Html Msg
view _ =
    main_ []
        [ Route.link PushUrl Route.Root [] [ h1 [] [ text "Hello" ] ] ]
