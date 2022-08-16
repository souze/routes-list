module Backend exposing (..)

import BackendMsg
import Dict exposing (Dict)
import Lamdera exposing (ClientId, SessionId)
import List.Extra
import Process
import Route exposing (..)
import Task
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

        -- Clear out old sessions every day
        , Time.every (1000 * 60 * 60 * 24) BackendMsg.ClockTick
        ]


testingRoutes : List RouteData
testingRoutes =
    [ { name = "Centralpelaren"
      , grade = "6+"
      , tickDate2 = Nothing
      , notes = "Kul, bra säkringar :)"
      , id = RouteId 1
      , area = "Utby"
      , type_ = Trad
      , images = [ "https://filedn.com/looL0p0cbRa5gF0z3SS8rBb/route_list/50a6f7c22676c74e8908a0b44a723ebf.0.jpg" ]
      , videos = []
      }
    , { name = "Hokus pokus"
      , grade = "4+"
      , tickDate2 = Nothing
      , notes = "Kul, dåliga säkringar :( Lång lång text that might or might now wrap the wrong way, or the right way. To test text wrapping"
      , id = RouteId 2
      , area = "Utby"
      , type_ = Trad
      , images =
            [ "https://filedn.com/looL0p0cbRa5gF0z3SS8rBb/route_list/50a6f7c22676c74e8908a0b44a723ebf.0.jpg"
            , "https://filedn.com/looL0p0cbRa5gF0z3SS8rBb/route_list/50a6f7c22676c74e8908a0b44a723ebf.0.jpg"
            ]
      , videos =
            [ "https://filedn.com/looL0p0cbRa5gF0z3SS8rBb/route_list/20200408_175256.mp4"
            , "https://filedn.com/looL0p0cbRa5gF0z3SS8rBb/route_list/20200408_175256.mp4"
            ]
      }
    , { name = "Bokus Dokus"
      , grade = "3+"
      , tickDate2 = Nothing
      , notes = "Vilken fest"
      , id = RouteId 3
      , area = "Utby"
      , type_ = Trad
      , images = []
      , videos = [ "https://filedn.com/looL0p0cbRa5gF0z3SS8rBb/route_list/20200408_175256.mp4" ]
      }
    ]


initialUsers : Dict String UserData
initialUsers =
    Dict.fromList [ ( "erik", { password = "secret" } ), ( "none", { password = "boll" } ) ]


init : ( Model, Cmd BackendMsg )
init =
    ( { nextId = Route.firstId
      , currentTime = Time.millisToPosix 0
      , users = initialUsers
      , routes = testingRoutes
      , sessions = Dict.empty
      }
    , Time.now |> Task.perform BackendMsg.ClockTick
    )


withNoCommand : Model -> ( Model, Cmd BackendMsg )
withNoCommand model =
    ( model, Cmd.none )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        BackendMsg.NoOpBackendMsg ->
            ( model, Cmd.none )

        BackendMsg.ClockTick time ->
            ( { model
                | currentTime = time
                , sessions = model.sessions |> removeOldSessions time
              }
            , Cmd.none
            )

        BackendMsg.ClientDisconnected _ _ ->
            ( model
            , Cmd.none
            )

        BackendMsg.ClientConnected sessionId clientId ->
            ( { model | sessions = model.sessions |> touchSession model.currentTime sessionId }
            , if isLoggedIn sessionId model.sessions then
                Lamdera.sendToFrontend clientId <| AllRoutesAnnouncement model.routes

              else
                Lamdera.sendToFrontend clientId <|
                    ToFrontendYourNotLoggedIn
            )


removeOldSessions : Time.Posix -> Dict SessionId SessionData -> Dict SessionId SessionData
removeOldSessions time =
    Dict.filter (\_ { lastTouched } -> Time.posixToMillis lastTouched > (Time.posixToMillis time - 10000))


initialSessionData : SessionData
initialSessionData =
    { loggedIn = False
    , lastTouched = Time.millisToPosix 0
    }


isAdmin : SessionId -> Dict SessionId SessionData -> Bool
isAdmin sessionId sessions =
    False


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        ToBackendAdminMsg adminMsg ->
            if isAdmin sessionId model.sessions then
                updateFromAdmin adminMsg model

            else
                updateFromFrontendNotLoggedIn sessionId clientId msg model

        _ ->
            if isLoggedIn sessionId model.sessions then
                updateFromFrontendLoggedIn sessionId msg model

            else
                updateFromFrontendNotLoggedIn sessionId clientId msg model


updateFromAdmin : AdminMsg -> Model -> ( Model, Cmd BackendMsg )
updateFromAdmin msg model =
    model |> withNoCommand


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


touchSession : Time.Posix -> SessionId -> Dict SessionId SessionData -> Dict SessionId SessionData
touchSession time sessionId sessions =
    sessions
        |> Dict.update sessionId
            (\maybeSd ->
                maybeSd
                    |> Maybe.map (\sd -> { sd | lastTouched = time })
                    |> Maybe.withDefault { initialSessionData | lastTouched = time }
                    |> Just
            )


sha1 : String -> String
sha1 =
    identity


updateFromFrontendNotLoggedIn : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontendNotLoggedIn sessionId clientId msg model =
    case msg of
        ToBackendLogIn username password ->
            let
                userPasswordMatch : Bool
                userPasswordMatch =
                    model.users
                        |> Dict.get username
                        |> Maybe.map (.password >> (==) (sha1 password))
                        |> Maybe.withDefault False
            in
            if userPasswordMatch then
                ( { model
                    | sessions =
                        model.sessions
                            |> setLoggedIn sessionId
                            |> touchSession model.currentTime sessionId
                  }
                , Lamdera.sendToFrontend clientId <|
                    AllRoutesAnnouncement model.routes
                )

            else
                ( model, Lamdera.sendToFrontend clientId <| ToFrontendWrongUserNamePassword )

        _ ->
            ( model, Lamdera.sendToFrontend clientId <| ToFrontendYourNotLoggedIn )


updateFromFrontendLoggedIn : SessionId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontendLoggedIn sessionId msg model =
    case msg of
        ToBackendAdminMsg adminMsg ->
            -- This should never happen
            model |> withNoCommand

        ToBackendRefreshSession ->
            { model | sessions = model.sessions |> touchSession model.currentTime sessionId }
                |> withNoCommand

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
            -- I'm already logged in, announce the routes again
            ( model
            , Lamdera.broadcast <| AllRoutesAnnouncement model.routes
            )

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
