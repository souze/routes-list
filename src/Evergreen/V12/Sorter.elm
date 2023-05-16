module Evergreen.V12.Sorter exposing (..)


type SortAttribute
    = Area
    | Grade
    | Tickdate
    | Name


type SortOrder
    = Ascending
    | Descending


type alias Model =
    List ( SortAttribute, SortOrder )


type SorterMsg
    = SorterMsg
        { row : Int
        , col : Int
        }
    | RemoveRow Int
