module Pages.NewRoute exposing (Model, Msg(..), page)

import Bridge
import CommonView
import Date exposing (Date)
import DatePicker
import Element exposing (Element)
import Element.Background
import Element.Input
import Gen.Params.NewRoute exposing (Params)
import Gen.Route
import Lamdera
import Page
import Request exposing (Request)
import Route exposing (CommonRouteData, NewRouteData, RouteData)
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.element
        (\_ ->
            { init = init shared
            , update = update req
            , view = view
            , subscriptions = \_ -> Sub.none
            }
        )



-- INIT


type alias Model =
    { route : NewRouteData
    , datePickerModel : DatePicker.Model
    , datePickerText : String
    }


init : Shared.Model -> ( Model, Cmd Msg )
init shared =
    ( { route = Route.initialNewRouteData
      , datePickerModel = DatePicker.initWithToday shared.currentDate
      , datePickerText = ""
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = FieldUpdated String String
    | DatePickerUpdate DatePicker.ChangeEvent
    | CreateRoute


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update req msg model =
    case msg of
        FieldUpdated fieldName newValue ->
            ( { model | route = model.route |> updateEditRouteField fieldName newValue }
            , Cmd.none
            )

        DatePickerUpdate event ->
            ( updateDatePicker event model
            , Cmd.none
            )

        CreateRoute ->
            ( model
            , Cmd.batch
                [ Lamdera.sendToBackend <| Bridge.ToBackendCreateNewRoute model.route
                , Request.pushRoute (Gen.Route.Routes__Filter_ { filter = "all" }) req

                -- Todo, maybe go to wishlist if the route is not climbed, and log if it is
                ]
            )


updateDatePicker : DatePicker.ChangeEvent -> Model -> Model
updateDatePicker changeEvent model =
    let
        route =
            model.route

        newDateParams =
            updateDatePickerData changeEvent model.route.tickDate2 model.datePickerText model.datePickerModel
    in
    { model
        | route =
            { route
                | tickDate2 = newDateParams.date
            }
        , datePickerModel = newDateParams.model
        , datePickerText = newDateParams.text
    }


updateDatePickerData : DatePicker.ChangeEvent -> Maybe Date -> String -> DatePicker.Model -> { date : Maybe Date, model : DatePicker.Model, text : String }
updateDatePickerData changeEvent currentDatePicked text model =
    case changeEvent of
        DatePicker.DateChanged date ->
            { date = Just date
            , text = Date.toIsoString date
            , model = model
            }

        DatePicker.TextChanged newText ->
            { date = Date.fromIsoString newText |> Result.toMaybe
            , text = newText
            , model = model
            }

        DatePicker.PickerChanged subMsg ->
            { date = currentDatePicked
            , text = text
            , model = model |> DatePicker.update subMsg
            }


updateEditRouteField : String -> String -> CommonRouteData a -> CommonRouteData a
updateEditRouteField fieldName newValue rd =
    case fieldName of
        "name" ->
            { rd | name = newValue }

        "grade" ->
            { rd | grade = newValue }

        "area" ->
            { rd | area = newValue }

        "notes" ->
            { rd | notes = newValue }

        "type" ->
            case String.toInt newValue of
                Just index ->
                    { rd | type_ = indexToType index }

                Nothing ->
                    rd

        _ ->
            rd


indexToType : Int -> Route.ClimbType
indexToType index =
    case index of
        0 ->
            Route.Trad

        1 ->
            Route.Sport

        2 ->
            Route.Mix

        3 ->
            Route.Boulder

        _ ->
            Route.Trad


typeToIndex : Route.ClimbType -> Int
typeToIndex type_ =
    case type_ of
        Route.Trad ->
            0

        Route.Sport ->
            1

        Route.Mix ->
            2

        Route.Boulder ->
            3


typeListStr : List String
typeListStr =
    [ "Trad", "Sport", "Mix", "Boulder" ]



-- VIEW


view : Model -> View Msg
view model =
    { title = "Add new route"
    , body =
        CommonView.mainColumnWithToprow [ viewNewRoute model ]
    }


viewNewRoute : Model -> Element Msg
viewNewRoute model =
    let
        onelineEdit : String -> String -> String -> Element.Element Msg
        onelineEdit name prettyName value =
            Element.Input.text []
                { onChange = FieldUpdated name
                , text = value
                , placeholder = Nothing
                , label = Element.Input.labelLeft [] (Element.text prettyName)
                }
    in
    expandRouteColumn
        [ onelineEdit "name" "Name" model.route.name
        , onelineEdit "area" "Area" model.route.area
        , onelineEdit "grade" "Grade" model.route.grade
        , climbTypeSelect model
        , tickdatePicker model
        , notesField model.route.notes
        , createRouteButton
        ]


climbTypeSelect : Model -> Element Msg
climbTypeSelect model =
    CommonView.selectOne (String.fromInt >> FieldUpdated "type") typeListStr (typeToIndex model.route.type_)


createRouteButton : Element Msg
createRouteButton =
    Element.row [ Element.spacing 10 ]
        [ Element.Input.button []
            { onPress = Just <| CreateRoute
            , label = CommonView.actionButtonLabel "Create"
            }
        ]


notesField : String -> Element Msg
notesField text =
    Element.Input.multiline [ Element.width Element.fill ]
        { onChange = FieldUpdated "notes"
        , text = text
        , placeholder = Nothing
        , label = Element.Input.labelAbove [] (Element.text "Notes")
        , spellcheck = True
        }


tickdatePicker : Model -> Element Msg
tickdatePicker model =
    DatePicker.input []
        { onChange = DatePickerUpdate
        , selected = model.route.tickDate2
        , text = model.datePickerText
        , label = Element.Input.labelLeft [] <| Element.text "Tickdate"
        , placeholder = Just <| Element.Input.placeholder [] <| Element.text "yyyy-MM-dd"
        , settings = DatePicker.defaultSettings
        , model = model.datePickerModel
        }


expandRouteColumn : List (Element.Element msg) -> Element.Element msg
expandRouteColumn =
    Element.column
        [ Element.padding 12
        , Element.spacing 20
        , Element.Background.color (Element.rgb 0.75 0.8 0.8)
        , Element.width Element.fill
        ]
