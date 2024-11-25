module Evergreen.V26.Pages.NewRoute exposing (..)

import Evergreen.V26.RouteEditPane


type alias Model =
    { newRouteData : Evergreen.V26.RouteEditPane.Model
    }


type Msg
    = RouteEditMsg Evergreen.V26.RouteEditPane.Msg
    | CreateRoute
