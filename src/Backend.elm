module Backend exposing (..)

import BackendMsg
import BackupModel
import Bridge exposing (..)
import Dict exposing (Dict)
import Element.Input exposing (username)
import Element.Region exposing (announce)
import Env
import Lamdera exposing (ClientId, SessionId)
import List.Extra
import Maybe.Extra
import Process
import Route exposing (..)
import SHA1
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
            , "https://filedn.com/looL0p0cbRa5gF0z3SS8rBb/route_list/20220625_140816.jpg"
            ]
      , videos =
            []
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
    Dict.fromList
        [ ( "erik"
          , { username = "erik"
            , password = sha1 "secret"
            , routes = testingRoutes
            , nextId = RouteId 4
            }
          )
        , ( "none"
          , { username = "none"
            , password = sha1 "boll"
            , routes = List.take 2 testingRoutes
            , nextId = RouteId 3
            }
          )
        ]


init : ( Model, Cmd BackendMsg )
init =
    ( { currentTime = Time.millisToPosix 0
      , users = initialUsers
      , sessions = Dict.empty
      }
    , Time.now |> Task.perform BackendMsg.ClockTick
    )


withNoCommand : a -> ( a, Cmd BackendMsg )
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
            , case getUserData sessionId model.sessions model.users of
                Just userData ->
                    Lamdera.sendToFrontend clientId <| AllRoutesAnnouncement userData.routes

                Nothing ->
                    Lamdera.sendToFrontend clientId <|
                        ToFrontendYourNotLoggedIn
            )


removeOldSessions : Time.Posix -> Dict SessionId SessionData -> Dict SessionId SessionData
removeOldSessions time =
    Dict.filter (\_ { lastTouched } -> Time.posixToMillis lastTouched > (Time.posixToMillis time - 10000))


admins : List ( String, String )
admins =
    [ ( Env.adminUsername
      , Env.adminPassword
      )
    ]


isAdmin : SessionId -> Dict SessionId SessionData -> Bool
isAdmin sessionId sessions =
    sessions
        |> Dict.get sessionId
        |> Maybe.map .username
        |> Maybe.map (\username -> List.member username (admins |> List.unzip |> Tuple.first))
        |> Maybe.withDefault False


updateFromFrontend : SessionId -> ClientId -> Bridge.ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        ToBackendAdminMsg adminMsg ->
            if isAdmin sessionId model.sessions then
                updateFromAdmin clientId adminMsg model

            else
                updateFromFrontendNotLoggedIn sessionId clientId msg model

        _ ->
            case getUserData sessionId model.sessions model.users of
                Just userData ->
                    case msg of
                        ToBackendRefreshSession ->
                            { model | sessions = model.sessions |> touchSession model.currentTime sessionId }
                                |> withNoCommand

                        ToBackendLogOut ->
                            ( { model | sessions = model.sessions |> Dict.remove sessionId }
                            , Lamdera.sendToFrontend clientId <| ToFrontendYourNotLoggedIn
                            )

                        _ ->
                            let
                                ( newUsers, maybeCommand ) =
                                    updateUserData userData.username (updateFromFrontendLoggedIn sessionId clientId msg) model.users
                            in
                            ( { model | users = newUsers }
                            , maybeCommand |> Maybe.withDefault Cmd.none
                            )

                Nothing ->
                    updateFromFrontendNotLoggedIn sessionId clientId msg model


updateUserData :
    comparable
    -> (value -> ( value, extra ))
    -> Dict comparable value
    -> ( Dict comparable value, Maybe extra )
updateUserData key fn input =
    input
        |> Dict.get key
        -- Maybe value
        |> Maybe.map fn
        -- Maybe (value, extra)
        |> Maybe.map (Tuple.mapFirst (\newB -> input |> Dict.insert key newB) >> Tuple.mapSecond Just)
        -- Maybe (Dict key value, Maybe extra)
        |> Maybe.withDefault ( input, Nothing )


getUserData : SessionId -> Dict SessionId SessionData -> Dict String UserData -> Maybe UserData
getUserData sessionId sessions users =
    sessions
        |> Dict.get sessionId
        |> Maybe.map .username
        |> Maybe.map (\u -> Dict.get u users)
        |> Maybe.Extra.join


updateFromAdmin : ClientId -> AdminMsg -> Model -> ( Model, Cmd BackendMsg )
updateFromAdmin clientId msg model =
    (case msg of
        AddUser { username, password } ->
            { model | users = model.users |> newUser username password }

        RemoveUser username ->
            { model | users = model.users |> Dict.remove username }

        RequestModel ->
            model

        AdminMsgChangePassword { username, password } ->
            { model | users = model.users |> changePassword username password }
    )
        |> updateAndSendWholeModel clientId


updateAndSendWholeModel : ClientId -> Model -> ( Model, Cmd BackendMsg )
updateAndSendWholeModel clientId model =
    ( model
    , Lamdera.sendToFrontend clientId <| ToFrontendAdminWholeModel (getBackupModel model)
    )


changePassword : String -> Password -> Dict String UserData -> Dict String UserData
changePassword username password users =
    users
        |> Dict.update username
            (Maybe.map (\user -> { user | password = sha1 password }))


newUser : String -> Password -> Dict String UserData -> Dict String UserData
newUser username password users =
    if Dict.member username users then
        -- Don't overwrite
        users

    else
        users
            |> Dict.insert
                username
                { username =
                    username
                , password = sha1 password
                , routes = []
                , nextId = RouteId 0
                }


getBackupModel : Model -> BackupModel.BackupModel
getBackupModel model =
    model.users
        |> Dict.toList
        |> List.unzip
        |> Tuple.second
        |> List.map (\ud -> { username = ud.username, routes = ud.routes })


touchSession : Time.Posix -> SessionId -> Dict SessionId SessionData -> Dict SessionId SessionData
touchSession time sessionId sessions =
    sessions
        |> Dict.update sessionId
            (\maybeSd ->
                maybeSd
                    |> Maybe.map (\sd -> { sd | lastTouched = time })
            )


sha1 : String -> String
sha1 =
    SHA1.fromString >> SHA1.toBase64


updateFromFrontendNotLoggedIn : SessionId -> ClientId -> Bridge.ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontendNotLoggedIn sessionId clientId msg model =
    case msg of
        ToBackendLogIn username password ->
            if List.member username (admins |> List.unzip |> Tuple.first) then
                loginAdmin username password sessionId clientId model

            else
                loginMember username password sessionId clientId model

        _ ->
            ( model, Lamdera.sendToFrontend clientId <| ToFrontendYourNotLoggedIn )


loginAdmin : String -> String -> SessionId -> ClientId -> Model -> ( Model, Cmd BackendMsg )
loginAdmin username password sessionId clientId model =
    if List.member ( username, password ) admins then
        ( { model
            | sessions =
                model.sessions
                    |> Dict.insert sessionId
                        { username = username
                        , lastTouched = model.currentTime
                        }
          }
        , Lamdera.sendToFrontend clientId <| ToFrontendYouAreAdmin
        )

    else
        ( model, Lamdera.sendToFrontend clientId <| ToFrontendYourNotLoggedIn )


loginMember : String -> String -> SessionId -> ClientId -> Model -> ( Model, Cmd BackendMsg )
loginMember username password sessionId clientId model =
    let
        matchingUserData : Maybe UserData
        matchingUserData =
            model.users
                |> Dict.get username
                |> Maybe.Extra.filter (.password >> (==) (sha1 password))
    in
    case matchingUserData of
        Just userData ->
            ( { model
                | sessions =
                    model.sessions |> Dict.insert sessionId { username = username, lastTouched = model.currentTime }
              }
            , Lamdera.sendToFrontend clientId <|
                AllRoutesAnnouncement userData.routes
            )

        Nothing ->
            ( model, Lamdera.sendToFrontend clientId <| ToFrontendWrongUserNamePassword )


updateFromFrontendLoggedIn : SessionId -> ClientId -> Bridge.ToBackend -> UserData -> ( UserData, Cmd BackendMsg )
updateFromFrontendLoggedIn sessionId clientId msg userData =
    let
        announceRoutes : List RouteData -> Cmd BackendMsg
        announceRoutes routes =
            Lamdera.sendToFrontend clientId <| AllRoutesAnnouncement routes
    in
    case msg of
        ToBackendAdminMsg adminMsg ->
            -- This should never happen
            userData |> withNoCommand

        ToBackendRefreshSession ->
            -- Already handled before, will never happen
            userData |> withNoCommand

        ToBackendUserChangePass { oldPassword, newPassword } ->
            if sha1 oldPassword == userData.password then
                ( { userData | password = sha1 newPassword }
                , Lamdera.sendToFrontend clientId <| ToFrontendUserNewPasswordAccepted
                )

            else
                ( userData
                , Lamdera.sendToFrontend clientId <| ToFrontendUserNewPasswordRejected
                )

        ToBackendResetRouteList newRoutes ->
            let
                newUserData : UserData
                newUserData =
                    { userData | routes = [] }
                        |> addNewRouteList newRoutes
            in
            ( newUserData
            , announceRoutes newUserData.routes
            )

        ToBackendCreateNewRoute route ->
            let
                newUserData =
                    createNewRoute route userData
            in
            ( newUserData
            , announceRoutes newUserData.routes
            )

        UpdateRoute route ->
            let
                newRoutes : List RouteData
                newRoutes =
                    userData.routes
                        |> createOrUpdate route
            in
            ( { userData | routes = newRoutes }
            , announceRoutes newRoutes
            )

        RemoveRoute id ->
            let
                newUserData : UserData
                newUserData =
                    removeRoute id userData
            in
            ( newUserData
            , announceRoutes newUserData.routes
            )

        ToBackendLogIn _ _ ->
            -- I'm already logged in, announce the routes again
            ( userData
            , announceRoutes userData.routes
            )

        ToBackendLogOut ->
            -- This should have been handled earlier
            ( userData
            , Cmd.none
            )

        NoOpToBackend ->
            ( userData, Cmd.none )


addNewRouteList : List NewRouteData -> UserData -> UserData
addNewRouteList newRoutes userData =
    newRoutes
        |> List.foldl createNewRoute userData


createNewRoute : NewRouteData -> UserData -> UserData
createNewRoute routeData userData =
    { userData
        | routes = commonToExistingRoute userData.nextId routeData :: userData.routes
        , nextId = incrementRouteId userData.nextId
    }


incrementRouteId : RouteId -> RouteId
incrementRouteId (RouteId id) =
    RouteId (id + 1)


removeRoute : RouteId -> UserData -> UserData
removeRoute id userData =
    { userData | routes = userData.routes |> List.filter (\r -> r.id /= id) }


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
