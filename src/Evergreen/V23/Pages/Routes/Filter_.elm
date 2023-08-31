module Evergreen.V23.Pages.Routes.Filter_ exposing (..)

import Dict
import Evergreen.V23.Filter
import Evergreen.V23.ImageGallery
import Evergreen.V23.Route
import Evergreen.V23.RouteEditPane
import Evergreen.V23.Sorter


type alias Filter =
    { filter : Evergreen.V23.Filter.Model
    , sorter : Evergreen.V23.Sorter.Model
    }


type alias Metadata =
    { expanded : Bool
    , routeId : Evergreen.V23.Route.RouteId
    , editRoute : Maybe Evergreen.V23.RouteEditPane.Model
    }


type alias Model =
    { filter : Filter
    , showSortBox : Bool
    , metadatas : Dict.Dict Int Metadata
    , galleryModel : Maybe Evergreen.V23.ImageGallery.Model
    }


type ButtonId
    = ExpandRouteButton Evergreen.V23.Route.RouteId
    | EditRouteButton Evergreen.V23.Route.RouteData
    | SaveButton Evergreen.V23.Route.RouteData
    | DiscardButton Evergreen.V23.Route.RouteId
    | RemoveButton Evergreen.V23.Route.RouteId
    | CreateButton


type Msg
    = ToggleFilters
    | ButtonPressed ButtonId
    | SortSelected Evergreen.V23.Sorter.SorterMsg
    | FilterMsg Evergreen.V23.Filter.Msg
    | RouteEditPaneMsg Evergreen.V23.Route.RouteId Evergreen.V23.RouteEditPane.Msg
    | GalleryMsg Evergreen.V23.ImageGallery.Msg
    | ThumbnailPressed Int (List String)
