module Evergreen.V26.Pages.Routes.Filter_ exposing (..)

import Dict
import Evergreen.V26.ClimbRoute
import Evergreen.V26.Filter
import Evergreen.V26.ImageGallery
import Evergreen.V26.RouteEditPane
import Evergreen.V26.Sorter


type alias Filter =
    { filter : Evergreen.V26.Filter.Model
    , sorter : Evergreen.V26.Sorter.Model
    }


type alias Metadata =
    { expanded : Bool
    , routeId : Evergreen.V26.ClimbRoute.RouteId
    , editRoute : Maybe Evergreen.V26.RouteEditPane.Model
    }


type alias Model =
    { filter : Filter
    , showSortBox : Bool
    , metadatas : Dict.Dict Int Metadata
    , galleryModel : Maybe Evergreen.V26.ImageGallery.Model
    }


type ButtonId
    = ExpandRouteButton Evergreen.V26.ClimbRoute.RouteId
    | EditRouteButton Evergreen.V26.ClimbRoute.RouteData
    | SaveButton Evergreen.V26.ClimbRoute.RouteData
    | DiscardButton Evergreen.V26.ClimbRoute.RouteId
    | RemoveButton Evergreen.V26.ClimbRoute.RouteId
    | CreateButton


type Msg
    = ToggleFilters
    | ButtonPressed ButtonId
    | SortSelected Evergreen.V26.Sorter.SorterMsg
    | FilterMsg Evergreen.V26.Filter.Msg
    | RouteEditPaneMsg Evergreen.V26.ClimbRoute.RouteId Evergreen.V26.RouteEditPane.Msg
    | GalleryMsg Evergreen.V26.ImageGallery.Msg
    | ThumbnailPressed Int (List String)
