module Pages.Stats exposing (Model, Msg, page)

import Chart as C
import Dict exposing (Dict)
import Route
import Chart.Attributes as CA
import CommonView
import Element exposing (Element)
import Gen.Params.Stats exposing (Params)
import Html
import Html.Attributes
import Page
import Request
import Shared
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Time
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
    Element.column [] [
            gradeChart shared.routes
        ]


gradeChart : List Route.RouteData -> Element msg
gradeChart routes =
    C.chart
        [ CA.width 100
        , CA.height 100
        , CA.attrs [ SvgAttr.height "100" ]
        ]
        [ C.xTicks []
        , C.yTicks []
        , C.xLabels []
        , C.yLabels []
        , C.xAxis []
        , C.yAxis []
        , C.bars [] [ C.bar identity [] ] [ 2, 4, 3 ]
        ]
        |> Element.html
        |> Element.el []


groupByGrade : List Route.RouteData -> Dict String (List Route.RouteData)
groupByGrade routes =
    let
        foldHelper = 1
    in
    routes
        |> List.foldl foldHelper Dict.empty