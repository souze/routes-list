module Evergreen.V6.Pages.Routes.Filter_ exposing (..)

import DatePicker
import Dict
import Evergreen.V6.Route


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
    , editRoute : Maybe Evergreen.V6.Route.RouteData
    }


type alias Model =
    { filter : ViewFilter
    , metadatas : Dict.Dict Int Metadata
    }


type ButtonId
    = ExpandRouteButton Evergreen.V6.Route.RouteId
    | EditRouteButton Evergreen.V6.Route.RouteData
    | SaveButton Evergreen.V6.Route.RouteData
    | DiscardButton Evergreen.V6.Route.RouteId
    | RemoveButton Evergreen.V6.Route.RouteId
    | CreateButton


type Msg
    = ReplaceMe
    | ButtonPressed ButtonId
    | FieldUpdated Evergreen.V6.Route.RouteId String String
    | DatePickerUpdate Evergreen.V6.Route.RouteId DatePicker.ChangeEvent
