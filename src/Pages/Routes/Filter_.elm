module Pages.Routes.Filter_ exposing (ButtonId(..), DatePickerData, Filter, Metadata, Model, Msg(..), page)

import Bridge
import CommonView
import Date exposing (Date)
import DatePicker
import Dict exposing (Dict)
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
import Maybe.Extra
import Page
import Request
import Route exposing (..)
import RouteEditPane
import Set exposing (Set)
import Shared
import Sorter
import Time
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.element
        (\_ ->
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


type alias DatePickerData =
    { dateText : String
    , pickerModel : DatePicker.Model
    }


type alias Metadata =
    { expanded : Bool
    , routeId : RouteId
    , editRoute : Maybe RouteEditPane.Model
    }


initialMetadata : RouteId -> Metadata
initialMetadata routeId =
    { expanded = False
    , routeId = routeId
    , editRoute = Nothing
    }


type alias Model =
    { filter : Filter
    , showSortBox : Bool
    , metadatas : Dict Int Metadata
    }


init : Request.With Params -> Shared.Model -> ( Model, Cmd Msg )
init req _ =
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


initialDate : Date
initialDate =
    Date.fromCalendarDate 2023 Time.Jan 1


initialAllFilter : Filter.Model
initialAllFilter =
    Filter.initialModel



-- UPDATE


type Msg
    = ToggleFilters
    | ButtonPressed ButtonId
    | SortSelected Sorter.SorterMsg
    | FilterMsg Filter.Msg
    | RouteEditPaneMsg RouteId RouteEditPane.Msg


update : Shared.Model -> Request.With params -> Msg -> Model -> ( Model, Cmd Msg )
update shared req msg model =
    case msg of
        RouteEditPaneMsg rid editPaneMsg ->
            ( { model | metadatas = model.metadatas |> updateRouteEditPane rid editPaneMsg }
            , Cmd.none
            )

        ToggleFilters ->
            ( { model | showSortBox = not model.showSortBox }
            , Cmd.none
            )

        ButtonPressed id ->
            buttonPressed id shared.currentDate model

        SortSelected sorterMsg ->
            ( { model | filter = model.filter |> updateSorter sorterMsg }
            , Cmd.none
            )

        FilterMsg filterMsg ->
            ( { model | filter = model.filter |> updateFilter filterMsg }
            , Cmd.none
            )


updateRouteEditPane : RouteId -> RouteEditPane.Msg -> Dict Int Metadata -> Dict Int Metadata
updateRouteEditPane rid msg metadatas =
    metadatas
        |> mapRouteIdMetadata rid
            (\md ->
                case md.editRoute of
                    Just route ->
                        { md | editRoute = Just (route |> RouteEditPane.update msg) }

                    Nothing ->
                        md
            )


updateFilter : Filter.Msg -> Filter -> Filter
updateFilter msg filter =
    { filter
        | filter =
            Filter.update msg filter.filter
    }


updateSorter : Sorter.SorterMsg -> Filter -> Filter
updateSorter msg filter =
    { filter
        | sorter =
            Sorter.update msg filter.sorter
    }


mapRouteIdMetadata : RouteId -> (Metadata -> Metadata) -> Dict Int Metadata -> Dict Int Metadata
mapRouteIdMetadata (RouteId id) f metadatas =
    Dict.get id metadatas
        |> Maybe.withDefault (initialMetadata (RouteId id))
        |> f
        |> (\md -> Dict.insert id md metadatas)


type ButtonId
    = ExpandRouteButton RouteId
    | EditRouteButton RouteData
    | SaveButton RouteData
    | DiscardButton RouteId
    | RemoveButton RouteId
    | CreateButton


buttonPressed : ButtonId -> Date -> Model -> ( Model, Cmd Msg )
buttonPressed id currentDate model =
    case id of
        ExpandRouteButton routeId ->
            ( toggleExpansionRouteId routeId model
            , Cmd.none
            )

        EditRouteButton route ->
            ( enableEdit currentDate route model
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


enableEdit : Date -> RouteData -> Model -> Model
enableEdit currentDate rd m =
    { m
        | metadatas =
            m.metadatas
                |> mapRouteIdMetadata rd.id
                    (\md ->
                        { md
                            | editRoute =
                                Just
                                    (RouteEditPane.init
                                        currentDate
                                        (Route.newRouteDataFromExisting rd)
                                    )
                        }
                    )
    }


toggleExpansionRouteId : RouteId -> Model -> Model
toggleExpansionRouteId id m =
    { m
        | metadatas =
            m.metadatas
                |> mapRouteIdMetadata id (\md -> { md | expanded = not md.expanded })
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


uniqueGrades : List Route.RouteData -> Set String
uniqueGrades routes =
    routes
        |> List.map .grade
        |> Set.fromList


viewRouteList : Shared.Model -> Model -> List (Element Msg)
viewRouteList shared model =
    shared.routes
        |> filterAndSortView model.filter
        -- List RouteData
        -- |> toFrontendRowData shared.currentDate model.metadatas
        |> withMetadata model.metadatas
        -- List (Metadata, RouteData)
        |> List.map viewRoute


getMetadata : RouteId -> Dict Int Metadata -> Maybe Metadata
getMetadata (RouteId id) metadatas =
    metadatas |> Dict.get id


withMetadata : Dict Int Metadata -> List RouteData -> List ( Metadata, RouteData )
withMetadata metadatas routes =
    routes
        |> List.map
            (\r ->
                ( metadatas
                    |> getMetadata r.id
                    |> Maybe.withDefault (initialMetadata r.id)
                , r
                )
            )


filterAndSortView : Filter -> List RouteData -> List RouteData
filterAndSortView filter rows =
    let
        ( filterF, sorterF ) =
            filterAndSorter filter
    in
    rows
        |> List.filter filterF
        |> sorterF


filterAndSorter : Filter -> ( RouteData -> Bool, List RouteData -> List RouteData )
filterAndSorter { filter, sorter } =
    ( Filter.applyCustomFilter filter
    , Sorter.applyCustomSorter sorter
    )


viewRoute : ( Metadata, RouteData ) -> Element Msg
viewRoute ( meta, rd ) =
    Element.column [ Element.spacing 5, Element.width Element.fill ]
        ([ viewRouteOneline rd ]
            |> listAppendIf meta.expanded (viewRouteExpanded rd meta.editRoute)
        )


viewRouteExpanded : RouteData -> Maybe RouteEditPane.Model -> Element Msg
viewRouteExpanded realRoute routeEditModel =
    case routeEditModel of
        Just editModel ->
            viewRouteExpandedEdit realRoute.id editModel

        Nothing ->
            viewRouteExpandedSolid realRoute


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
        [ Element.paragraph [ Element.Font.size 26 ]
            [ Element.text rd.name
            , Element.el [ Element.Font.color <| Element.rgba 0.5 0.5 0.5 0.5 ] (Element.text " - ")
            , Element.text rd.grade
            ]
        , Element.column [ Element.spacing 4, Element.Font.size 16 ]
            [ Element.text <| climbTypeToString rd.type_
            , Element.text <| "In " ++ rd.area
            , Element.text
                (case rd.tickDate2 of
                    Just tickdate ->
                        "☑ " ++ Date.toIsoString tickdate

                    Nothing ->
                        "📝 Not climbed"
                )
            ]
        , viewSolidNotes rd.notes
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


viewSolidNotes : String -> Element msg
viewSolidNotes text =
    if text /= "" then
        Element.paragraph
            [ Element.Border.solid
            , Element.Border.width 2
            , Element.Border.color (Element.rgb 0.5 0.5 0.5)
            , Element.padding 7
            ]
            (text
                |> String.lines
                |> List.map Element.text
                |> List.intersperse (Element.html (Html.br [] []))
            )

    else
        Element.none


viewRouteExpandedEdit : RouteId -> RouteEditPane.Model -> Element Msg
viewRouteExpandedEdit rid editModel =
    viewExistingOrNewRouteExpanded rid editModel


listAppendIf : Bool -> a -> List a -> List a
listAppendIf pred item list =
    if pred then
        list ++ [ item ]

    else
        list


viewRouteOneline : RouteData -> Element.Element Msg
viewRouteOneline rd =
    Element.Input.button
        [ Element.width Element.fill ]
        { onPress = Just <| ButtonPressed (ExpandRouteButton rd.id)
        , label =
            Element.wrappedRow
                [ Element.padding 12
                , Element.spacing 12
                , Element.Background.color (Element.rgb 0.8 0.8 0.8)
                , Element.width Element.fill
                ]
                [ minWidthText 25 rd.grade
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

minWidthText : Int -> String -> Element msg
minWidthText min text =
                Element.column [] [
                    Element.el [ Element.width Element.shrink ] (Element.text text)
                    , Element.el [Element.width (Element.px min)]  Element.none
                ]



viewExistingOrNewRouteExpanded : RouteId -> RouteEditPane.Model -> Element.Element Msg
viewExistingOrNewRouteExpanded routeId editModel =
    expandRouteColumn
        [ RouteEditPane.view editModel |> Element.map (RouteEditPaneMsg routeId)
        , Element.row [ Element.spacing 10 ]
            [ CommonView.buttonToSendEvent "Save" <| ButtonPressed <| SaveButton (commonToExistingRoute routeId editModel.route)
            , CommonView.buttonToSendEvent "Discard" <| ButtonPressed <| DiscardButton routeId
            , CommonView.buttonToSendEvent "Remove" <| ButtonPressed <| RemoveButton routeId
            ]
        ]
