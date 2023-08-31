module Evergreen.V23.Filter exposing (..)

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
    , tags : Set.Set String
    }


type Msg
    = PressedGradeFilter String
    | PressedTickdateFilter
    | PressedTypeFilter String
    | PressedTagFilter String
