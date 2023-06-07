module Pages.Stats exposing (Model, Msg, groupByGrade, page)

import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE
import Chart.Item as CI
import CommonView
import Dict exposing (Dict)
import Element exposing (Element)
import Gen.Params.Stats exposing (Params)
import Maybe.Extra
import Page
import Request
import Route exposing (RouteData)
import Shared
import Svg.Attributes as SvgAttr
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.sandbox
        (\user ->
            { init = init
            , update = update
            , view = view shared
            }
        )



-- INIT


type alias Model =
    {}


init : Model
init =
    {}



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> Model
update msg model =
    case msg of
        ReplaceMe ->
            model



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Route List"
    , body = viewBody shared model
    }


viewBody : Shared.Model -> Model -> Element Msg
viewBody shared model =
    CommonView.mainColumn
        [ CommonView.header
        , viewStats shared model
        ]


viewStats : Shared.Model -> Model -> Element Msg
viewStats shared model =
    Element.column [ Element.padding 15, Element.spacing 10 ]
        [ Element.text "Routes climbed, Trad"
        , gradeChart (isClimbedAndIsType Route.Trad) shared.routes
        , Element.text "Routes climbed, Sport"
        , gradeChart (isClimbedAndIsType Route.Sport) shared.routes
        , Element.text "Routes climbed, Mix"
        , gradeChart (isClimbedAndIsType Route.Mix) shared.routes
        , Element.text "Routes climbed, Boulder"
        , gradeChart (isClimbedAndIsType Route.Boulder) shared.routes
        ]


isClimbedAndIsType : Route.ClimbType -> RouteData -> Bool
isClimbedAndIsType type_ rd =
    routeIsClimbed rd && rd.type_ == type_


routeIsClimbed : RouteData -> Bool
routeIsClimbed =
    .tickDate2 >> Maybe.Extra.isJust


gradeChart : (RouteData -> Bool) -> List RouteData -> Element msg
gradeChart pred routes =
    let
        data =
            routes
                |> List.filter pred
                |> groupByGrade
                |> Dict.toList
                |> List.sortWith (\a b -> Route.gradeSorter (Tuple.first a) (Tuple.first b))
    in
    C.chart
        [ CA.width 300
        , CA.height 300
        , CA.attrs
            [ SvgAttr.height "300"
            , SvgAttr.width "350"
            , SvgAttr.viewBox "-40 -40 370 370"
            , SvgAttr.preserveAspectRatio "none"
            ]
        ]
        [ C.binLabels Tuple.first
            [ CA.moveDown 20 ]
        , C.yLabels
            [ CA.withGrid, CA.ints ]
        , C.yAxis []
        , C.bars [] [ C.bar (Tuple.second >> List.length >> toFloat) [] ] data
        , C.barLabels [ CA.moveDown 12, CA.color "white", CA.rotate 0, CA.moveRight 0, CA.alignMiddle, CA.fontSize 12 ]
        ]
        |> Element.html


type alias ThingWithGrade a =
    { a | grade : String }


groupByGrade : List (ThingWithGrade a) -> Dict String (List (ThingWithGrade a))
groupByGrade routes =
    let
        addToList : ThingWithGrade a -> Maybe (List (ThingWithGrade a)) -> Maybe (List (ThingWithGrade a))
        addToList routeData maybeRouteList =
            case maybeRouteList of
                Just routeList ->
                    Just <| routeData :: routeList

                Nothing ->
                    Just <| [ routeData ]

        foldHelper : ThingWithGrade a -> Dict String (List (ThingWithGrade a)) -> Dict String (List (ThingWithGrade a))
        foldHelper =
            \route dict -> dict |> Dict.update route.grade (addToList route)
    in
    routes
        |> List.foldl foldHelper Dict.empty
