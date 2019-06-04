module View.Footer exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Route


view : List (Html msg)
view =
    [ footer []
        [ Route.link Route.Root [] [ span [] [ text "Skeleton" ] ]
        , div [] [ p [] [ text "All rights reserved" ] ]
        ]
    ]
