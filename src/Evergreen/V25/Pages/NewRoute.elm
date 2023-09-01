module Evergreen.V25.Pages.NewRoute exposing (..)

import Evergreen.V25.RouteEditPane


type alias Model =
    { newRouteData : Evergreen.V25.RouteEditPane.Model
    }


type Msg
    = RouteEditMsg Evergreen.V25.RouteEditPane.Msg
    | CreateRoute
