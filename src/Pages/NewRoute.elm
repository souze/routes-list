module Pages.NewRoute exposing (Model, Msg(..), page)

import Auth
import Bridge
import ClimbRoute exposing (CommonRouteData, NewRouteData, RouteData)
import CommonView
import Date exposing (Date)
import DatePicker
import Effect exposing (Effect)
import Element exposing (Element)
import Element.Background
import Element.Input
import Lamdera
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import RouteEditPane
import Shared
import View exposing (View)


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user shared route =
    Page.new
        { init = \_ -> init shared
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
        |> Page.withLayout (\_ -> Layouts.Header {})



-- INIT


type alias Model =
    { newRouteData : RouteEditPane.Model
    }


init : Shared.Model -> ( Model, Effect Msg )
init shared =
    ( { newRouteData = RouteEditPane.init shared.currentDate ClimbRoute.initialNewRouteData }
    , Effect.none
    )



-- UPDATE


type Msg
    = RouteEditMsg RouteEditPane.Msg
    | CreateRoute


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        RouteEditMsg rem ->
            ( { model | newRouteData = model.newRouteData |> RouteEditPane.update rem }
            , Effect.none
            )

        CreateRoute ->
            ( model
            , Effect.batch
                [ Effect.sendToBackend <| Bridge.ToBackendCreateNewRoute model.newRouteData.route
                , Effect.pushRoutePath (Route.Path.Routes_Filter_ { filter = "all" })

                -- Todo, maybe go to wishlist if the route is not climbed, and log if it is
                ]
            )



-- VIEW


view : Model -> View Msg
view model =
    { title = "Add new route"
    , body =
        CommonView.mainColumn
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
