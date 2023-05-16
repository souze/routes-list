module Filter exposing (..)

import Element exposing (Element)
import Element.Input
import List.Extra
import Set exposing (Set)
import Widget
import Widget.Icon as Icon
import Widget.Material as Material


type alias Model =
    { grade : Set String
    , tickdate : TickDateFilter
    }


type TickDateFilter
    = TickdateRangeFrom
    | TickdateRangeTo
    | TickdateRangeBetween
    | ShowHasTickdate
    | ShowWithoutTickdate
    | ShowAllTickdates


type Msg
    = PressedGradeFilter Int
    | PressedTickdateFilter


initialModel : Model
initialModel =
    { grade = Set.empty
    , tickdate = ShowAllTickdates
    }


update : List String -> Msg -> Model -> Model
update gradeOptions msg model =
    case msg of
        PressedGradeFilter index ->
            let
                grade : String
                grade =
                    List.Extra.getAt index gradeOptions |> Maybe.withDefault ""
            in
            { model
                | grade =
                    (if Set.member grade model.grade then
                        Set.remove

                     else
                        Set.insert
                    )
                        grade
                        model.grade
            }

        PressedTickdateFilter ->
            { model | tickdate = rotateTickdateFilter model.tickdate }


rotateTickdateFilter : TickDateFilter -> TickDateFilter
rotateTickdateFilter filter =
    case filter of
        ShowHasTickdate ->
            ShowWithoutTickdate

        ShowWithoutTickdate ->
            ShowAllTickdates

        ShowAllTickdates ->
            ShowHasTickdate

        _ ->
            ShowHasTickdate


viewFilter : (Msg -> msg) -> Model -> List String -> Element msg
viewFilter msgFn model uniqueGrades =
    Element.column [ Element.spacing 5 ]
        [ Element.text "Filters"
        , Element.row [ Element.spacing 10 ] [ Element.text "Grade", viewGradeFilter msgFn model.grade uniqueGrades ]
        , Element.row [ Element.spacing 10 ] [ Element.text "Tickdate", viewTickdateFilter msgFn model.tickdate ]
        ]


viewTickdateFilter : (Msg -> msg) -> TickDateFilter -> Element msg
viewTickdateFilter msgFn filter =
    Widget.textButton (Material.containedButton Material.defaultPalette)
        { text = tickdateToStr filter
        , onPress = Just (PressedTickdateFilter |> msgFn)
        }


tickdateToStr : TickDateFilter -> String
tickdateToStr filter =
    case filter of
        ShowHasTickdate ->
            "Has tickdate"

        ShowWithoutTickdate ->
            "Does not have tickdate"

        ShowAllTickdates ->
            "Anything"

        _ ->
            ""


viewGradeFilter : (Msg -> msg) -> Set String -> List String -> Element msg
viewGradeFilter msgFn selected options =
    { selected =
        selected |> Set.map (\selectedGrade -> options |> List.Extra.elemIndex selectedGrade |> Maybe.withDefault 0)
    , options =
        options
            |> List.map
                (\grade ->
                    { text = grade
                    , icon = always Element.none
                    }
                )
    , onSelect = \i -> Just <| (PressedGradeFilter i |> msgFn)
    }
        |> Widget.multiSelect
        |> Widget.buttonRow
            { elementRow = Material.buttonRow
            , content = Material.containedButton Material.defaultPalette
            }
