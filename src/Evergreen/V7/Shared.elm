module Evergreen.V7.Shared exposing (..)

import Date
import Evergreen.V7.Route


type User
    = NormalUser
    | AdminUser


type alias Model =
    { routes : List Evergreen.V7.Route.RouteData
    , user : Maybe User
    , currentDate : Date.Date
    }


type SharedFromBackend
    = AllRoutesAnnouncement (List Evergreen.V7.Route.RouteData)
    | LogOut
    | YouAreAdmin


type Msg
    = Noop
    | MsgFromBackend SharedFromBackend
    | SetCurrentDate Date.Date
