module Evergreen.V6.Pages.NewRoute exposing (..)

import DatePicker
import Evergreen.V6.Route


type alias Model =
    { route : Evergreen.V6.Route.NewRouteData
    , datePickerModel : DatePicker.Model
    , datePickerText : String
    }


type Msg
    = FieldUpdated String String
    | DatePickerUpdate DatePicker.ChangeEvent
    | CreateRoute
