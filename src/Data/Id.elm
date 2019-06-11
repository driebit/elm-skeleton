module Data.Id exposing
    ( Article
    , Id
    , fromJson
    , fromUrl
    , toJson
    , toString
    , toUrlSegment
    )

import Json.Decode as Decode
import Json.Encode as Encode
import Url
import Url.Parser as Url



-- DEFINITIONS


{-| Note that `Id a` does not contain a value `a` at all,
this is called a phantom type, it's a dummy variable that
let's us tag `Id` with another type.

Learn more about this here:
<https://medium.com/@ckoster22/advanced-types-in-elm-phantom-types-808044c5946d>

-}
type Id a
    = Id String


type Article
    = Article



-- CONVERSIONS


toString : Id a -> String
toString (Id id) =
    id


fromUrl : Url.Parser (Maybe (Id b) -> a) a
fromUrl =
    Url.map (Maybe.map Id << Url.percentDecode) Url.string


toUrlSegment : Id b -> String
toUrlSegment (Id id) =
    Url.percentEncode id


fromJson : Decode.Decoder (Id a)
fromJson =
    Decode.map Id Decode.string


toJson : Id a -> Encode.Value
toJson (Id id) =
    Encode.string id
