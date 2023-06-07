module RouteEditPane exposing (Model, Msg, init, update, view)

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
import Request exposing (Request)
import Route exposing (CommonRouteData, NewRouteData, RouteData)
import View exposing (View)


type alias Model =
    { route : NewRouteData
    , datePickerModel : DatePicker.Model
    , datePickerText : String
    }


init : Date -> NewRouteData -> Model
init currentDate initialData =
    { route = initialData
    , datePickerModel = DatePicker.initWithToday currentDate
    , datePickerText = ""
    }



-- UPDATE


type Msg
    = FieldUpdated String String
    | DatePickerUpdate DatePicker.ChangeEvent


update : Msg -> Model -> Model
update msg model =
    case msg of
        FieldUpdated fieldName newValue ->
            { model | route = model.route |> updateEditRouteField fieldName newValue }

        DatePickerUpdate event ->
            updateDatePicker event model


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

        4 ->
            Route.Aid

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

        Route.Aid ->
            4


typeListStr : List String
typeListStr =
    [ "Trad", "Sport", "Mix", "Boulder", "Aid" ]



-- VIEW


view : Model -> Element Msg
view model =
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
        ]


climbTypeSelect : Model -> Element Msg
climbTypeSelect model =
    CommonView.selectOne (String.fromInt >> FieldUpdated "type") typeListStr (typeToIndex model.route.type_)


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
