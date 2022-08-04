module Route exposing (..)

import Time
import Date

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
    , tickDate2 : Maybe Date.Date
    , type_ : ClimbType
    , id : RouteId
    }


type alias NewRouteData =
    { name : String
    , area : String
    , grade : String
    , notes : String
    , tickDate2 : Maybe Date.Date
    , type_ : ClimbType
    }


type alias CommonRouteData a =
    { a
        | name : String
        , area : String
        , grade : String
        , notes : String
        , tickDate2 : Maybe Date.Date
        , type_ : ClimbType
    }

type ClimbType = Trad | Sport | Boulder | Mix

climbTypeToString : ClimbType -> String
climbTypeToString ct =
    case ct of
        Trad ->
            "Trad"

        Sport ->
            "Sport"

        Mix ->
            "Mix"

        Boulder ->
            "Boulder"



commonToExistingRoute : RouteId -> CommonRouteData a -> RouteData
commonToExistingRoute id common =
    { id = id
    , name = common.name
    , area = common.area
    , grade = common.grade
    , notes = common.notes
    , tickDate2 = common.tickDate2
    , type_ = common.type_
    }

firstId : RouteId
firstId =
    RouteId 90