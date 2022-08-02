module Route exposing (..)

import Time

type RouteId
    = RouteId Int

type RouteIdOrNew
    = ExistingRoute RouteId
    | NewRouteId


type alias RouteDataEdit =
    { realRoute : RouteData, editRoute : Maybe RouteData }


type alias RouteData =
    { name : String
    , area : String
    , grade : String
    , notes : String
    , tickDate : Maybe Time.Posix
    , type_ : ClimbType
    , id : RouteId
    }


type alias NewRouteData =
    { name : String
    , area : String
    , grade : String
    , notes : String
    , tickDate : Maybe Time.Posix
    , type_ : ClimbType
    }


type alias CommonRouteData a =
    { a
        | name : String
        , area : String
        , grade : String
        , notes : String
        , tickDate : Maybe Time.Posix
        , type_ : ClimbType
    }

type ClimbType = Trad | Sport | Boulder | Mix


commonToExistingRoute : RouteId -> CommonRouteData a -> RouteData
commonToExistingRoute id common =
    { id = id
    , name = common.name
    , area = common.area
    , grade = common.grade
    , notes = common.notes
    , tickDate = common.tickDate
    , type_ = common.type_
    }

firstId : RouteId
firstId =
    RouteId 90