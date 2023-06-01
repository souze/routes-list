module Evergreen.V14.Filter exposing (..)

import Set


type TickDateFilter
    = TickdateRangeFrom
    | TickdateRangeTo
    | TickdateRangeBetween
    | ShowHasTickdate
    | ShowWithoutTickdate
    | ShowAllTickdates


type alias Model =
    { grade : Set.Set String
    , tickdate : TickDateFilter
    }


type Msg
    = PressedGradeFilter Int
    | PressedTickdateFilter
