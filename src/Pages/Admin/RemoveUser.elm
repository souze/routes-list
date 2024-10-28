module Pages.Admin.RemoveUser exposing (Model, Msg(..), page)

import Auth
import Bridge
import CommonView
import Effect exposing (Effect)
import Element exposing (Element)
import Element.Input
import Lamdera
import Page exposing (Page)
import Route exposing (Route)
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
    { username : String }


init : ( Model, Effect Msg )
init =
    ( { username = "" }
    , Effect.none
    )



-- UPDATE


type Msg
    = FieldUpdate String
    | RemoveUser


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        FieldUpdate newValue ->
            ( { model | username = newValue }
            , Effect.none
            )

        RemoveUser ->
            ( model
            , Effect.sendToBackend <|
                Bridge.ToBackendAdminMsg (Bridge.RemoveUser model.username)
            )



-- VIEW


view : Model -> View Msg
view model =
    { title = "Remove user"
    , body = viewBody model
    }


viewBody : Model -> Element Msg
viewBody model =
    CommonView.adminPageWithItems
        [ Element.Input.text []
            { onChange = FieldUpdate
            , text = model.username
            , placeholder = Nothing
            , label = Element.Input.labelAbove [] (Element.text "Username")
            }
        , CommonView.buttonToSendEvent "Submit" RemoveUser
        ]
