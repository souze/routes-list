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
    { realRoute : RouteData
    , editRoute : Maybe RouteData
    }


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


newRouteDataFromExisting : RouteData -> NewRouteData
newRouteDataFromExisting r =
    { name = r.name
    , area = r.area
    , grade = r.grade
    , notes = r.notes
    , tickDate2 = r.tickDate2
    , type_ = r.type_
    , images = r.images
    , videos = r.videos
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
    | Aid


climbTypeListStr : List String
climbTypeListStr =
    [ Trad, Mix, Sport, Boulder, Aid ]
        |> List.map climbTypeToString


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

        Aid ->
            "Aid"


stringToClimbType : String -> ClimbType
stringToClimbType s =
    case s of
        "Trad" ->
            Trad

        "Sport" ->
            Sport

        "Mix" ->
            Mix

        "Boulder" ->
            Boulder

        "Aid" ->
            Aid

        _ ->
            Trad


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


gradeSorter : String -> String -> Order
gradeSorter a b =
    case ( List.Extra.elemIndex a gradeOrder, List.Extra.elemIndex b gradeOrder ) of
        ( Just i1, Just i2 ) ->
            if i1 < i2 then
                LT

            else if i1 == i2 then
                EQ

            else
                GT

        ( Just _, Nothing ) ->
            GT

        ( Nothing, Just _ ) ->
            LT

        ( Nothing, Nothing ) ->
            if List.sort [ a, b ] == [ a, b ] then
                LT

            else if List.sort [ b, a ] == [ b, a ] then
                EQ

            else
                GT


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
