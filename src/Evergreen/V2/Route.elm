module Evergreen.V2.Route exposing (..)

import Date


type ClimbType
    = Trad
    | Sport
    | Boulder
    | Mix


type RouteId
    = RouteId Int


type alias RouteData =
    { name : String
    , area : String
    , grade : String
    , notes : String
    , tickDate2 : Maybe Date.Date
    , type_ : ClimbType
    , id : RouteId
    }


type alias RouteDataEdit =
    { realRoute : RouteData
    , editRoute : Maybe RouteData
    }


type alias NewRouteData =
    { name : String
    , area : String
    , grade : String
    , notes : String
    , tickDate2 : Maybe Date.Date
    , type_ : ClimbType
    }


type RouteIdOrNew
    = ExistingRoute RouteId
    | NewRouteId
