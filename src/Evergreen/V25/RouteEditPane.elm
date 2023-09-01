module Evergreen.V25.RouteEditPane exposing (..)

import DatePicker
import Evergreen.V25.Route


type alias Model =
    { route : Evergreen.V25.Route.NewRouteData
    , datePickerModel : DatePicker.Model
    , datePickerText : String
    , picturesText : String
    , tagText : String
    }


type Msg
    = FieldUpdated String String
    | DatePickerUpdate DatePicker.ChangeEvent
    | AddTagPressed String
    | RemoveTagPressed String
