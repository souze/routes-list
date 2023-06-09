module Evergreen.V18.Pages.NewRoute exposing (..)

import Evergreen.V18.RouteEditPane


type alias Model =
    { newRouteData : Evergreen.V18.RouteEditPane.Model
    }


type Msg
    = RouteEditMsg Evergreen.V18.RouteEditPane.Msg
    | CreateRoute
