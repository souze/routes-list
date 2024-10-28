module Pages.MoreOptions exposing (Model, Msg(..), page)

import Auth
import Bridge
import CommonView
import Effect exposing (Effect)
import Element exposing (Element)
import Lamdera
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user model route =
    Page.new
        { init = \_ -> init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- INIT


type alias Model =
    {}


init : ( Model, Effect Msg )
init =
    ( {}, Effect.none )



-- UPDATE


type Msg
    = Logout


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        Logout ->
            ( model
            , Effect.sendToBackend Bridge.ToBackendLogOut
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view _ =
    { title = "More Options"
    , body = viewBody
    }


viewBody : Element Msg
viewBody =
    CommonView.mainColumnWithToprow
        [ CommonView.linkToRoute "New Route" Route.Path.NewRoute
        , CommonView.linkToRoute "Stats" Route.Path.Stats
        , CommonView.linkToRoute "Input Json" Route.Path.InputJson
        , CommonView.linkToRoute "View as Json" Route.Path.OutputJson
        , CommonView.linkToRoute "Change password" Route.Path.ChangePassword
        , CommonView.buttonToSendEvent "Log out" Logout
        ]
