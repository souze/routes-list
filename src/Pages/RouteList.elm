module Pages.RouteList exposing (Model, Msg, page)

import Bridge
import Date exposing (Date)
import DatePicker
import Dict exposing (Dict)
import Effect
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font
import Element.Input
import Gen.Params.RouteList exposing (Params)
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
            { init = init shared
            , update = update req
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


type alias Model =
    { filter : ViewFilter
    , metadatas : Dict Int Metadata
    }


init : Shared.Model -> ( Model, Cmd Msg )
init shared =
    ( { filter = ViewAll
      , metadatas = Dict.empty
      }
    , Cmd.none
    )


toFrontendRowData : Dict Int Metadata -> List RouteData -> List RowData
toFrontendRowData metadatas routes =
    routes
        |> List.map
            (\route ->
                let
                    md : Metadata
                    md =
                        metadatas
                            |> Dict.get (getIntId route.id)
                            |> Maybe.withDefault initialMetadata
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
    | FieldUpdated RouteIdOrNew String String
    | DatePickerUpdate RouteIdOrNew DatePicker.ChangeEvent


update : Request.With params -> Msg -> Model -> ( Model, Cmd Msg )
update req msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )

        ButtonPressed id ->
            buttonPressed id req model

        FieldUpdated routeId fieldName newValue ->
            ( fieldUpdated routeId fieldName newValue model
            , Cmd.none
            )

        DatePickerUpdate routeIdOrNew updateEvent ->
            ( updateDatePicker routeIdOrNew updateEvent model
            , Cmd.none
            )


updateDatePicker : RouteIdOrNew -> DatePicker.ChangeEvent -> Model -> Model
updateDatePicker routeId changeEvent model =
    case routeId of
        NewRouteId ->
            model

        ExistingRoute id ->
            { model
                | metadatas =
                    model.metadatas
                        |> mapRouteIdMetadata id (updateDateTickerInRow changeEvent)
            }


mapRouteIdMetadata : RouteId -> (Metadata -> Metadata) -> Dict Int Metadata -> Dict Int Metadata
mapRouteIdMetadata (RouteId id) f metadatas =
    Dict.get id metadatas
        |> Maybe.withDefault initialMetadata
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


fieldUpdated : RouteIdOrNew -> String -> String -> Model -> Model
fieldUpdated routeId fieldName newValue model =
    case routeId of
        NewRouteId ->
            model

        ExistingRoute id ->
            { model
                | metadatas =
                    model.metadatas
                        |> mapRouteIdMetadataEditRoute id (updateEditRouteField fieldName newValue)
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
    | WishListButton
    | LogButton
    | AllButton
    | MoreOptionsButton
    | SaveButton RouteData
    | DiscardButton RouteId
    | RemoveButton RouteId
    | CreateButton


buttonPressed : ButtonId -> Request.With params -> Model -> ( Model, Cmd Msg )
buttonPressed id req model =
    case id of
        ExpandRouteButton routeId ->
            ( toggleExpansionRouteId routeId model
            , Cmd.none
            )

        EditRouteButton route ->
            ( enableEdit route model
            , Cmd.none
            )

        WishListButton ->
            ( { model | filter = ViewWishlist }
            , Cmd.none
            )

        LogButton ->
            ( { model | filter = ViewLog }
            , Cmd.none
            )

        AllButton ->
            ( { model | filter = ViewAll }
            , Cmd.none
            )

        MoreOptionsButton ->
            ( model
            , Request.pushRoute Gen.Route.MoreOptions req
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
    mainColumnWithToprow
        (shared.routes
            |> toFrontendRowData model.metadatas
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


mainColumn : List (Element Msg) -> Element Msg
mainColumn =
    Element.column [ Element.spacing 10, Element.padding 20, Element.width Element.fill ]


mainColumnWithToprow : List (Element Msg) -> Element Msg
mainColumnWithToprow items =
    mainColumn (viewTopRowButtons :: items)


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
            , label = actionButtonLabel "Edit"
            }
        ]


viewRouteExpandedEdit : RouteData -> DatePickerData -> Element Msg
viewRouteExpandedEdit rd datePickerData =
    viewExistingOrNewRouteExpanded (ExistingRoute rd.id) rd datePickerData


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


viewTopRowButtons : Element Msg
viewTopRowButtons =
    Element.row [ Element.spacing 10 ]
        [ buttonToSendEvent "Wishlist" (ButtonPressed WishListButton)
        , buttonToSendEvent "Log" (ButtonPressed LogButton)
        , buttonToSendEvent "All" (ButtonPressed AllButton)
        , buttonToSendEvent "..." (ButtonPressed MoreOptionsButton)
        ]


buttonToSendEvent : String -> Msg -> Element Msg
buttonToSendEvent labelText event =
    Element.Input.button []
        { onPress = Just event
        , label = actionButtonLabel labelText
        }


actionButtonLabel : String -> Element msg
actionButtonLabel text =
    Element.el [ Element.Background.color (Element.rgb 0.6 0.6 0.6), Element.padding 8 ] (Element.text text)


viewExistingOrNewRouteExpanded : RouteIdOrNew -> CommonRouteData a -> DatePickerData -> Element.Element Msg
viewExistingOrNewRouteExpanded maybeId rd datePickerData =
    let
        onelineEdit : String -> String -> String -> Element.Element Msg
        onelineEdit name prettyName value =
            Element.Input.text []
                { onChange = FieldUpdated maybeId name
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
            { onChange = DatePickerUpdate maybeId
            , selected = rd.tickDate2
            , text = datePickerData.dateText
            , label = Element.Input.labelLeft [] <| Element.text "Tickdate"
            , placeholder = Just <| Element.Input.placeholder [] <| Element.text "yyyy-MM-dd"
            , settings = DatePicker.defaultSettings
            , model = datePickerData.pickerModel
            }
        , Element.Input.multiline [ Element.width Element.fill ]
            { onChange = FieldUpdated maybeId "notes"
            , text = rd.notes
            , placeholder = Nothing
            , label = Element.Input.labelAbove [] (Element.text "Notes")
            , spellcheck = True
            }
        , Element.row [ Element.spacing 10 ]
            (case maybeId of
                ExistingRoute routeId ->
                    [ buttonToSendEvent "Save" <| ButtonPressed <| SaveButton (commonToExistingRoute routeId rd)
                    , buttonToSendEvent "Discard" <| ButtonPressed <| DiscardButton routeId
                    , buttonToSendEvent "Remove" <| ButtonPressed <| RemoveButton routeId

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

                NewRouteId ->
                    [ Element.Input.button []
                        { onPress = Just <| ButtonPressed CreateButton
                        , label = actionButtonLabel "Create"
                        }
                    ]
            )
        ]
