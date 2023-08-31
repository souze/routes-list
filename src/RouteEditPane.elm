module RouteEditPane exposing (Model, Msg(..), init, update, view)

import Bridge
import CommonView
import Date exposing (Date)
import DatePicker
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Input
import Gen.Params.NewRoute exposing (Params)
import Gen.Route
import Lamdera
import List.Extra
import Request exposing (Request)
import Route exposing (CommonRouteData, NewRouteData, RouteData)
import Set
import View exposing (View)


type alias Model =
    { route : NewRouteData
    , datePickerModel : DatePicker.Model
    , datePickerText : String
    , picturesText : String
    , tagText : String
    }


init : Date -> NewRouteData -> Model
init currentDate initialData =
    { route = initialData
    , datePickerModel = DatePicker.initWithToday currentDate
    , datePickerText = ""
    , picturesText = initialPicturesText initialData.images
    , tagText = ""
    }


initialPicturesText : List String -> String
initialPicturesText data =
    String.join "\n" data



-- UPDATE


type Msg
    = FieldUpdated String String
    | DatePickerUpdate DatePicker.ChangeEvent
    | AddTagPressed String
    | RemoveTagPressed String


update : Msg -> Model -> Model
update msg model =
    case msg of
        FieldUpdated fieldName newValue ->
            { model
                | route = model.route |> updateEditRouteField fieldName newValue
                , picturesText =
                    if fieldName == "pictures" then
                        newValue

                    else
                        model.picturesText
                , tagText =
                    if fieldName == "tag" then
                        newValue

                    else
                        model.tagText
            }

        DatePickerUpdate event ->
            updateDatePicker event model

        AddTagPressed text ->
            { model
                | route = addTag text model.route
                , tagText = ""
            }

        RemoveTagPressed text ->
            { model | route = removeTag text model.route }


removeTag : String -> NewRouteData -> NewRouteData
removeTag tag rd =
    { rd
        | tags =
            rd.tags
                |> List.Extra.remove tag
    }


addTag : String -> NewRouteData -> NewRouteData
addTag tag rd =
    { rd
        | tags =
            rd.tags
                |> Set.fromList
                |> Set.insert tag
                |> Set.toList
    }


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
            , model = model |> DatePicker.close
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

        "pictures" ->
            { rd | images = newValue |> parsePictures }

        "type" ->
            case String.toInt newValue of
                Just index ->
                    { rd | type_ = indexToType index }

                Nothing ->
                    rd

        _ ->
            rd


parsePictures : String -> List String
parsePictures input =
    case String.trim input of
        "" ->
            []

        trimmedInput ->
            trimmedInput
                |> String.lines
                |> List.map String.trim
                |> List.filter (\s -> s /= "")


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
        , viewTags model.tagText model.route.tags
        , pictures model.picturesText
        , notesField model.route.notes
        ]


viewTags : String -> List String -> Element Msg
viewTags text existingTags =
    Element.column [ Element.spacing 12 ]
        [ Element.wrappedRow [ Element.spacing 12, Element.width Element.fill ]
            [ Element.Input.text [ Element.width Element.fill, CommonView.onEnter (AddTagPressed text) ]
                { onChange = FieldUpdated "tag"
                , text = text
                , placeholder = Just <| placeholderText "New tag"
                , label = Element.Input.labelLeft [] (Element.text "Tag")
                }
            , CommonView.buttonToSendEvent "Add" (AddTagPressed text)
            ]
        , viewExistingTags existingTags
        ]


viewExistingTags : List String -> Element Msg
viewExistingTags tags =
    if List.isEmpty tags then
        Element.none

    else
        Element.wrappedRow [ Element.spacing 12, Element.padding 20 ]
            (List.map viewExistingTag tags)


gray : Element.Color
gray =
    Element.rgb255 130 130 130


viewExistingTag : String -> Element Msg
viewExistingTag tag =
    Element.Input.button
        [ Element.Background.color gray
        , Element.padding 5
        , Element.Border.rounded 6
        ]
        { label = Element.text tag
        , onPress = Just <| RemoveTagPressed tag
        }


placeholderText : String -> Element.Input.Placeholder Msg
placeholderText text =
    Element.Input.placeholder [] (Element.text text)


pictures : String -> Element Msg
pictures text =
    Element.Input.multiline [ Element.width Element.fill ]
        { onChange = FieldUpdated "pictures"
        , text = text
        , placeholder = Just <| placeholderText "Newline separated list of URLs"
        , label = Element.Input.labelAbove [] (Element.text "Pictures")
        , spellcheck = True
        }


climbTypeSelect : Model -> Element Msg
climbTypeSelect model =
    CommonView.selectOne (String.fromInt >> FieldUpdated "type") typeListStr (typeToIndex model.route.type_)


notesField : String -> Element Msg
notesField text =
    Element.Input.multiline [ Element.width Element.fill ]
        { onChange = FieldUpdated "notes"
        , text = text
        , placeholder = Just <| placeholderText "Notes..."
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
