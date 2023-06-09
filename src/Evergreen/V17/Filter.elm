module Evergreen.V17.Filter exposing (..)

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
    , type_ : Set.Set String
    , tickdate : TickDateFilter
    }


type Msg
    = PressedGradeFilter String
    | PressedTickdateFilter
    | PressedTypeFilter String
