module Evergreen.V26.Shared.Msg exposing (..)

import Date
import Evergreen.V26.ClimbRoute


type SharedFromBackend
    = AllRoutesAnnouncement (List Evergreen.V26.ClimbRoute.RouteData)
    | LogOut
    | YouAreAdmin


type Msg
    = NoOp
    | MsgFromBackend SharedFromBackend
    | SetCurrentDate Date.Date
