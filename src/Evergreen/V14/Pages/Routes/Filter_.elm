module Evergreen.V14.Pages.Routes.Filter_ exposing (..)

import DatePicker
import Dict
import Evergreen.V14.Filter
import Evergreen.V14.Route
import Evergreen.V14.Sorter


type alias Filter =
    { filter : Evergreen.V14.Filter.Model
    , sorter : Evergreen.V14.Sorter.Model
    }


type alias DatePickerData =
    { dateText : String
    , pickerModel : DatePicker.Model
    }


type alias Metadata =
    { expanded : Bool
    , datePickerData : DatePickerData
    , editRoute : Maybe Evergreen.V14.Route.RouteData
    }


type alias Model =
    { filter : Filter
    , showSortBox : Bool
    , metadatas : Dict.Dict Int Metadata
    }


type ButtonId
    = ExpandRouteButton Evergreen.V14.Route.RouteId
    | EditRouteButton Evergreen.V14.Route.RouteData
    | SaveButton Evergreen.V14.Route.RouteData
    | DiscardButton Evergreen.V14.Route.RouteId
    | RemoveButton Evergreen.V14.Route.RouteId
    | CreateButton


type Msg
    = ToggleFilters
    | ButtonPressed ButtonId
    | FieldUpdated Evergreen.V14.Route.RouteId String String
    | DatePickerUpdate Evergreen.V14.Route.RouteId DatePicker.ChangeEvent
    | SortSelected Evergreen.V14.Sorter.SorterMsg
    | FilterMsg Evergreen.V14.Filter.Msg
