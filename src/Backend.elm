module Backend exposing (..)

import BackendMsg
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
    Lamdera.onConnect BackendMsg.ClientConnected


init : ( Model, Cmd BackendMsg )
init =
    ( { nextId = Route.firstId
      , routes =
            [ { name = "Centralpelaren"
              , grade = "6+"
              , tickDate = Just <| Time.millisToPosix 0
              , notes = "Kul, bra säkringar :)"
              , id = RouteId 1
              , area = "Utby"
              , type_ = Trad
              }
            , { name = "Hokus pokus"
              , grade = "4+"
              , tickDate = Just <| Time.millisToPosix 100000
              , notes = "Kul, dåliga säkringar :("
              , id = RouteId 2
              , area = "Utby"
              , type_ = Trad
              }
            , { name = "Bokus Dokus"
              , grade = "3+"
              , tickDate = Just <| Time.millisToPosix 1000000
              , notes = "Vilken fest"
              , id = RouteId 3
              , area = "Utby"
              , type_ = Trad
              }
            ]
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        BackendMsg.NoOpBackendMsg ->
            ( model, Cmd.none )

        BackendMsg.ClientConnected _ clientId ->
            ( model
            , Lamdera.sendToFrontend clientId <|
                AllRoutesAnnouncement model.routes
            )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
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

        NoOpToBackend ->
            ( model, Cmd.none )


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
