module Evergreen.V26.Shared.Model exposing (..)

import Date
import Evergreen.V26.ClimbRoute


type User
    = NormalUser
    | AdminUser


type alias Model =
    { routes : List Evergreen.V26.ClimbRoute.RouteData
    , user : Maybe User
    , currentDate : Date.Date
    }
