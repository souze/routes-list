module Evergreen.V21.RouteEditPane exposing (..)

import DatePicker
import Evergreen.V21.Route


type alias Model =
    { route : Evergreen.V21.Route.NewRouteData
    , datePickerModel : DatePicker.Model
    , datePickerText : String
    }


type Msg
    = FieldUpdated String String
    | DatePickerUpdate DatePicker.ChangeEvent
