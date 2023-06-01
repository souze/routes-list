module Route exposing (..)

import Date
import List.Extra
import Time


type RouteId
    = RouteId Int


getIntId : RouteId -> Int
getIntId (RouteId id) =
    id


ridToString : RouteId -> String
ridToString (RouteId id) =
    "[" ++ String.fromInt id ++ "]"


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


initialNewRouteData : NewRouteData
initialNewRouteData =
    { name = ""
    , area = ""
    , grade = ""
    , notes = ""
    , tickDate2 = Nothing
    , type_ = Trad
    , images = []
    , videos = []
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


gradeCompare : String -> Int
gradeCompare grade =
    List.Extra.elemIndex grade gradeOrder
        |> Maybe.withDefault 0


gradeOrder : List String
gradeOrder =
    [ "3-"
    , "3"
    , "3+"
    , "4-"
    , "4"
    , "4+"
    , "5-"
    , "5"
    , "5+"
    , "6-"
    , "6"
    , "6+"
    , "7-"
    , "7"
    , "7+"
    , "8-"
    , "8"
    , "8+"
    , "9-"
    , "9"
    , "9+"
    ]
