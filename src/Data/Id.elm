module Data.Id exposing
    ( ArticleId
    , fromJson
    , fromUrlInt
    , fromUrlString
    , toString
    , toUrlSegment
    )

import Json.Decode as Decode
import Json.Encode as Encode
import Tagged exposing (Tagged)
import Url
import Url.Parser as Url



-- DEFINITIONS


{-| Note that `Tagged a b` does not contain a value `a` at all,
this is called a phantom type, it's a dummy variable that
let's us tag `Tagged` with another type.

Learn more about this here:
<https://medium.com/@ckoster22/advanced-types-in-elm-phantom-types-808044c5946d>

-}
type alias ArticleId =
    Tagged Article String


type Article
    = Article



-- CONVERSIONS


toString : Tagged a String -> String
toString =
    Tagged.untag


fromUrlString : Url.Parser (Maybe (Tagged b String) -> a) a
fromUrlString =
    Url.map (Maybe.map Tagged.tag << Url.percentDecode) Url.string


fromUrlInt : Url.Parser (Tagged b Int -> a) a
fromUrlInt =
    Url.map Tagged.tag Url.int


toUrlSegment : Tagged a String -> String
toUrlSegment =
    Url.percentEncode << Tagged.untag


fromJson : Decode.Decoder a -> Decode.Decoder (Tagged b a)
fromJson =
    Decode.map Tagged.tag
