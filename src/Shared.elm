module Shared exposing
    ( Flags, decoder
    , Model, Msg
    , init, update, subscriptions
    )

{-|

@docs Flags, decoder
@docs Model, Msg
@docs init, update, subscriptions

-}

import ClimbRoute exposing (RouteData)
import Date exposing (Date)
import Dict
import Effect exposing (Effect)
import Json.Decode
import Route exposing (Route)
import Route.Path
import Shared.Model exposing (..)
import Shared.Msg exposing (..)
import Task
import Time



-- FLAGS


type alias Flags =
    {}


decoder : Json.Decode.Decoder Flags
decoder =
    Json.Decode.succeed {}



-- INIT


type alias Model =
    Shared.Model.Model


init : Result Json.Decode.Error Flags -> Route () -> ( Model, Effect Msg )
init flagsResult route =
    ( { routes = initialRoutes
      , user = Nothing
      , currentDate = Date.fromCalendarDate 2022 Time.Aug 1
      }
    , Effect.sendCmd <| Task.perform Shared.Msg.SetCurrentDate Date.today
    )


initialRoutes =
    [ { name = "Bokus Dokus"
      , grade = "3+"
      , tickDate2 = Nothing
      , notes = "Vilken fest"
      , tags = []
      , id = ClimbRoute.RouteId 3
      , area = "Utby"
      , type_ = ClimbRoute.Trad
      , images = []
      , videos = [ "https://filedn.com/looL0p0cbRa5gF0z3SS8rBb/route_list/20200408_175256.mp4" ]
      }
    ]



-- UPDATE


type alias Msg =
    Shared.Msg.Msg


update : Route () -> Msg -> Model -> ( Model, Effect Msg )
update route msg model =
    case msg of
        Shared.Msg.NoOp ->
            ( model
            , Effect.none
            )

        Shared.Msg.MsgFromBackend (Shared.Msg.AllRoutesAnnouncement newRoutes) ->
            ( { model
                | routes = newRoutes
                , user = Just NormalUser
              }
            , case route.path of
                Route.Path.SignIn ->
                    let
                        dest =
                            route.query
                                |> Dict.get "from"
                                |> Maybe.andThen Route.Path.fromString
                                |> Maybe.withDefault Route.Path.Home_
                    in
                    Effect.pushRoute
                        { hash = Nothing
                        , path = dest
                        , query = Dict.empty
                        }

                _ ->
                    Effect.none
            )

        MsgFromBackend YouAreAdmin ->
            ( { model | user = Just AdminUser }
            , Effect.pushRoutePath Route.Path.Admin
            )

        MsgFromBackend LogOut ->
            ( { model | user = Nothing }
            , Effect.none
            )

        SetCurrentDate date ->
            ( { model | currentDate = date }
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Route () -> Model -> Sub Msg
subscriptions route model =
    Sub.none
