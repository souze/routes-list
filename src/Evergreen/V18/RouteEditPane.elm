module Evergreen.V18.RouteEditPane exposing (..)

import DatePicker
import Evergreen.V18.Route


type alias Model =
    { route : Evergreen.V18.Route.NewRouteData
    , datePickerModel : DatePicker.Model
    , datePickerText : String
    }


type Msg
    = FieldUpdated String String
    | DatePickerUpdate DatePicker.ChangeEvent
