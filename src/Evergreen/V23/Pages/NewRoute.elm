module Evergreen.V23.Pages.NewRoute exposing (..)

import Evergreen.V23.RouteEditPane


type alias Model =
    { newRouteData : Evergreen.V23.RouteEditPane.Model
    }


type Msg
    = RouteEditMsg Evergreen.V23.RouteEditPane.Msg
    | CreateRoute
