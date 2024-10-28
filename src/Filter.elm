module Filter exposing (..)

import ClimbRoute exposing (RouteData)
import CommonView
import Element exposing (Element)
import Maybe.Extra
import Set exposing (Set)
import Widget
import Widget.Material as Material


type alias Model =
    { grade : Set String
    , type_ : Set String
    , tickdate : TickDateFilter
    , tags : Set String
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
    | PressedTagFilter String


initialModel : Model
initialModel =
    { grade = Set.empty
    , tickdate = ShowAllTickdates
    , type_ = Set.empty
    , tags = Set.empty
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

        PressedTagFilter tag ->
            { model | tags = model.tags |> toggleInSet tag }


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


applyCustomFilter : Model -> RouteData -> Bool
applyCustomFilter filter rd =
    filterGrade filter.grade rd
        && filterTickdate filter.tickdate rd
        && filterType filter.type_ rd
        && filterTags filter.tags rd


filterTags : Set String -> RouteData -> Bool
filterTags include rd =
    Set.isEmpty include
        || not (Set.intersect include (rd.tags |> Set.fromList) |> Set.isEmpty)


filterType : Set String -> RouteData -> Bool
filterType filter rd =
    if Set.isEmpty filter then
        True

    else
        Set.member (ClimbRoute.climbTypeToString rd.type_) filter


filterTickdate : TickDateFilter -> RouteData -> Bool
filterTickdate filter rd =
    case filter of
        TickdateRangeFrom ->
            True

        TickdateRangeTo ->
            True

        TickdateRangeBetween ->
            True

        ShowHasTickdate ->
            hasTickDate rd

        ShowWithoutTickdate ->
            hasTickDate rd |> not

        ShowAllTickdates ->
            True


hasTickDate : RouteData -> Bool
hasTickDate rd =
    rd.tickDate2 |> Maybe.Extra.isJust


filterGrade : Set String -> RouteData -> Bool
filterGrade filter rd =
    if Set.isEmpty filter then
        True

    else
        Set.member rd.grade filter



-- View


viewFilter : (Msg -> msg) -> Model -> Set String -> Set String -> Element msg
viewFilter msgFn model uniqueGrades uniqueTags =
    Element.column [ Element.spacing 5, Element.width Element.fill ]
        [ Element.text "Filters"
        , Element.row [ Element.spacing 10 ] [ Element.text "Type", viewTypeFilter model.type_ |> Element.map msgFn ]
        , Element.row [ Element.spacing 10 ] [ Element.text "Grade", viewGradeFilter model.grade uniqueGrades |> Element.map msgFn ]
        , Element.row [ Element.spacing 10 ] [ Element.text "Tickdate", viewTickdateFilter msgFn model.tickdate ]
        , Element.row [ Element.spacing 10 ] [ Element.text "Tags", viewTags model.tags uniqueTags |> Element.map msgFn ]
        ]


viewTags : Set String -> Set String -> Element Msg
viewTags selected options =
    let
        -- There might be selected tags that are no longer present in the route-list. If a route was edited
        validSelected =
            Set.intersect selected options

        sortedTags : List String
        sortedTags =
            options |> Set.toList |> List.sort
    in
    CommonView.selectMany validSelected sortedTags
        |> Element.map PressedTagFilter


viewTypeFilter : Set String -> Element Msg
viewTypeFilter selected =
    CommonView.selectMany selected ClimbRoute.climbTypeListStr
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
            options |> Set.toList |> List.sortWith ClimbRoute.gradeSorter
    in
    CommonView.selectMany selected sortedGrades
        |> Element.map PressedGradeFilter
