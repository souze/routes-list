module Evergreen.V26.ClimbRoute exposing (..)

import Date


type ClimbType
    = Trad
    | Sport
    | Boulder
    | Mix
    | Aid


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
