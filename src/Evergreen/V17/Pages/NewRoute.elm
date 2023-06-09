module Evergreen.V17.Pages.NewRoute exposing (..)

import Evergreen.V17.RouteEditPane


type alias Model =
    { newRouteData : Evergreen.V17.RouteEditPane.Model
    }


type Msg
    = RouteEditMsg Evergreen.V17.RouteEditPane.Msg
    | CreateRoute
