module Evergreen.V12.Pages.Routes.Filter_ exposing (..)

import DatePicker
import Dict
import Evergreen.V12.Filter
import Evergreen.V12.Route
import Evergreen.V12.Sorter


type alias Filter =
    { filter : Evergreen.V12.Filter.Model
    , sorter : Evergreen.V12.Sorter.Model
    }


type alias DatePickerData =
    { dateText : String
    , pickerModel : DatePicker.Model
    }


type alias Metadata =
    { expanded : Bool
    , datePickerData : DatePickerData
    , editRoute : Maybe Evergreen.V12.Route.RouteData
    }


type alias Model =
    { filter : Filter
    , showSortBox : Bool
    , metadatas : Dict.Dict Int Metadata
    }


type ButtonId
    = ExpandRouteButton Evergreen.V12.Route.RouteId
    | EditRouteButton Evergreen.V12.Route.RouteData
    | SaveButton Evergreen.V12.Route.RouteData
    | DiscardButton Evergreen.V12.Route.RouteId
    | RemoveButton Evergreen.V12.Route.RouteId
    | CreateButton


type Msg
    = ToggleFilters
    | ButtonPressed ButtonId
    | FieldUpdated Evergreen.V12.Route.RouteId String String
    | DatePickerUpdate Evergreen.V12.Route.RouteId DatePicker.ChangeEvent
    | SortSelected Evergreen.V12.Sorter.SorterMsg
    | FilterMsg Evergreen.V12.Filter.Msg
