module Evergreen.V25.Pages.Routes.Filter_ exposing (..)

import Dict
import Evergreen.V25.Filter
import Evergreen.V25.ImageGallery
import Evergreen.V25.Route
import Evergreen.V25.RouteEditPane
import Evergreen.V25.Sorter


type alias Filter =
    { filter : Evergreen.V25.Filter.Model
    , sorter : Evergreen.V25.Sorter.Model
    }


type alias Metadata =
    { expanded : Bool
    , routeId : Evergreen.V25.Route.RouteId
    , editRoute : Maybe Evergreen.V25.RouteEditPane.Model
    }


type alias Model =
    { filter : Filter
    , showSortBox : Bool
    , metadatas : Dict.Dict Int Metadata
    , galleryModel : Maybe Evergreen.V25.ImageGallery.Model
    }


type ButtonId
    = ExpandRouteButton Evergreen.V25.Route.RouteId
    | EditRouteButton Evergreen.V25.Route.RouteData
    | SaveButton Evergreen.V25.Route.RouteData
    | DiscardButton Evergreen.V25.Route.RouteId
    | RemoveButton Evergreen.V25.Route.RouteId
    | CreateButton


type Msg
    = ToggleFilters
    | ButtonPressed ButtonId
    | SortSelected Evergreen.V25.Sorter.SorterMsg
    | FilterMsg Evergreen.V25.Filter.Msg
    | RouteEditPaneMsg Evergreen.V25.Route.RouteId Evergreen.V25.RouteEditPane.Msg
    | GalleryMsg Evergreen.V25.ImageGallery.Msg
    | ThumbnailPressed Int (List String)
