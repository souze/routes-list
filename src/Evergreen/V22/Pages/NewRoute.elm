module Evergreen.V22.Pages.NewRoute exposing (..)

import Evergreen.V22.RouteEditPane


type alias Model =
    { newRouteData : Evergreen.V22.RouteEditPane.Model
    }


type Msg
    = RouteEditMsg Evergreen.V22.RouteEditPane.Msg
    | CreateRoute
