module Evergreen.V21.Pages.NewRoute exposing (..)

import Evergreen.V21.RouteEditPane


type alias Model =
    { newRouteData : Evergreen.V21.RouteEditPane.Model
    }


type Msg
    = RouteEditMsg Evergreen.V21.RouteEditPane.Msg
    | CreateRoute
