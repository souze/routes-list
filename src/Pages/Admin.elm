module Pages.Admin exposing (Model, Msg(..), page)

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
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    {}


init : ( Model, Effect Msg )
init =
    ( {}, Effect.none )



-- UPDATE


type Msg
    = LogOut


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        LogOut ->
            ( model
            , Effect.sendToBackend Bridge.ToBackendLogOut
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Admin home"
    , body = viewBody
    }


viewBody : Element Msg
viewBody =
    CommonView.adminPageWithItems
        [ CommonView.linkToRoute "Show Json" Route.Path.Admin_ShowJson
        , CommonView.linkToRoute "Add user" Route.Path.Admin_AddUser
        , CommonView.linkToRoute "Remove user" Route.Path.Admin_RemoveUser
        , CommonView.linkToRoute "Change password for user" Route.Path.Admin_ChangePassword
        , CommonView.buttonToSendEvent "Log out" LogOut
        ]
