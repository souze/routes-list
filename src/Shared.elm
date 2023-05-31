module Shared exposing (..)

import Date exposing (Date)
import Element exposing (..)
import Element.Region as Region
import Gen.Route
import Request exposing (Request)
import Route exposing (..)
import Task
import Time
import Url.Builder
import View exposing (View)
import Url exposing (Url)



-- INIT


type alias Flags =
    ()


type alias Model =
    { routes : List Route.RouteData
    , user : Maybe User
    , currentDate : Date
    }


type User
    = NormalUser
    | AdminUser


initialRoutes : List Route.RouteData
initialRoutes =
    [ { name = "Bokus Dokus"
      , grade = "3+"
      , tickDate2 = Nothing
      , notes = "Vilken fest"
      , id = Route.RouteId 3
      , area = "Utby"
      , type_ = Route.Trad
      , images = []
      , videos = [ "https://filedn.com/looL0p0cbRa5gF0z3SS8rBb/route_list/20200408_175256.mp4" ]
      }
    ]


init : Request -> Flags -> ( Model, Cmd Msg )
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


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
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
            ,
            case req.route of
                Gen.Route.SignIn__SignInDest_ { signInDest } ->
                    let
                        b = req.url
                        a = Gen.Route.fromUrl ({b | path = String.replace "_" "/" signInDest})
                    in
                    Request.pushRoute (a) req

                _ ->
                    Cmd.none
                    )

        MsgFromBackend YouAreAdmin ->
            ( { model | user = Just AdminUser }
            , Request.pushRoute Gen.Route.Admin__Home_ req
            )

        MsgFromBackend LogOut ->
            ( { model | user = Nothing }
            , Cmd.none
            )

        SetCurrentDate date ->
            ( { model | currentDate = date }
            , Cmd.none
            )


subscriptions : Request -> Model -> Sub Msg
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
