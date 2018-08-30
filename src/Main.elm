module Main exposing (main)

import Browser
import Browser.Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Route exposing (Route)
import Url exposing (Url)



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlChange = OnUrlChange
        , onUrlRequest = OnUrlRequest
        }



-- MODEL


type alias Model =
    { route : Route
    , page : Page
    , key : Browser.Navigation.Key
    }


type Page
    = Home
    | Article
    | Loading
    | Unknown


init : flags -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ location key =
    updatePage
        { route = Route.fromLocation location
        , page = Loading
        , key = key
        }



-- UPDATE


type Msg
    = OnUrlChange Url
    | OnUrlRequest Browser.UrlRequest


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnUrlChange location ->
            updatePage { model | route = Route.fromLocation location }

        OnUrlRequest (Browser.Internal url) ->
            ( model, Browser.Navigation.pushUrl model.key (Url.toString url) )

        OnUrlRequest (Browser.External href) ->
            ( model, Browser.Navigation.load href )


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
    , Cmd.none
    )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = Route.toTitle model.route
    , body = [ main_ [] [ h1 [] [ text "hello world" ] ] ]
    }
