module Evergreen.V7.Pages.Routes.Filter_ exposing (..)

import DatePicker
import Dict
import Evergreen.V7.Route


type ViewFilter
    = ViewAll
    | ViewLog
    | ViewWishlist


type alias DatePickerData =
    { dateText : String
    , pickerModel : DatePicker.Model
    }


type alias Metadata =
    { expanded : Bool
    , datePickerData : DatePickerData
    , editRoute : Maybe Evergreen.V7.Route.RouteData
    }


type alias Model =
    { filter : ViewFilter
    , metadatas : Dict.Dict Int Metadata
    }


type ButtonId
    = ExpandRouteButton Evergreen.V7.Route.RouteId
    | EditRouteButton Evergreen.V7.Route.RouteData
    | SaveButton Evergreen.V7.Route.RouteData
    | DiscardButton Evergreen.V7.Route.RouteId
    | RemoveButton Evergreen.V7.Route.RouteId
    | CreateButton


type Msg
    = ReplaceMe
    | ButtonPressed ButtonId
    | FieldUpdated Evergreen.V7.Route.RouteId String String
    | DatePickerUpdate Evergreen.V7.Route.RouteId DatePicker.ChangeEvent
