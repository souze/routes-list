module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import DateFormat
import Element
import Element.Background
import Element.Font
import Element.Input
import Lamdera
import List.Extra
import Random
import Route exposing (..)
import Time
import ToBackendMsg
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \_ -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , message = "Welcome to Lamdera! You're looking at the auto-generated base implementation. Check out src/Frontend.elm to start coding!"
      , newRouteData =
            Just
                { name = "hux"
                , grade = "3"
                , tickDate = Just <| Time.millisToPosix 0
                , notes = "Lajbans"
                , area = "Utby"
                , type_ = Trad
                }
      , rows =
            [ { expanded = True
              , route =
                    RouteDataEdit
                        { name = "Centralpelaren"
                        , grade = "6+"
                        , tickDate = Just <| Time.millisToPosix 0
                        , notes = "Kul, bra säkringar :)"
                        , id = RouteId 14
                        , area = "Utby"
                        , type_ = Trad
                        }
                        Nothing
              }
            , { expanded = False
              , route =
                    RouteDataEdit
                        { name = "Hokus pokus"
                        , grade = "4+"
                        , tickDate = Just <| Time.millisToPosix 100000
                        , notes = "Kul, dåliga säkringar :("
                        , id = RouteId 13
                        , area = "Utby"
                        , type_ = Trad
                        }
                        Nothing
              }
            , { expanded = True
              , route =
                    RouteDataEdit
                        { name = "Bokus Dokus"
                        , grade = "3+"
                        , tickDate = Just <| Time.millisToPosix 1000000
                        , notes = "Vilken fest"
                        , area = "Utby"
                        , type_ = Trad
                        , id = RouteId 11
                        }
                        (Just
                            { name = "Bokus Dokus"
                            , grade = "3+"
                            , tickDate = Just <| Time.millisToPosix 1000000
                            , notes = "Vilken fest"
                            , area = "Utby"
                            , type_ = Trad
                            , id = RouteId 12
                            }
                        )
              }
            ]
      }
    , Cmd.none
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        CreateNewRoute ->
            createNewRoute model

        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )

        NewRouteButtonPressed ->
            ( newRouteButtonPressed model, Cmd.none )

        RouteButtonClicked id ->
            ( toggleExpansionRouteId id model, Cmd.none )

        EditRouteEnable id ->
            ( enableEdit id model, Cmd.none )

        EditRouteSave route ->
            ( model
            , Lamdera.sendToBackend <|
                UpdateRoute route
            )

        EditRouteDiscardChanges id ->
            ( discardChanges id model, Cmd.none )

        EditRouteRemove id ->
            ( discardChanges id model
            , Lamdera.sendToBackend <|
                RemoveRoute id
            )

        EditRouteUpdated id getter newValue ->
            ( routeUpdated id getter newValue model, Cmd.none )


createNewRoute : Model -> ( Model, Cmd msg )
createNewRoute model =
    case model.newRouteData of
        Just newRouteData ->
            -- No validation
            ( { model | newRouteData = Nothing }
            , Lamdera.sendToBackend <|
                ToBackendCreateNewRoute newRouteData
            )

        Nothing ->
            -- That's strange. How did we press the save button when the view wasn't expanded?
            ( model, Cmd.none )


newRouteButtonPressed : Model -> Model
newRouteButtonPressed model =
    case model.newRouteData of
        Just newRouteData ->
            { model | newRouteData = Nothing }

        Nothing ->
            { model | newRouteData = Just initialNewRoute }


initialNewRoute : NewRouteData
initialNewRoute =
    { name = ""
    , grade = ""
    , tickDate = Just <| Time.millisToPosix 0
    , area = ""
    , type_ = Trad
    , notes = ""
    }


discardChanges : RouteId -> Model -> Model
discardChanges id m =
    { m
        | rows =
            mapRowWithRouteId id
                (\rowData ->
                    { rowData
                        | route =
                            { realRoute = rowData.route.realRoute
                            , editRoute = Nothing
                            }
                    }
                )
                m.rows
    }


mapRowWithRouteId : RouteId -> (RowData -> RowData) -> List RowData -> List RowData
mapRowWithRouteId id f rows =
    rows
        |> List.map
            (\row ->
                if row.route.realRoute.id == id then
                    f row

                else
                    row
            )


routeUpdated : RouteIdOrNew -> String -> String -> Model -> Model
routeUpdated routeIdOrNew fieldName newValue m =
    case ( routeIdOrNew, m.newRouteData ) of
        ( ExistingRoute id, _ ) ->
            { m | rows = updateEditRoute id (updateEditRouteField fieldName newValue) m.rows }

        ( NewRouteId, Just nrd ) ->
            { m | newRouteData = Just <| updateEditRouteField fieldName newValue nrd }

        ( NewRouteId, Nothing ) ->
            m


updateEditRouteField : String -> String -> CommonRouteData a -> CommonRouteData a
updateEditRouteField fieldName newValue rd =
    case fieldName of
        "name" ->
            { rd | name = newValue }

        "grade" ->
            { rd | grade = newValue }

        "notes" ->
            { rd | notes = newValue }

        _ ->
            rd


updateEditRoute : RouteId -> (RouteData -> RouteData) -> List RowData -> List RowData
updateEditRoute id f =
    mapRowWithRouteId id
        (\row ->
            { row
                | route =
                    setEditRoute
                        (Maybe.map f row.route.editRoute)
                        row.route
            }
        )


setEditRoute : Maybe RouteData -> RouteDataEdit -> RouteDataEdit
setEditRoute rd rde =
    { rde | editRoute = rd }


enableEdit : RouteId -> Model -> Model
enableEdit id m =
    { m
        | rows =
            m.rows
                |> List.map
                    (\rd ->
                        case rd.route.editRoute of
                            Nothing ->
                                if rd.route.realRoute.id == id then
                                    { rd | route = { realRoute = rd.route.realRoute, editRoute = Just rd.route.realRoute } }

                                else
                                    rd

                            _ ->
                                rd
                    )
    }


toggleExpansionRouteId : RouteId -> Model -> Model
toggleExpansionRouteId id m =
    { m
        | rows =
            m.rows
                |> List.map
                    (\rd ->
                        if rd.route.realRoute.id == id then
                            { rd | expanded = not rd.expanded }

                        else
                            rd
                    )
    }


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )

        AllRoutesAnnouncement routes ->
            ( setRoutesReceivedFromBackend routes model, Cmd.none )


setRoutesReceivedFromBackend : List RouteData -> Model -> Model
setRoutesReceivedFromBackend routes model =
    { model | rows = toFrontendRowData routes }


toFrontendRowData : List RouteData -> List RowData
toFrontendRowData routes =
    routes
        |> List.map
            (\route ->
                { expanded = False
                , route =
                    { realRoute = route
                    , editRoute = Nothing
                    }
                }
            )


view : Model -> Browser.Document FrontendMsg
view model =
    { title = ""
    , body =
        [ Element.layout [] (viewCols model)
        ]
    }


viewCols : Model -> Element.Element FrontendMsg
viewCols model =
    Element.column [ Element.spacing 10, Element.padding 20 ] <|
        List.concat
            [ [ viewAddRouteButton ]
            , case model.newRouteData of
                Just newRouteData ->
                    [ viewNewRoute newRouteData ]

                Nothing ->
                    []
            , List.map viewRoute model.rows
            ]


viewNewRoute : NewRouteData -> Element.Element FrontendMsg
viewNewRoute newRouteData =
    viewExistingOrNewRouteExpanded NewRouteId newRouteData


viewAddRouteButton : Element.Element FrontendMsg
viewAddRouteButton =
    Element.Input.button []
        { onPress = Just <| NewRouteButtonPressed
        , label = Element.el [ Element.Background.color (Element.rgb 0.6 0.6 0.6), Element.padding 8 ] (Element.text "New Route")
        }


tickDateFormatter : Time.Zone -> Time.Posix -> String
tickDateFormatter =
    DateFormat.format
        [ DateFormat.yearNumber
        , DateFormat.text "-"
        , DateFormat.monthFixed
        , DateFormat.text "-"
        , DateFormat.dayOfMonthFixed
        ]


viewRoute : RowData -> Element.Element FrontendMsg
viewRoute rd =
    Element.column [ Element.spacing 5 ]
        ([ viewRouteOneline rd.route ]
            |> listAppendIf rd.expanded (viewRouteExpanded rd.route)
        )


listAppendIf : Bool -> a -> List a -> List a
listAppendIf pred item list =
    if pred then
        list ++ [ item ]

    else
        list


viewRouteExpanded : RouteDataEdit -> Element.Element FrontendMsg
viewRouteExpanded routeDataEdit =
    case routeDataEdit.editRoute of
        Just editRoute ->
            viewRouteExpandedEdit editRoute

        Nothing ->
            viewRouteExpandedSolid routeDataEdit.realRoute


expandRouteColumn : List (Element.Element msg) -> Element.Element msg
expandRouteColumn =
    Element.column
        [ Element.padding 12
        , Element.spacing 20
        , Element.Background.color (Element.rgb 0.75 0.8 0.8)
        ]


viewRouteExpandedSolid : RouteData -> Element.Element FrontendMsg
viewRouteExpandedSolid rd =
    expandRouteColumn
        [ Element.el [ Element.Font.size 20 ] <| Element.text rd.name
        , Element.text <| "Area: " ++ rd.area
        , Element.text <| "Grade: " ++ rd.grade
        , Element.text <| "Type: " ++ climbTypeToString rd.type_
        , case rd.tickDate of
            Just tickdate ->
                Element.text <| "Tickdate: " ++ tickDateFormatter Time.utc tickdate

            Nothing ->
                Element.text <| "Not climbed"
        , Element.text <| "Notes:\n---\n" ++ rd.notes
        , Element.Input.button []
            { onPress = Just <| EditRouteEnable rd.id
            , label = actionButtonLabel "Edit"
            }
        ]


climbTypeToString : ClimbType -> String
climbTypeToString ct =
    case ct of
        Trad ->
            "Trad"

        Sport ->
            "Sport"

        Mix ->
            "Mix"

        Boulder ->
            "Boulder"


viewRouteExpandedEdit : RouteData -> Element.Element FrontendMsg
viewRouteExpandedEdit rd =
    viewExistingOrNewRouteExpanded (ExistingRoute rd.id) rd


actionButtonLabel : String -> Element.Element msg
actionButtonLabel text =
    Element.el [ Element.Background.color (Element.rgb 0.6 0.6 0.6), Element.padding 8 ] (Element.text text)


viewExistingOrNewRouteExpanded : RouteIdOrNew -> CommonRouteData a -> Element.Element FrontendMsg
viewExistingOrNewRouteExpanded maybeId rd =
    let
        onelineEdit : String -> String -> String -> Element.Element FrontendMsg
        onelineEdit name prettyName value =
            Element.Input.text []
                { onChange = EditRouteUpdated maybeId name
                , text = value
                , placeholder = Nothing
                , label = Element.Input.labelLeft [] (Element.text prettyName)
                }
    in
    expandRouteColumn
        [ onelineEdit "name" "Name" rd.name
        , onelineEdit "area" "Area" rd.area
        , onelineEdit "grade" "Grade" rd.grade

        -- , Element.text (tickDateFormatter Time.utc rd.tickDate)
        , Element.Input.multiline []
            { onChange = EditRouteUpdated maybeId "notes"
            , text = rd.notes
            , placeholder = Nothing
            , label = Element.Input.labelLeft [] (Element.text "Notes")
            , spellcheck = True
            }
        , Element.row [ Element.spacing 10 ]
            (case maybeId of
                ExistingRoute routeId ->
                    [ Element.Input.button []
                        { onPress = Just <| EditRouteSave (commonToExistingRoute routeId rd)
                        , label = actionButtonLabel "Save"
                        }
                    , Element.Input.button []
                        { onPress = Just <| EditRouteDiscardChanges routeId
                        , label = actionButtonLabel "Discard"
                        }
                    , Element.Input.button []
                        { onPress = Just <| EditRouteRemove routeId
                        , label = actionButtonLabel "Remove"
                        }
                    ]

                NewRouteId ->
                    [ Element.Input.button []
                        { onPress = Just <| CreateNewRoute
                        , label = actionButtonLabel "Create"
                        }
                    ]
            )
        ]


viewRouteOneline : RouteDataEdit -> Element.Element FrontendMsg
viewRouteOneline { realRoute, editRoute } =
    let
        rd =
            realRoute
    in
    Element.Input.button
        []
        { onPress = Just <| RouteButtonClicked rd.id
        , label =
            Element.row
                [ Element.padding 12
                , Element.spacing 20
                , Element.Background.color (Element.rgb 0.8 0.8 0.8)
                ]
                [ Element.el [ Element.width (Element.px 300) ] <| Element.text rd.name
                , Element.text rd.grade
                , Element.text
                    (case rd.tickDate of
                        Just tickDate ->
                            tickDateFormatter Time.utc tickDate

                        Nothing ->
                            "Not climbed"
                    )
                ]
        }
