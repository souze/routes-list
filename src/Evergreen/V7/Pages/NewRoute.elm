module Evergreen.V7.Pages.NewRoute exposing (..)

import DatePicker
import Evergreen.V7.Route


type alias Model =
    { route : Evergreen.V7.Route.NewRouteData
    , datePickerModel : DatePicker.Model
    , datePickerText : String
    }


type Msg
    = FieldUpdated String String
    | DatePickerUpdate DatePicker.ChangeEvent
    | CreateRoute
