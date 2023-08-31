module Evergreen.V23.Route exposing (..)

import Date


type ClimbType
    = Trad
    | Sport
    | Boulder
    | Mix
    | Aid


type RouteId
    = RouteId Int


type alias RouteData =
    { name : String
    , area : String
    , grade : String
    , notes : String
    , tags : List String
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
    , tags : List String
    , tickDate2 : Maybe Date.Date
    , type_ : ClimbType
    , images : List String
    , videos : List String
    }
