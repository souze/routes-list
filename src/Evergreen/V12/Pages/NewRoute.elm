module Evergreen.V12.Pages.NewRoute exposing (..)

import DatePicker
import Evergreen.V12.Route


type alias Model =
    { route : Evergreen.V12.Route.NewRouteData
    , datePickerModel : DatePicker.Model
    , datePickerText : String
    }


type Msg
    = FieldUpdated String String
    | DatePickerUpdate DatePicker.ChangeEvent
    | CreateRoute
