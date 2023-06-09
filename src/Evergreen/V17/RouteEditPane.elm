module Evergreen.V17.RouteEditPane exposing (..)

import DatePicker
import Evergreen.V17.Route


type alias Model =
    { route : Evergreen.V17.Route.NewRouteData
    , datePickerModel : DatePicker.Model
    , datePickerText : String
    }


type Msg
    = FieldUpdated String String
    | DatePickerUpdate DatePicker.ChangeEvent
