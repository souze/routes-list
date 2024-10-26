module Pages.NewRoute exposing (Model, Msg(..), page)

import Bridge
import CommonView
import Date exposing (Date)
import DatePicker
import Element exposing (Element)
import Element.Background
import Element.Input
import Gen.Params.NewRoute exposing (Params)
import Gen.Route
import Lamdera
import Page
import Request exposing (Request)
import Route exposing (CommonRouteData, NewRouteData, RouteData)
import RouteEditPane
import Shared
import View exposing (View)


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user shared route =
    Page.new
        { init = init shared
        , update = update ()
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- INIT


type alias Model =
    { newRouteData : RouteEditPane.Model
    }


init : Shared.Model -> ( Model, Cmd Msg )
init shared =
    ( { newRouteData = RouteEditPane.init shared.currentDate Route.initialNewRouteData
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = RouteEditMsg RouteEditPane.Msg
    | CreateRoute


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update req msg model =
    case msg of
        RouteEditMsg rem ->
            ( { model | newRouteData = model.newRouteData |> RouteEditPane.update rem }
            , Cmd.none
            )

        CreateRoute ->
            ( model
            , Cmd.batch
                [ Lamdera.sendToBackend <| Bridge.ToBackendCreateNewRoute model.newRouteData.route
                , Request.pushRoute (Gen.Route.Routes__Filter_ { filter = "all" }) req

                -- Todo, maybe go to wishlist if the route is not climbed, and log if it is
                ]
            )



-- VIEW


view : Model -> View Msg
view model =
    { title = "Add new route"
    , body =
        CommonView.mainColumnWithToprow
            [ RouteEditPane.view model.newRouteData
                |> Element.map RouteEditMsg
            , createRouteButton
            ]
    }


createRouteButton : Element Msg
createRouteButton =
    Element.row [ Element.spacing 10 ]
        [ Element.Input.button []
            { onPress = Just <| CreateRoute
            , label = CommonView.actionButtonLabel "Create"
            }
        ]
