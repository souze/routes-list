module StatsTests exposing (..)

import Dict exposing (Dict)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Pages.Stats as Stats
import Route exposing (RouteData)
import Set
import Test exposing (..)


suite : Test
suite =
    describe "The Stats module"
        [ test "Group by grade" <|
            \_ ->
                let
                    groups =
                        Stats.groupByGrade
                            [ { grade = "5", name = "five 1" }
                            , { grade = "5", name = "five 2" }
                            , { grade = "4", name = "four" }
                            , { grade = "4", name = "four" }
                            , { grade = "6", name = "six" }
                            ]
                in
                -- This test relies on the order of lists, unfortunately :(
                Expect.equal groups
                    (Dict.fromList
                        [ ( "5"
                          , [ { grade = "5", name = "five 2" }
                            , { grade = "5", name = "five 1" }
                            ]
                          )
                        , ( "4"
                          , [ { grade = "4", name = "four" }
                            , { grade = "4", name = "four" }
                            ]
                          )
                        , ( "6"
                          , [ { grade = "6", name = "six" }
                            ]
                          )
                        ]
                    )
        ]
