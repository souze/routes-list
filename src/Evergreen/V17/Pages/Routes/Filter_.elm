module Evergreen.V17.Pages.Routes.Filter_ exposing (..)

import Date
import Dict
import Evergreen.V17.Filter
import Evergreen.V17.Route
import Evergreen.V17.RouteEditPane
import Evergreen.V17.Sorter


type alias Filter =
    { filter : Evergreen.V17.Filter.Model
    , sorter : Evergreen.V17.Sorter.Model
    }


type alias Metadata =
    { expanded : Bool
    , routeId : Evergreen.V17.Route.RouteId
    , editRoute : Maybe Evergreen.V17.RouteEditPane.Model
    }


type alias Model =
    { filter : Filter
    , showSortBox : Bool
    , currentDate : Date.Date
    , metadatas : Dict.Dict Int Metadata
    }


type ButtonId
    = ExpandRouteButton Evergreen.V17.Route.RouteId
    | EditRouteButton Evergreen.V17.Route.RouteData
    | SaveButton Evergreen.V17.Route.RouteData
    | DiscardButton Evergreen.V17.Route.RouteId
    | RemoveButton Evergreen.V17.Route.RouteId
    | CreateButton


type Msg
    = ToggleFilters
    | ButtonPressed ButtonId
    | SortSelected Evergreen.V17.Sorter.SorterMsg
    | FilterMsg Evergreen.V17.Filter.Msg
    | RouteEditPaneMsg Evergreen.V17.Route.RouteId Evergreen.V17.RouteEditPane.Msg
