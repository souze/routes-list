module Pages.Routes.Filter_ exposing (Model, Msg, page)

import Bridge
import CommonView
import Date exposing (Date)
import DatePicker
import Dict exposing (Dict)
import Effect
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font
import Element.Input
import Filter
import Gen.Params.Routes.Filter_ exposing (Params)
import Gen.Route
import Html
import Html.Attributes
import Lamdera
import List.Extra
import Maybe.Extra
import Page
import Request
import Route exposing (..)
import Set exposing (Set)
import Shared
import Sorter
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.element
        (\user ->
            { init = init req shared
            , update = update shared req
            , view = view shared
            , subscriptions = subscriptions
            }
        )



-- INIT


type alias Filter =
    { filter : Filter.Model
    , sorter : Sorter.Model
    }


type alias RowData =
    { expanded : Bool
    , datePickerData : DatePickerData
    , route : RouteDataEdit
    }


type alias DatePickerData =
    { dateText : String
    , pickerModel : DatePicker.Model
    }


type alias Metadata =
    { expanded : Bool
    , datePickerData : DatePickerData
    , editRoute : Maybe RouteData
    }


initialMetadata : Metadata
initialMetadata =
    { expanded = False
    , datePickerData = { dateText = "", pickerModel = DatePicker.init }
    , editRoute = Nothing
    }


initialMetadataToday : Date -> Metadata
initialMetadataToday today =
    { expanded = False
    , datePickerData = { dateText = "", pickerModel = DatePicker.initWithToday today }
    , editRoute = Nothing
    }


type alias Model =
    { filter : Filter
    , showSortBox : Bool
    , metadatas : Dict Int Metadata
    }


init : Request.With Params -> Shared.Model -> ( Model, Cmd Msg )
init req shared =
    let
        filter : Maybe Filter
        filter =
            case req.params.filter of
                "all" ->
                    Just { filter = initialAllFilter, sorter = Sorter.initialModel }

                "wishlist" ->
                    Just { filter = { initialAllFilter | tickdate = Filter.ShowWithoutTickdate }, sorter = Sorter.initialModel }

                "log" ->
                    Just { filter = { initialAllFilter | tickdate = Filter.ShowHasTickdate }, sorter = Sorter.initialModel }

                _ ->
                    Nothing
    in
    case filter of
        Just filter_ ->
            ( { filter = filter_
              , showSortBox = False
              , metadatas = Dict.empty
              }
            , Cmd.none
            )

        Nothing ->
            ( { filter = { filter = initialAllFilter, sorter = Sorter.initialModel }
              , showSortBox = False
              , metadatas = Dict.empty
              }
            , Request.pushRoute (Gen.Route.Routes__Filter_ { filter = "all" }) req
            )


initialAllFilter : Filter.Model
initialAllFilter =
    Filter.initialModel


toFrontendRowData : Date -> Dict Int Metadata -> List RouteData -> List RowData
toFrontendRowData today metadatas routes =
    routes
        |> List.map
            (\route ->
                let
                    md : Metadata
                    md =
                        metadatas
                            |> Dict.get (getIntId route.id)
                            |> Maybe.withDefault (initialMetadataToday today)
                in
                { expanded = md.expanded
                , datePickerData = md.datePickerData
                , route =
                    { realRoute = route
                    , editRoute = md.editRoute
                    }
                }
            )



-- UPDATE


type Msg
    = ToggleFilters
    | ButtonPressed ButtonId
    | FieldUpdated RouteId String String
    | DatePickerUpdate RouteId DatePicker.ChangeEvent
    | SortSelected Sorter.SorterMsg
    | FilterMsg Filter.Msg


update : Shared.Model -> Request.With params -> Msg -> Model -> ( Model, Cmd Msg )
update shared req msg model =
    case msg of
        ToggleFilters ->
            ( { model | showSortBox = not model.showSortBox }
            , Cmd.none
            )

        ButtonPressed id ->
            buttonPressed id req shared.currentDate model

        FieldUpdated routeId fieldName newValue ->
            ( fieldUpdated routeId fieldName newValue model
            , Cmd.none
            )

        DatePickerUpdate routeId updateEvent ->
            ( updateDatePicker routeId updateEvent model
            , Cmd.none
            )

        SortSelected sorterMsg ->
            ( { model | filter = model.filter |> updateSorter sorterMsg }
            , Cmd.none
            )

        FilterMsg filterMsg ->
            ( { model | filter = model.filter |> updateFilter (uniqueGrades shared.routes) filterMsg }
            , Cmd.none
            )


updateFilter : List String -> Filter.Msg -> Filter -> Filter
updateFilter gradeOptions msg filter =
    { filter
        | filter =
            Filter.update gradeOptions msg filter.filter
    }


updateSorter : Sorter.SorterMsg -> Filter -> Filter
updateSorter msg filter =
    { filter
        | sorter =
            Sorter.update msg filter.sorter
    }


updateDatePicker : RouteId -> DatePicker.ChangeEvent -> Model -> Model
updateDatePicker routeId changeEvent model =
    { model
        | metadatas =
            model.metadatas
                |> mapRouteIdMetadata routeId (updateDateTickerInRow changeEvent)
    }


mapRouteIdMetadata : RouteId -> (Metadata -> Metadata) -> Dict Int Metadata -> Dict Int Metadata
mapRouteIdMetadata (RouteId id) f metadatas =
    Dict.get id metadatas
        |> Maybe.withDefault initialMetadata
        |> f
        |> (\md -> Dict.insert id md metadatas)


mapRouteIdMetadataToday : Date -> RouteId -> (Metadata -> Metadata) -> Dict Int Metadata -> Dict Int Metadata
mapRouteIdMetadataToday today (RouteId id) f metadatas =
    Dict.get id metadatas
        |> Maybe.withDefault (initialMetadataToday today)
        |> f
        |> (\md -> Dict.insert id md metadatas)


mapRouteIdMetadataEditRoute : RouteId -> (RouteData -> RouteData) -> Dict Int Metadata -> Dict Int Metadata
mapRouteIdMetadataEditRoute id f =
    mapRouteIdMetadata id (\md -> { md | editRoute = md.editRoute |> Maybe.map f })



-- { model | rows = mapRowWithRouteId (RouteId id) (updateDateTickerInRow changeEvent) model.rows }


updateDateTickerInRow : DatePicker.ChangeEvent -> Metadata -> Metadata
updateDateTickerInRow changeEvent metadata =
    let
        editRoute : Maybe RouteData
        editRoute =
            metadata.editRoute

        ( newDate, newDpd ) =
            updateDatePickerData
                changeEvent
                (metadata.editRoute |> Maybe.map .tickDate2 |> Maybe.Extra.join)
                metadata.datePickerData
    in
    { metadata
        | datePickerData = newDpd
        , editRoute = editRoute |> Maybe.map (\r -> { r | tickDate2 = newDate })
    }


updateDatePickerData : DatePicker.ChangeEvent -> Maybe Date -> DatePickerData -> ( Maybe Date, DatePickerData )
updateDatePickerData changeEvent currentDatePicked dpd =
    case changeEvent of
        DatePicker.DateChanged date ->
            ( Just date
            , { dpd
                | dateText = Date.toIsoString date
              }
            )

        DatePicker.TextChanged text ->
            ( Date.fromIsoString text
                |> Result.toMaybe
            , { dpd | dateText = text }
            )

        DatePicker.PickerChanged subMsg ->
            ( currentDatePicked
            , { dpd
                | pickerModel =
                    dpd.pickerModel
                        |> DatePicker.update subMsg
              }
            )


fieldUpdated : RouteId -> String -> String -> Model -> Model
fieldUpdated routeId fieldName newValue model =
    { model
        | metadatas =
            model.metadatas
                |> mapRouteIdMetadataEditRoute routeId (updateEditRouteField fieldName newValue)
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

        _ ->
            rd


type ButtonId
    = ExpandRouteButton RouteId
    | EditRouteButton RouteData
    | SaveButton RouteData
    | DiscardButton RouteId
    | RemoveButton RouteId
    | CreateButton


buttonPressed : ButtonId -> Request.With params -> Date -> Model -> ( Model, Cmd Msg )
buttonPressed id req today model =
    case id of
        ExpandRouteButton routeId ->
            ( toggleExpansionRouteId routeId today model
            , Cmd.none
            )

        EditRouteButton route ->
            ( enableEdit route model
            , Cmd.none
            )

        SaveButton route ->
            ( discardChanges route.id model
            , Lamdera.sendToBackend <| Bridge.UpdateRoute route
            )

        DiscardButton routeId ->
            ( discardChanges routeId model
            , Cmd.none
            )

        RemoveButton routeId ->
            ( discardChanges routeId model
            , Lamdera.sendToBackend <| Bridge.RemoveRoute routeId
            )

        CreateButton ->
            ( model
            , Cmd.none
            )


discardChanges : RouteId -> Model -> Model
discardChanges id m =
    { m
        | metadatas =
            m.metadatas
                |> mapRouteIdMetadata id (\md -> { md | editRoute = Nothing })
    }


enableEdit : RouteData -> Model -> Model
enableEdit rd m =
    { m
        | metadatas =
            m.metadatas
                |> mapRouteIdMetadata rd.id (\md -> { md | editRoute = Just rd })
    }


toggleExpansionRouteId : RouteId -> Date -> Model -> Model
toggleExpansionRouteId id today m =
    { m
        | metadatas =
            m.metadatas
                |> mapRouteIdMetadataToday today id (\md -> { md | expanded = not md.expanded })
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Route List"
    , body = viewBody shared model
    }


viewBody : Shared.Model -> Model -> Element Msg
viewBody shared model =
    CommonView.mainColumn
        (CommonView.header
            :: viewSortBox shared model
            :: viewRouteList shared model
        )


viewSortBox : Shared.Model -> Model -> Element Msg
viewSortBox shared model =
    if model.showSortBox then
        Element.column [ Element.spacing 10 ]
            [ toggleFilterButton
            , Filter.viewFilter FilterMsg model.filter.filter (shared.routes |> uniqueGrades)
            , Sorter.sortOptions SortSelected model.filter.sorter
            ]

    else
        toggleFilterButton


toggleFilterButton : Element Msg
toggleFilterButton =
    CommonView.buttonToSendEvent "Filter" ToggleFilters


uniqueGrades : List Route.RouteData -> List String
uniqueGrades routes =
    routes
        |> List.map .grade
        |> List.sort
        |> List.Extra.unique


viewRouteList : Shared.Model -> Model -> List (Element Msg)
viewRouteList shared model =
    shared.routes
        |> toFrontendRowData shared.currentDate model.metadatas
        |> filterAndSortView model.filter
        |> List.map viewRoute


filterAndSortView : Filter -> List RowData -> List RowData
filterAndSortView filter rows =
    let
        ( filterF, sorterF ) =
            filterAndSorter filter
    in
    rows
        |> List.filter filterF
        |> sorterF


filterAndSorter : Filter -> ( RowData -> Bool, List RowData -> List RowData )
filterAndSorter { filter, sorter } =
    ( applyCustomFilter filter
    , applyCustomSorter sorter
    )


applyCustomSorter : Sorter.Model -> (List RowData -> List RowData)
applyCustomSorter sortAttributes =
    case List.head sortAttributes of
        Nothing ->
            identity

        Just ( attr, order ) ->
            \l -> sortByAttr attr order l


sortByAttr : Sorter.SortAttribute -> Sorter.SortOrder -> List RowData -> List RowData
sortByAttr attr order l =
    l
        |> sortByAttr2 attr
        |> maybeReverse order


sortByAttr2 : Sorter.SortAttribute -> List RowData -> List RowData
sortByAttr2 attr =
    case attr of
        Sorter.Tickdate ->
            List.sortWith tickdateSorter

        _ ->
            List.sortBy (getComparableAttr attr)


getComparableAttr : Sorter.SortAttribute -> RowData -> String
getComparableAttr attr rd =
    case attr of
        Sorter.Name ->
            rd.route.realRoute.name

        Sorter.Grade ->
            rd.route.realRoute.grade

        Sorter.Area ->
            rd.route.realRoute.area

        _ ->
            ""


maybeReverse : Sorter.SortOrder -> List a -> List a
maybeReverse order =
    case order of
        Sorter.Ascending ->
            identity

        Sorter.Descending ->
            List.reverse


applyCustomFilter : Filter.Model -> (RowData -> Bool)
applyCustomFilter filter =
    \rd ->
        filterGrade filter.grade rd
            && filterTickdate filter.tickdate rd


filterTickdate : Filter.TickDateFilter -> (RowData -> Bool)
filterTickdate filter =
    case filter of
        Filter.TickdateRangeFrom ->
            \rd -> True

        Filter.TickdateRangeTo ->
            \rd -> True

        Filter.TickdateRangeBetween ->
            \rd -> True

        Filter.ShowHasTickdate ->
            hasTickDate

        Filter.ShowWithoutTickdate ->
            hasTickDate >> not

        Filter.ShowAllTickdates ->
            \_ -> True


hasTickDate : RowData -> Bool
hasTickDate rd =
    rd.route.realRoute.tickDate2 |> Maybe.Extra.isJust


filterGrade : Set String -> (RowData -> Bool)
filterGrade filter =
    if Set.isEmpty filter then
        \_ -> True

    else
        \rd -> Set.member rd.route.realRoute.grade filter


tickdateSorter : RowData -> RowData -> Order
tickdateSorter rd1 rd2 =
    case ( rd1.route.realRoute.tickDate2, rd2.route.realRoute.tickDate2 ) of
        ( Just a, Just b ) ->
            Date.compare a b

        ( Just _, Nothing ) ->
            GT

        ( Nothing, Just _ ) ->
            LT

        _ ->
            LT


viewRoute : RowData -> Element Msg
viewRoute rd =
    Element.column [ Element.spacing 5, Element.width Element.fill ]
        ([ viewRouteOneline rd.route ]
            |> listAppendIf rd.expanded (viewRouteExpanded rd.route rd.datePickerData)
        )


viewRouteExpanded : RouteDataEdit -> DatePickerData -> Element.Element Msg
viewRouteExpanded routeDataEdit datePickerData =
    case routeDataEdit.editRoute of
        Just editRoute ->
            viewRouteExpandedEdit editRoute datePickerData

        Nothing ->
            viewRouteExpandedSolid routeDataEdit.realRoute


expandRouteColumn : List (Element.Element msg) -> Element.Element msg
expandRouteColumn =
    Element.column
        [ Element.padding 12
        , Element.spacing 20
        , Element.Background.color (Element.rgb 0.75 0.8 0.8)
        , Element.width Element.fill
        ]


viewRouteExpandedSolid : RouteData -> Element.Element Msg
viewRouteExpandedSolid rd =
    expandRouteColumn
        [ Element.el [ Element.Font.size 20 ] <| Element.text rd.name
        , Element.text <| "Area: " ++ rd.area
        , Element.text <| "Grade: " ++ rd.grade
        , Element.text <| "Type: " ++ climbTypeToString rd.type_
        , case rd.tickDate2 of
            Just tickdate ->
                Element.text <| "Climbed on " ++ Date.toIsoString tickdate

            Nothing ->
                Element.text <| "Not climbed"

        -- , Element.text <| "Notes:\n---\n" ++ rd.notes
        , if rd.notes /= "" then
            Element.paragraph
                [ Element.Border.solid
                , Element.Border.width 2
                , Element.Border.color (Element.rgb 0.5 0.5 0.5)
                , Element.padding 7
                ]
                [ Element.text <| rd.notes ]

          else
            Element.none
        , if List.isEmpty rd.images then
            Element.none

          else
            Element.none
        , if List.isEmpty rd.videos then
            Element.none

          else
            Element.html <|
                Html.video
                    [ Html.Attributes.width 600
                    , Html.Attributes.height 200
                    , Html.Attributes.controls True
                    ]
                    [ Html.source
                        [ Html.Attributes.type_ "video/mp4"
                        , Html.Attributes.src "https://filedn.com/looL0p0cbRa5gF0z3SS8rBb/route_list/20200408_175256.mp4"
                        ]
                        []
                    ]
        , Element.Input.button []
            { onPress = Just <| ButtonPressed (EditRouteButton rd)
            , label = CommonView.actionButtonLabel "Edit"
            }
        ]


viewRouteExpandedEdit : RouteData -> DatePickerData -> Element Msg
viewRouteExpandedEdit rd datePickerData =
    viewExistingOrNewRouteExpanded rd.id rd datePickerData


listAppendIf : Bool -> a -> List a -> List a
listAppendIf pred item list =
    if pred then
        list ++ [ item ]

    else
        list


viewRouteOneline : RouteDataEdit -> Element.Element Msg
viewRouteOneline { realRoute } =
    let
        rd =
            realRoute
    in
    Element.Input.button
        [ Element.width Element.fill ]
        { onPress = Just <| ButtonPressed (ExpandRouteButton rd.id)
        , label =
            Element.wrappedRow
                [ Element.padding 12
                , Element.spacing 20
                , Element.Background.color (Element.rgb 0.8 0.8 0.8)
                , Element.width Element.fill
                ]
                [ Element.el [ Element.width (Element.px 17) ] (Element.text rd.grade)
                , Element.el [] <| Element.text rd.name
                , rd.tickDate2
                    |> Maybe.map
                        (\tickDate -> Element.el [ Element.alignRight ] (Element.text (Date.toIsoString tickDate)))
                    |> Maybe.withDefault Element.none
                , Element.el [ Element.alignRight ]
                    (Element.text
                        (case rd.tickDate2 of
                            Just _ ->
                                "☑️"

                            Nothing ->
                                "⏹️"
                        )
                    )
                ]
        }


viewExistingOrNewRouteExpanded : RouteId -> CommonRouteData a -> DatePickerData -> Element.Element Msg
viewExistingOrNewRouteExpanded routeId rd datePickerData =
    let
        onelineEdit : String -> String -> String -> Element.Element Msg
        onelineEdit name prettyName value =
            Element.Input.text []
                { onChange = FieldUpdated routeId name
                , text = value
                , placeholder = Nothing
                , label = Element.Input.labelLeft [] (Element.text prettyName)
                }
    in
    expandRouteColumn
        [ onelineEdit "name" "Name" rd.name
        , onelineEdit "area" "Area" rd.area
        , onelineEdit "grade" "Grade" rd.grade
        , DatePicker.input []
            { onChange = DatePickerUpdate routeId
            , selected = rd.tickDate2
            , text = datePickerData.dateText
            , label = Element.Input.labelLeft [] <| Element.text "Tickdate"
            , placeholder = Just <| Element.Input.placeholder [] <| Element.text "yyyy-MM-dd"
            , settings = DatePicker.defaultSettings
            , model = datePickerData.pickerModel
            }
        , Element.Input.multiline [ Element.width Element.fill ]
            { onChange = FieldUpdated routeId "notes"
            , text = rd.notes
            , placeholder = Nothing
            , label = Element.Input.labelAbove [] (Element.text "Notes")
            , spellcheck = True
            }
        , Element.row [ Element.spacing 10 ]
            [ CommonView.buttonToSendEvent "Save" <| ButtonPressed <| SaveButton (commonToExistingRoute routeId rd)
            , CommonView.buttonToSendEvent "Discard" <| ButtonPressed <| DiscardButton routeId
            , CommonView.buttonToSendEvent "Remove" <| ButtonPressed <| RemoveButton routeId

            -- (MsgGoToPage
            --     (ConfirmPage
            --         { text = ""
            --         , label = "Are you sure you want to remove the route \"" ++ rd.name ++ "\"?"
            --         , code = "remove"
            --         , event = RemoveRoute routeId
            --         , abortPage = RoutePage ViewAll
            --         }
            --     )
            -- )
            ]
        ]
