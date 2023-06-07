module Filter exposing (..)

import Element exposing (Element)
import Element.Input
import List.Extra
import Route
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
    = PressedGradeFilter String
    | PressedTickdateFilter


initialModel : Model
initialModel =
    { grade = Set.empty
    , tickdate = ShowAllTickdates
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        PressedGradeFilter grade ->
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


viewFilter : (Msg -> msg) -> Model -> Set String -> Element msg
viewFilter msgFn model uniqueGrades =
    Element.column [ Element.spacing 5, Element.width Element.fill ]
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


viewGradeFilter : (Msg -> msg) -> Set String -> Set String -> Element msg
viewGradeFilter msgFn selected options =
    let
        sortedGrades : List String
        sortedGrades =
            options |> Set.toList |> List.sortWith Route.gradeSorter
    in
    { selected =
        selected |> Set.map (\selectedGrade -> sortedGrades |> List.Extra.elemIndex selectedGrade |> Maybe.withDefault 0)
    , options =
        sortedGrades
            |> List.map
                (\grade ->
                    { text = grade
                    , icon = always Element.none
                    }
                )
    , onSelect = \i -> Just <| (PressedGradeFilter (List.Extra.getAt i sortedGrades |> Maybe.withDefault "") |> msgFn)
    }
        |> Widget.multiSelect
        |> Widget.wrappedButtonRow
            { elementRow = filledButtonRow
            , content = Material.containedButton Material.defaultPalette
            }


filledButtonRow : Widget.RowStyle msg
filledButtonRow =
    let
        br =
            Material.buttonRow
    in
    { br | elementRow = Element.width Element.fill :: br.elementRow }
