module Pages.Admin.AddUser exposing (Model, Msg(..), page)

import Bridge
import CommonView
import Element exposing (Element)
import Element.Input
import FormDict exposing (FormDict)
import Gen.Params.Admin.AddUser exposing (Params)
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
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { form : FormDict
    }


init : ( Model, Cmd Msg )
init =
    ( { form = FormDict.init }
    , Cmd.none
    )



-- UPDATE


type Msg
    = FieldUpdate String String
    | CreateUser


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldUpdate fieldName newValue ->
            ( { model | form = model.form |> FormDict.insert fieldName newValue }
            , Cmd.none
            )

        CreateUser ->
            ( model
            , Lamdera.sendToBackend <|
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
