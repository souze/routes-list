module Evergreen.V7.Route exposing (..)

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
    , images : List String
    , videos : List String
    , id : RouteId
    }


type alias NewRouteData =
    { name : String
    , area : String
    , grade : String
    , notes : String
    , tickDate2 : Maybe Date.Date
    , type_ : ClimbType
    , images : List String
    , videos : List String
    }


type RouteIdOrNew
    = ExistingRoute RouteId
    | NewRouteId