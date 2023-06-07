module Filter exposing (..)

import CommonView
import Element exposing (Element)
import Maybe.Extra
import Route exposing (RouteData)
import Set exposing (Set)
import Widget
import Widget.Material as Material


type alias Model =
    { grade : Set String
    , type_ : Set String
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
    | PressedTypeFilter String


initialModel : Model
initialModel =
    { grade = Set.empty
    , tickdate = ShowAllTickdates
    , type_ = Set.empty
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        PressedTypeFilter type_ ->
            { model | type_ = model.type_ |> toggleInSet type_ }

        PressedGradeFilter grade ->
            { model | grade = model.grade |> toggleInSet grade }

        PressedTickdateFilter ->
            { model | tickdate = rotateTickdateFilter model.tickdate }


toggleInSet : comparable -> Set comparable -> Set comparable
toggleInSet item set =
    let
        removeOrInsertFn : comparable -> Set comparable -> Set comparable
        removeOrInsertFn =
            if Set.member item set then
                Set.remove

            else
                Set.insert
    in
    removeOrInsertFn item set


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



-- Filtering


applyCustomFilter : Model -> (RouteData -> Bool)
applyCustomFilter filter =
    \rd ->
        filterGrade filter.grade rd
            && filterTickdate filter.tickdate rd
            && filterType filter.type_ rd


filterType : Set String -> RouteData -> Bool
filterType filter rd =
    if Set.isEmpty filter then
        True

    else
        Set.member (Route.climbTypeToString rd.type_) filter


filterTickdate : TickDateFilter -> RouteData -> Bool
filterTickdate filter =
    case filter of
        TickdateRangeFrom ->
            \_ -> True

        TickdateRangeTo ->
            \_ -> True

        TickdateRangeBetween ->
            \_ -> True

        ShowHasTickdate ->
            hasTickDate

        ShowWithoutTickdate ->
            hasTickDate >> not

        ShowAllTickdates ->
            \_ -> True


hasTickDate : RouteData -> Bool
hasTickDate rd =
    rd.tickDate2 |> Maybe.Extra.isJust


filterGrade : Set String -> RouteData -> Bool
filterGrade filter =
    if Set.isEmpty filter then
        \_ -> True

    else
        \rd -> Set.member rd.grade filter



-- View


viewFilter : (Msg -> msg) -> Model -> Set String -> Element msg
viewFilter msgFn model uniqueGrades =
    Element.column [ Element.spacing 5, Element.width Element.fill ]
        [ Element.text "Filters"
        , Element.row [ Element.spacing 10 ] [ Element.text "Type", viewTypeFilter model.type_ |> Element.map msgFn ]
        , Element.row [ Element.spacing 10 ] [ Element.text "Grade", viewGradeFilter model.grade uniqueGrades |> Element.map msgFn ]
        , Element.row [ Element.spacing 10 ] [ Element.text "Tickdate", viewTickdateFilter msgFn model.tickdate ]
        ]


viewTypeFilter : Set String -> Element Msg
viewTypeFilter selected =
    CommonView.selectMany selected Route.climbTypeListStr
        |> Element.map PressedTypeFilter


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


viewGradeFilter : Set String -> Set String -> Element Msg
viewGradeFilter selected options =
    let
        sortedGrades : List String
        sortedGrades =
            options |> Set.toList |> List.sortWith Route.gradeSorter
    in
    CommonView.selectMany selected sortedGrades
        |> Element.map PressedGradeFilter
