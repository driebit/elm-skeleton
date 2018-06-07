module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
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
    { route : Route }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { route = Route.fromLocation location }
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
            ( { model | route = Route.fromLocation location }
            , Cmd.none
            )

        PushUrl route ->
            ( model, Navigation.newUrl (Route.toUrl route) )



-- VIEW


view : Model -> Html msg
view model =
    div []
        [ Route.link Route.Root [] [ h1 [] [ text "Hello" ] ] ]
