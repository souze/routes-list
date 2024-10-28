module Pages.Admin.AddUser exposing (Model, Msg(..), page)

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
    { form : FormDict
    }


init : ( Model, Effect Msg )
init =
    ( { form = FormDict.init }
    , Effect.none
    )



-- UPDATE


type Msg
    = FieldUpdate String String
    | CreateUser


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        FieldUpdate fieldName newValue ->
            ( { model | form = model.form |> FormDict.insert fieldName newValue }
            , Effect.none
            )

        CreateUser ->
            ( model
            , Effect.sendToBackend <|
                Bridge.ToBackendAdminMsg
                    (Bridge.AddUser
                        { username = FormDict.get "username" model.form
                        , password = FormDict.get "password" model.form
                        }
                    )
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Add user"
    , body = viewBody model
    }


viewBody : Model -> Element Msg
viewBody model =
    CommonView.adminPageWithItems
        [ Element.Input.text []
            { onChange = FieldUpdate "username"
            , text = FormDict.get "username" model.form
            , placeholder = Nothing
            , label = Element.Input.labelAbove [] (Element.text "Username")
            }
        , Element.Input.newPassword []
            { onChange = FieldUpdate "password"
            , text = FormDict.get "password" model.form
            , placeholder = Nothing
            , label = Element.Input.labelAbove [] (Element.text "Password")
            , show = False
            }
        , CommonView.buttonToSendEvent "Submit" CreateUser
        ]
