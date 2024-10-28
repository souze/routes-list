module Shared exposing (..)

import ClimbRoute exposing (..)
import Date exposing (Date)
import Dict exposing (Dict)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Region as Region
import Json.Decode
import Route exposing (Route)
import Route.Path
import Task
import Time
import TypedSvg.Types exposing (Display(..))
import Url exposing (Url)
import Url.Builder



-- INIT


type alias Flags =
    ()


type alias Model =
    { routes : List RouteData
    , user : Maybe User
    , currentDate : Date
    }


type User
    = NormalUser
    | AdminUser


decoder : Json.Decode.Decoder Flags
decoder =
    Debug.todo "decoder"


ecoderinitialRoutes : List RouteData
ecoderinitialRoutes =
    Debug.todo "initialRoutes"


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


init : Result Json.Decode.Error Flags -> Route () -> ( Model, Effect Msg )
init _ _ =
    ( { routes = initialRoutes
      , user = Nothing
      , currentDate = Date.fromCalendarDate 2022 Time.Aug 1
      }
    , Effect.sendCmd <| Task.perform SetCurrentDate Date.today
    )



-- UPDATE


type SharedFromBackend
    = AllRoutesAnnouncement (List RouteData)
    | LogOut
    | YouAreAdmin


type Msg
    = Noop
    | MsgFromBackend SharedFromBackend
    | SetCurrentDate Date


update : Route () -> Msg -> Model -> ( Model, Effect Msg )
update route msg model =
    case msg of
        Noop ->
            ( model
            , Effect.none
            )

        MsgFromBackend (AllRoutesAnnouncement newRoutes) ->
            ( { model
                | routes = newRoutes
                , user = Just NormalUser
              }
            , case route.path of
                Route.Path.SignIn_SignInDest_ { signInDest } ->
                    let
                        requestUrl =
                            route.url

                        signinRoute =
                            Route.fromUrl { requestUrl | path = String.replace "_" "/" signInDest }
                    in
                    Effect.pushRoute
                        { path = route.path
                        , hash = Nothing
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


subscriptions : Route () -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none
