module Route exposing (Route(..), fromLocation, link, toTitle, toUrl)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (defaultOptions, onWithOptions)
import Json.Decode as Decode
import Navigation
import UrlParser as Url exposing ((</>))


type Route
    = Root
    | Page Id


type alias Id =
    Int



-- PARSE


fromLocation : Navigation.Location -> Route
fromLocation =
    Maybe.withDefault Root
        << Url.parsePath parser


parser : Url.Parser (Route -> a) a
parser =
    Url.oneOf
        [ Url.map Root Url.top
        , Url.map Page (Url.s "page" </> Url.int)
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

        Page id ->
            RouteData ("/page/" ++ toString id) ("Page " ++ toString id)


toTitle : Route -> String
toTitle =
    .title << toRouteData


toUrl : Route -> String
toUrl =
    .url << toRouteData



{-
   LINK

   Type checked internal links.

   - Each path for each route is defined once
   - Easy to change path
   - You can't go to non-existing routes
   - Prevent page reload
   - Enable ctrl-click
-}


link : (Route -> msg) -> Route -> List (Attribute msg) -> List (Html msg) -> Html msg
link toMsg route attributes content =
    a
        ([ href (toUrl route)
         , onPreventDefaultClick (toMsg route)
         ]
            ++ attributes
        )
        content


onPreventDefaultClick : msg -> Attribute msg
onPreventDefaultClick msg =
    onWithOptions "click"
        { defaultOptions | preventDefault = True }
        (Decode.andThen (eventDecoder msg) eventKeyDecoder)


eventKeyDecoder : Decode.Decoder Bool
eventKeyDecoder =
    Decode.map2
        (not >> xor)
        (Decode.field "ctrlKey" Decode.bool)
        (Decode.field "metaKey" Decode.bool)


eventDecoder : msg -> Bool -> Decode.Decoder msg
eventDecoder msg preventDefault =
    if preventDefault then
        Decode.succeed msg
    else
        Decode.fail ""
