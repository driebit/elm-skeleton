module View.NavBar exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route



-- VIEW


view : List (Html msg)
view =
    [ nav []
        [ Route.link Route.Root [] [ span [] [ text "Skeleton" ] ]
        , viewMenu
        ]
    ]


viewMenu : Html msg
viewMenu =
    ul [] [ li [] [ Route.link Route.Root [] [ text "Home" ] ] ]
