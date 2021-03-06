module Route exposing (Route(..), fromUrl, link, toTitle, toUrl)

import Data.Id as Id exposing (ArticleId)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode
import Url exposing (Url)
import Url.Builder as Builder
import Url.Parser exposing ((</>), Parser)



-- DEFINITIONS


type Route
    = Root
    | Article (Maybe ArticleId)
    | NotFound



-- PARSE


fromUrl : Url -> Route
fromUrl =
    Maybe.withDefault NotFound
        << Url.Parser.parse parser


parser : Parser (Route -> a) a
parser =
    Url.Parser.oneOf
        [ Url.Parser.map Root Url.Parser.top
        , Url.Parser.map Article (Url.Parser.s "article" </> Id.fromUrlString)
        ]



-- CONVERSIONS


type alias RouteData =
    { url : String
    , title : String
    }


toRouteData : Route -> RouteData
toRouteData route =
    case route of
        Root ->
            RouteData "/" "Home"

        Article Nothing ->
            RouteData (Builder.absolute [ "404" ] []) "Not found"

        Article (Just id) ->
            RouteData (Builder.absolute [ "article", Id.toUrlSegment id ] []) "Article"

        NotFound ->
            RouteData (Builder.absolute [ "404" ] []) "Not found"


toTitle : Route -> String
toTitle =
    .title << toRouteData


toUrl : Route -> String
toUrl =
    .url << toRouteData


{-| link

Type checked internal links.

  - Each path for each route is defined once
  - Easy to change path
  - You can't go to non-existing routes

-}
link : Route -> List (Attribute msg) -> List (Html msg) -> Html msg
link route attributes content =
    a (href (toUrl route) :: attributes) content
