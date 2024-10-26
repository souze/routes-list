module Shared exposing (..)

import ClimbRoute exposing (..)
import Date exposing (Date)
import Element exposing (..)
import Element.Region as Region
import Json.Decode
import Route
import Task
import Time
import Url exposing (Url)
import Url.Builder
import View exposing (View)



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
    , Task.perform SetCurrentDate Date.today
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
update req msg model =
    case msg of
        Noop ->
            ( model
            , Cmd.none
            )

        MsgFromBackend (AllRoutesAnnouncement newRoutes) ->
            ( { model
                | routes = newRoutes
                , user = Just NormalUser
              }
            , case req.route of
                Route.SignIn__SignInDest_ { signInDest } ->
                    let
                        requestUrl =
                            req.url

                        signinRoute =
                            Route.fromUrl { requestUrl | path = String.replace "_" "/" signInDest }
                    in
                    Request.pushRoute signinRoute req

                _ ->
                    Cmd.none
            )

        MsgFromBackend YouAreAdmin ->
            ( { model | user = Just AdminUser }
            , Request.pushRoute Route.Admin__Home_ req
            )

        MsgFromBackend LogOut ->
            ( { model | user = Nothing }
            , Cmd.none
            )

        SetCurrentDate date ->
            ( { model | currentDate = date }
            , Cmd.none
            )


subscriptions : Route () -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none



-- VIEW


view :
    Request
    -> { page : View msg, toMsg : Msg -> msg }
    -> Model
    -> View msg
view req { page, toMsg } model =
    { title =
        page.title
    , body =
        column [ Region.mainContent, width fill ] [ page.body ]
    }
