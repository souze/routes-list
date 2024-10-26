module Pages.MoreOptions exposing (Model, Msg(..), page)

import Bridge
import CommonView
import Element exposing (Element)
import Gen.Params.MoreOptions exposing (Params)
import Gen.Route
import Lamdera
import Page
import Request
import Shared
import View exposing (View)


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user model route =
    Page.new
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- INIT


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- UPDATE


type Msg
    = Logout


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Logout ->
            ( model
            , Lamdera.sendToBackend Bridge.ToBackendLogOut
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
        [ CommonView.linkToRoute "New Route" Gen.Route.NewRoute
        , CommonView.linkToRoute "Stats" Gen.Route.Stats
        , CommonView.linkToRoute "Input Json" Gen.Route.InputJson
        , CommonView.linkToRoute "View as Json" Gen.Route.OutputJson
        , CommonView.linkToRoute "Change password" Gen.Route.ChangePassword
        , CommonView.buttonToSendEvent "Log out" Logout
        ]
