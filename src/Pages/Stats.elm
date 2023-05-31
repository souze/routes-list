module Pages.Stats exposing (Model, Msg, page)

import CommonView
import Element exposing (Element)
import Gen.Params.Stats exposing (Params)
import Page
import Request
import Shared
import Time
import View exposing (View)
import Chart as C
import Chart.Attributes as CA
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Html.Attributes
import Html


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
    , body = Element.html (mainChart) -- viewBody shared model
    }

main : Svg msg
main =
    Svg.svg
    [ SvgAttr.width "120"
    , SvgAttr.height "120"
    , SvgAttr.viewBox "0 0 500 500"
    ]
    [ Svg.rect
        [ SvgAttr.x "10"
        , SvgAttr.y "10"
        , SvgAttr.width "100"
        , SvgAttr.height "100"
        , SvgAttr.rx "15"
        , SvgAttr.ry "15"
        ]
        []
    , Svg.circle
        [ SvgAttr.cx "50"
        , SvgAttr.cy "50"
        , SvgAttr.r "50"
        ]
        []
    , mainChart
    ]



-- viewBody : Shared.Model -> Model -> Element Msg
-- viewBody shared model =
--     CommonView.mainColumn
--         [ CommonView.header
--         , viewStats shared model
--         ]


-- viewStats : Shared.Model -> Model -> Element Msg
-- viewStats shared model =
--     Element.html main

mainChart : Svg msg
mainChart =
  C.chart
    [ CA.width 100
    , CA.height 100
    , CA.attrs [SvgAttr.height "100"]
    ]
    [ C.xTicks []
    , C.yTicks []
    , C.xLabels []
    , C.yLabels []
    , C.xAxis []
    , C.yAxis []
    , C.bars [ ] [ C.bar identity [] ]  [ 2, 4, 3 ]
    ]