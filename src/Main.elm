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
    ( { route = Route.fromLocation location
      , page = Loading
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = OnNavigation Navigation.Location
    | PushUrl Route


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnNavigation location ->
            check { model | route = Route.fromLocation location }

        PushUrl route ->
            ( model, Navigation.newUrl (Route.toUrl route) )


check : Model -> ( Model, Cmd Msg )
check model =
    let
        ( page, cmds ) =
            case model.route of
                Route.Root ->
                    ( Home, Cmd.none )

                Route.Article id ->
                    ( Article, Cmd.none )

                Route.NotFound ->
                    ( Unknown, Cmd.none )
    in
    ( { model | page = page }, cmds )



-- VIEW


view : Model -> Html Msg
view model =
    main_ []
        [ Route.link PushUrl Route.Root [] [ h1 [] [ text "Hello" ] ] ]
