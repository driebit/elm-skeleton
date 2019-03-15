module Example exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "Module name"
        [ test "A test" <|
            \_ ->
                Expect.equal 1 1
        ]
