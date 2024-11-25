module Evergreen.V26.RouteEditPane exposing (..)

import DatePicker
import Evergreen.V26.ClimbRoute


type alias Model =
    { route : Evergreen.V26.ClimbRoute.NewRouteData
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
