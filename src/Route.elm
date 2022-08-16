module Route exposing (..)

import Date
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


type alias CommonRouteData a =
    { a
        | name : String
        , area : String
        , grade : String
        , notes : String
        , tickDate2 : Maybe Date.Date
        , type_ : ClimbType
        , images : List String
    , videos : List String
    }


type ClimbType
    = Trad
    | Sport
    | Boulder
    | Mix


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
    , images = common.images
    , videos = common.videos
    }


firstId : RouteId
firstId =
    RouteId 90
