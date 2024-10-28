module Pages.Admin.ChangePassword exposing (Model, Msg(..), page)

import Auth
import Bridge
import CommonView
import Effect exposing (Effect)
import Element exposing (Element)
import Element.Input
import FormDict exposing (FormDict)
import Lamdera
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Util
import View exposing (View)


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user model route =
    Page.new
        { init = \_ -> init
        , update = update
        , view = view
        , subscriptions = Util.noSub
        }



-- INIT


type alias Model =
    { form : FormDict }


init : ( Model, Effect Msg )
init =
    ( { form = FormDict.init }, Effect.none )



-- UPDATE


type Msg
    = FieldUpdate String String
    | ChangePassword


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        FieldUpdate fieldName newValue ->
            ( { model | form = model.form |> FormDict.insert fieldName newValue }
            , Effect.none
            )

        ChangePassword ->
            ( model
            , Effect.sendToBackend <|
                Bridge.ToBackendAdminMsg
                    (Bridge.AdminMsgChangePassword
                        { username = model.form |> FormDict.get "username"
                        , password = model.form |> FormDict.get "password"
                        }
                    )
            )


view : Model -> View Msg
view model =
    { title = "Change password"
    , body = viewBody model
    }


viewBody : Model -> Element Msg
viewBody model =
    CommonView.adminPageWithItems
        [ Element.Input.text []
            { onChange = FieldUpdate "username"
            , text = model.form |> FormDict.get "username"
            , placeholder = Nothing
            , label = Element.Input.labelAbove [] (Element.text "Username")
            }
        , Element.Input.newPassword []
            { onChange = FieldUpdate "password"
            , text = model.form |> FormDict.get "password"
            , placeholder = Nothing
            , label = Element.Input.labelAbove [] (Element.text "Password")
            , show = False
            }
        , CommonView.buttonToSendEvent "Submit" ChangePassword
        ]
