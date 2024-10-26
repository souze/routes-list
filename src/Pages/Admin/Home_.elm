module Pages.Admin.Home_ exposing (Model, Msg(..), page)

import Bridge
import CommonView
import Element exposing (Element)
import Gen.Params.Admin.Home_ exposing (Params)
import Gen.Route
import Lamdera
import Page
import Request
import Shared
import View exposing (View)


page : Auth.User -> Shared.Model -> Route { home : String } -> Page Model Msg
page user model route =
    Page.new
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- UPDATE


type Msg
    = LogOut


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LogOut ->
            ( model
            , Lamdera.sendToBackend <| Bridge.ToBackendLogOut
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
        [ CommonView.linkToRoute "Show Json" Gen.Route.Admin__ShowJson
        , CommonView.linkToRoute "Add user" Gen.Route.Admin__AddUser
        , CommonView.linkToRoute "Remove user" Gen.Route.Admin__RemoveUser
        , CommonView.linkToRoute "Change password for user" Gen.Route.Admin__ChangePassword
        , CommonView.buttonToSendEvent "Log out" LogOut
        ]
