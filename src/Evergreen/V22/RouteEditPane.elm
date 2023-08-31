module Evergreen.V22.RouteEditPane exposing (..)

import DatePicker
import Evergreen.V22.Route


type alias Model =
    { route : Evergreen.V22.Route.NewRouteData
    , datePickerModel : DatePicker.Model
    , datePickerText : String
    , picturesText : String
    }


type Msg
    = FieldUpdated String String
    | DatePickerUpdate DatePicker.ChangeEvent
