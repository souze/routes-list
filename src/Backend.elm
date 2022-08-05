module Backend exposing (..)

import BackendMsg
import Dict exposing (Dict)
import Html
import Lamdera exposing (ClientId, SessionId)
import List.Extra
import Route exposing (..)
import Time
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    Sub.batch
        [ Lamdera.onConnect BackendMsg.ClientConnected
        , Lamdera.onDisconnect BackendMsg.ClientDisconnected
        ]


init : ( Model, Cmd BackendMsg )
init =
    ( { nextId = Route.firstId
      , routes =
            [ { name = "Centralpelaren"
              , grade = "6+"
              , tickDate2 = Nothing
              , notes = "Kul, bra säkringar :)"
              , id = RouteId 1
              , area = "Utby"
              , type_ = Trad
              }
            , { name = "Hokus pokus"
              , grade = "4+"
              , tickDate2 = Nothing
              , notes = "Kul, dåliga säkringar :("
              , id = RouteId 2
              , area = "Utby"
              , type_ = Trad
              }
            , { name = "Bokus Dokus"
              , grade = "3+"
              , tickDate2 = Nothing
              , notes = "Vilken fest"
              , id = RouteId 3
              , area = "Utby"
              , type_ = Trad
              }
            ]
      , sessions = Dict.empty
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        BackendMsg.NoOpBackendMsg ->
            ( model, Cmd.none )

        BackendMsg.ClientDisconnected sessionId clientId ->
            ( { model | sessions = model.sessions |> Dict.remove sessionId }
            , Cmd.none
            )

        BackendMsg.ClientConnected sessionId clientId ->
            ( { model | sessions = model.sessions |> Dict.insert sessionId initialSessionData }
            , Lamdera.sendToFrontend clientId <|
                ToFrontendYourNotLoggedIn
            )


initialSessionData : SessionData
initialSessionData =
    { loggedIn = False }


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    if isLoggedIn sessionId model.sessions then
        updateFromFrontendLoggedIn msg model

    else
        updateFromFrontendNotLoggedIn sessionId clientId msg model


isLoggedIn : SessionId -> Dict SessionId SessionData -> Bool
isLoggedIn sessionId sessions =
    Dict.get sessionId sessions
        |> Maybe.map .loggedIn
        |> Maybe.withDefault False


setLoggedIn : SessionId -> Dict SessionId SessionData -> Dict SessionId SessionData
setLoggedIn sessionId sessions =
    sessions
        |> Dict.update sessionId
            (\maybeSd ->
                maybeSd
                    |> Maybe.map (\sd -> { sd | loggedIn = True })
                    |> Maybe.withDefault { initialSessionData | loggedIn = True }
                    |> Just
            )


updateFromFrontendNotLoggedIn : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontendNotLoggedIn sessionId clientId msg model =
    case msg of
        ToBackendLogIn username password ->
            if username == "erik" && password == "secret" then
                ( { model | sessions = model.sessions |> setLoggedIn sessionId }
                , Lamdera.broadcast <|
                    AllRoutesAnnouncement model.routes
                )

            else
                ( model, Lamdera.sendToFrontend clientId <| ToFrontendWrongUserNamePassword )

        _ ->
            ( model, Lamdera.sendToFrontend clientId <| ToFrontendYourNotLoggedIn )


updateFromFrontendLoggedIn : ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontendLoggedIn msg model =
    case msg of
        ToBackendResetRouteList newRoutes ->
            let
                newModel =
                    model
                        |> (\m ->
                                { m | routes = [] }
                                    |> addNewRouteList newRoutes
                           )
            in
            ( newModel
            , Lamdera.broadcast <|
                AllRoutesAnnouncement newModel.routes
            )

        ToBackendCreateNewRoute route ->
            let
                newModel =
                    createNewRoute route model
            in
            ( newModel
            , Lamdera.broadcast <|
                AllRoutesAnnouncement newModel.routes
            )

        UpdateRoute route ->
            let
                newRoutes : List RouteData
                newRoutes =
                    model.routes
                        |> createOrUpdate route
            in
            ( { model | routes = newRoutes }
            , Lamdera.broadcast <|
                AllRoutesAnnouncement newRoutes
            )

        RemoveRoute id ->
            let
                newModel : Model
                newModel =
                    removeRoute id model
            in
            ( newModel
            , Lamdera.broadcast <|
                AllRoutesAnnouncement newModel.routes
            )

        ToBackendLogIn _ _ ->
            -- I'm already logged in
            ( model, Cmd.none )

        NoOpToBackend ->
            ( model, Cmd.none )


addNewRouteList : List NewRouteData -> Model -> Model
addNewRouteList newRoutes model =
    newRoutes
        |> List.foldl createNewRoute model


createNewRoute : NewRouteData -> Model -> Model
createNewRoute routeData model =
    { model
        | routes = commonToExistingRoute model.nextId routeData :: model.routes
        , nextId = incrementRouteId model.nextId
    }


incrementRouteId : RouteId -> RouteId
incrementRouteId (RouteId id) =
    RouteId (id + 1)


removeRoute : RouteId -> Model -> Model
removeRoute id model =
    { model | routes = model.routes |> List.filter (\r -> r.id /= id) }


createOrUpdate : RouteData -> List RouteData -> List RouteData
createOrUpdate newRoute routes =
    let
        shouldInsert : Bool
        shouldInsert =
            routes |> List.Extra.find (\r -> r.id == newRoute.id) |> Maybe.map (\_ -> False) |> Maybe.withDefault True
    in
    if shouldInsert then
        newRoute :: routes

    else
        routes
            |> List.map
                (\r ->
                    if r.id == newRoute.id then
                        newRoute

                    else
                        r
                )
