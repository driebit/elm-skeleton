module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Data.Id as Id exposing (Id)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Page.Article
import Page.Home
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
    , key : Navigation.Key
    }


type Page
    = Home Page.Home.Model
    | Article Page.Article.Model
    | Loading
    | Error String


init : flags -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    onNavigation
        { route = Route.fromUrl url
        , page = Loading
        , key = key
        }



-- UPDATE


type Msg
    = OnUrlChange Url
    | OnUrlRequest Browser.UrlRequest
    | HomeMsg Page.Home.Msg
    | ArticleMsg Page.Article.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnUrlChange url ->
            onNavigation { model | route = Route.fromUrl url }

        OnUrlRequest (Browser.Internal url) ->
            ( model, Navigation.pushUrl model.key (Url.toString url) )

        OnUrlRequest (Browser.External href) ->
            ( model, Navigation.load href )

        HomeMsg homeMsg ->
            case model.page of
                Home model_ ->
                    mapPage model Home HomeMsg <|
                        Page.Home.update homeMsg model_

                _ ->
                    ( model, Cmd.none )

        ArticleMsg articleMsg ->
            case model.page of
                Article model_ ->
                    mapPage model Article ArticleMsg <|
                        Page.Article.update articleMsg model_

                _ ->
                    ( model, Cmd.none )


mapPage : Model -> (a -> Page) -> (msg -> Msg) -> ( a, Cmd msg ) -> ( Model, Cmd Msg )
mapPage model toPage toMsg ( page, cmds ) =
    ( { model | page = toPage page }
    , Cmd.map toMsg cmds
    )


onNavigation : Model -> ( Model, Cmd Msg )
onNavigation model =
    case model.route of
        Route.Root ->
            mapPage model Home HomeMsg <|
                Page.Home.init

        Route.Article _ ->
            mapPage model Article ArticleMsg <|
                Page.Article.init

        Route.NotFound ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        { title, page } =
            viewPage model
    in
    { title = title
    , body = page
    }


viewPage : Model -> { title : String, page : List (Html Msg) }
viewPage model =
    let
        map pageMsg { title, page } =
            { title = title
            , page = List.map (Html.map pageMsg) page
            }
    in
    case model.page of
        Home model_ ->
            map HomeMsg (Page.Home.view model_)

        Article model_ ->
            map ArticleMsg (Page.Article.view model_)

        Loading ->
            { title = "", page = [] }

        Error err ->
            { title = "", page = [ text err ] }
