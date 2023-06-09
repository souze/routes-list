module Evergreen.V18.Pages.Routes.Filter_ exposing (..)

import Dict
import Evergreen.V18.Filter
import Evergreen.V18.Route
import Evergreen.V18.RouteEditPane
import Evergreen.V18.Sorter


type alias Filter =
    { filter : Evergreen.V18.Filter.Model
    , sorter : Evergreen.V18.Sorter.Model
    }


type alias Metadata =
    { expanded : Bool
    , routeId : Evergreen.V18.Route.RouteId
    , editRoute : Maybe Evergreen.V18.RouteEditPane.Model
    }


type alias Model =
    { filter : Filter
    , showSortBox : Bool
    , metadatas : Dict.Dict Int Metadata
    }


type ButtonId
    = ExpandRouteButton Evergreen.V18.Route.RouteId
    | EditRouteButton Evergreen.V18.Route.RouteData
    | SaveButton Evergreen.V18.Route.RouteData
    | DiscardButton Evergreen.V18.Route.RouteId
    | RemoveButton Evergreen.V18.Route.RouteId
    | CreateButton


type Msg
    = ToggleFilters
    | ButtonPressed ButtonId
    | SortSelected Evergreen.V18.Sorter.SorterMsg
    | FilterMsg Evergreen.V18.Filter.Msg
    | RouteEditPaneMsg Evergreen.V18.Route.RouteId Evergreen.V18.RouteEditPane.Msg
