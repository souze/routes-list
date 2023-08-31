module Evergreen.V22.Pages.Routes.Filter_ exposing (..)

import Dict
import Evergreen.V22.Filter
import Evergreen.V22.ImageGallery
import Evergreen.V22.Route
import Evergreen.V22.RouteEditPane
import Evergreen.V22.Sorter


type alias Filter =
    { filter : Evergreen.V22.Filter.Model
    , sorter : Evergreen.V22.Sorter.Model
    }


type alias Metadata =
    { expanded : Bool
    , routeId : Evergreen.V22.Route.RouteId
    , editRoute : Maybe Evergreen.V22.RouteEditPane.Model
    }


type alias Model =
    { filter : Filter
    , showSortBox : Bool
    , metadatas : Dict.Dict Int Metadata
    , galleryModel : Maybe Evergreen.V22.ImageGallery.Model
    }


type ButtonId
    = ExpandRouteButton Evergreen.V22.Route.RouteId
    | EditRouteButton Evergreen.V22.Route.RouteData
    | SaveButton Evergreen.V22.Route.RouteData
    | DiscardButton Evergreen.V22.Route.RouteId
    | RemoveButton Evergreen.V22.Route.RouteId
    | CreateButton


type Msg
    = ToggleFilters
    | ButtonPressed ButtonId
    | SortSelected Evergreen.V22.Sorter.SorterMsg
    | FilterMsg Evergreen.V22.Filter.Msg
    | RouteEditPaneMsg Evergreen.V22.Route.RouteId Evergreen.V22.RouteEditPane.Msg
    | GalleryMsg Evergreen.V22.ImageGallery.Msg
    | ThumbnailPressed Int (List String)
