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
import Gen.Params.Routes.Filter_ exposing (Params)
import Gen.Route
import Html
import Html.Attributes
import Lamdera
import Maybe.Extra
import Page
import Request
import Route exposing (..)
import Shared
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


type ViewFilter
    = ViewAll
    | ViewLog
    | ViewWishlist


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
    { filter : ViewFilter
    , metadatas : Dict Int Metadata
    }


init : Request.With Params -> Shared.Model -> ( Model, Cmd Msg )
init req shared =
    let
        filter : Maybe ViewFilter
        filter =
            case req.params.filter of
                "all" ->
                    Just ViewAll

                "wishlist" ->
                    Just ViewWishlist

                "log" ->
                    Just ViewLog

                _ ->
                    Nothing
    in
    case filter of
        Just filter_ ->
            ( { filter = filter_
              , metadatas = Dict.empty
              }
            , Cmd.none
            )

        Nothing ->
            ( { filter = ViewAll
              , metadatas = Dict.empty
              }
            , Request.pushRoute (Gen.Route.Routes__Filter_ { filter = "all" }) req
            )


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


defaultDatePickerData : DatePickerData
defaultDatePickerData =
    { dateText = ""
    , pickerModel = DatePicker.init
    }



-- UPDATE


type Msg
    = ReplaceMe
    | ButtonPressed ButtonId
    | FieldUpdated RouteId String String
    | DatePickerUpdate RouteId DatePicker.ChangeEvent


update : Shared.Model -> Request.With params -> Msg -> Model -> ( Model, Cmd Msg )
update shared req msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )

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
    CommonView.mainColumnWithToprow
        (shared.routes
            |> toFrontendRowData shared.currentDate model.metadatas
            |> filterAndSortView model.filter
            |> List.map viewRoute
        )


filterAndSortView : ViewFilter -> List RowData -> List RowData
filterAndSortView viewFilter rows =
    let
        ( filter, sorter ) =
            filterAndSorter viewFilter
    in
    rows
        |> List.filter filter
        |> sorter


filterAndSorter : ViewFilter -> ( RowData -> Bool, List RowData -> List RowData )
filterAndSorter viewFilter =
    case viewFilter of
        ViewLog ->
            ( \rd -> rd.route.realRoute.tickDate2 |> Maybe.Extra.isJust
            , logViewSorter
            )

        ViewWishlist ->
            ( \rd -> rd.route.realRoute.tickDate2 |> Maybe.Extra.isNothing
            , identity
            )

        ViewAll ->
            ( \_ -> True
            , identity
            )


logViewSorter : List RowData -> List RowData
logViewSorter rows =
    let
        sorter : RowData -> RowData -> Order
        sorter rd1 rd2 =
            case ( rd1.route.realRoute.tickDate2, rd2.route.realRoute.tickDate2 ) of
                ( Just a, Just b ) ->
                    Date.compare a b

                ( Just _, Nothing ) ->
                    LT

                ( Nothing, Just _ ) ->
                    GT

                _ ->
                    LT
    in
    rows
        |> List.sortWith sorter
        |> List.reverse


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
