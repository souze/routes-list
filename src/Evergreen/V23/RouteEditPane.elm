module Evergreen.V23.RouteEditPane exposing (..)

import DatePicker
import Evergreen.V23.Route


type alias Model =
    { route : Evergreen.V23.Route.NewRouteData
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
