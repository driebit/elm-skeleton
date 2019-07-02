module Page.Article exposing
    ( Model
    , Msg
    , init
    , update
    , view
    )

import Data.Id as Id exposing (ArticleId)
import Data.Status as Status exposing (Status)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http



-- MODEL


type alias Model =
    { data : Status Http.Error String }


init : ArticleId -> ( Model, Cmd Msg )
init articleId =
    ( { data = Status.NotAsked }
    , Cmd.none
    )



-- UPDATE


type Msg
    = GotData (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotData data ->
            ( { model | data = Status.fromResult data }
            , Cmd.none
            )



-- VIEW


view : Model -> { title : String, page : List (Html Msg) }
view model =
    { title = "Article"
    , page =
        [ header [] [ h1 [] [ text "Article" ] ]
        , main_ [] (viewPage model)
        ]
    }


viewPage : Model -> List (Html Msg)
viewPage model =
    case model.data of
        Status.NotAsked ->
            [ text "not asked" ]

        Status.Loading ->
            [ text "loading" ]

        Status.Failure err _ ->
            [ text "error" ]

        Status.Success data ->
            [ text data ]
