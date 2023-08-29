module Evergreen.V21.Pages.Routes.Filter_ exposing (..)

import Dict
import Evergreen.V21.Filter
import Evergreen.V21.Route
import Evergreen.V21.RouteEditPane
import Evergreen.V21.Sorter


type alias Filter =
    { filter : Evergreen.V21.Filter.Model
    , sorter : Evergreen.V21.Sorter.Model
    }


type alias Metadata =
    { expanded : Bool
    , routeId : Evergreen.V21.Route.RouteId
    , editRoute : Maybe Evergreen.V21.RouteEditPane.Model
    }


type alias Model =
    { filter : Filter
    , showSortBox : Bool
    , metadatas : Dict.Dict Int Metadata
    }


type ButtonId
    = ExpandRouteButton Evergreen.V21.Route.RouteId
    | EditRouteButton Evergreen.V21.Route.RouteData
    | SaveButton Evergreen.V21.Route.RouteData
    | DiscardButton Evergreen.V21.Route.RouteId
    | RemoveButton Evergreen.V21.Route.RouteId
    | CreateButton


type Msg
    = ToggleFilters
    | ButtonPressed ButtonId
    | SortSelected Evergreen.V21.Sorter.SorterMsg
    | FilterMsg Evergreen.V21.Filter.Msg
    | RouteEditPaneMsg Evergreen.V21.Route.RouteId Evergreen.V21.RouteEditPane.Msg
