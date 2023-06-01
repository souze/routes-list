module Evergreen.V14.Pages.NewRoute exposing (..)

import DatePicker
import Evergreen.V14.Route


type alias Model =
    { route : Evergreen.V14.Route.NewRouteData
    , datePickerModel : DatePicker.Model
    , datePickerText : String
    }


type Msg
    = FieldUpdated String String
    | DatePickerUpdate DatePicker.ChangeEvent
    | CreateRoute
