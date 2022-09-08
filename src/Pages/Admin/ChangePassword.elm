module Pages.Admin.ChangePassword exposing (Model, Msg, page)

import Bridge
import CommonView
import Element exposing (Element)
import Element.Input
import FormDict exposing (FormDict)
import Gen.Params.Admin.ChangePassword exposing (Params)
import Lamdera
import Page
import Request
import Shared
import Util
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.element
        (\_ ->
            { init = init
            , update = update
            , view = view
            , subscriptions = Util.noSub
            }
        )



-- INIT


type alias Model =
    { form : FormDict }


init : ( Model, Cmd Msg )
init =
    ( { form = FormDict.init }, Cmd.none )



-- UPDATE


type Msg
    = FieldUpdate String String
    | ChangePassword


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldUpdate fieldName newValue ->
            ( { model | form = model.form |> FormDict.insert fieldName newValue }
            , Cmd.none
            )

        ChangePassword ->
            ( model
            , Lamdera.sendToBackend <|
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
