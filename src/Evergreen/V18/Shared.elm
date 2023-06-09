module Evergreen.V18.Shared exposing (..)

import Date
import Evergreen.V18.Route


type User
    = NormalUser
    | AdminUser


type alias Model =
    { routes : List Evergreen.V18.Route.RouteData
    , user : Maybe User
    , currentDate : Date.Date
    }


type SharedFromBackend
    = AllRoutesAnnouncement (List Evergreen.V18.Route.RouteData)
    | LogOut
    | YouAreAdmin


type Msg
    = Noop
    | MsgFromBackend SharedFromBackend
    | SetCurrentDate Date.Date
