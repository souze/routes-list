module Pages.ChangePassword exposing (Model, Msg(..), page)

import Auth
import Bridge
import CommonView
import Effect exposing (Effect)
import Element exposing (Element)
import Element.Input
import Lamdera
import Layouts
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
        |> Page.withLayout (\_ -> Layouts.Header {})



-- INIT


type alias Model =
    { oldPass : String
    , newPass : String
    , newPass2 : String
    , statusMessage : StatusMessage
    }


type StatusMessage
    = Pending
    | Success
    | Failed


init : ( Model, Effect Msg )
init =
    ( Model "" "" "" Pending
    , Effect.none
    )



-- UPDATE


type Msg
    = FieldUpdate String String
    | ChangePassword
    | FromBackendPasswordAccepted
    | FromBackendPasswordRejected


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        FieldUpdate fieldName newValue ->
            ( model |> updateField fieldName newValue
            , Effect.none
            )

        ChangePassword ->
            ( model
            , Effect.sendToBackend <|
                Bridge.ToBackendUserChangePass { oldPassword = model.oldPass, newPassword = model.newPass }
            )

        FromBackendPasswordAccepted ->
            ( { model | statusMessage = Success, oldPass = "", newPass = "", newPass2 = "" }
            , Effect.none
            )

        FromBackendPasswordRejected ->
            ( { model | statusMessage = Failed }
            , Effect.none
            )


updateField : String -> String -> Model -> Model
updateField fieldName newValue model =
    case fieldName of
        "oldpass" ->
            { model | oldPass = newValue }

        "newpass" ->
            { model | newPass = newValue }

        "newpass2" ->
            { model | newPass2 = newValue }

        _ ->
            model



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Change password"
    , body = viewBody model
    }


viewBody : Model -> Element Msg
viewBody model =
    CommonView.mainColumn
        [ Element.Input.currentPassword []
            { onChange = FieldUpdate "oldpass"
            , text = model.oldPass
            , placeholder = Just <| Element.Input.placeholder [] (Element.text "Old password")
            , label = Element.Input.labelAbove [] (Element.text "Old password")
            , show = False
            }
        , Element.Input.newPassword []
            { onChange = FieldUpdate "newpass"
            , text = model.newPass
            , placeholder = Just <| Element.Input.placeholder [] (Element.text "New password")
            , label = Element.Input.labelAbove [] (Element.text "New password")
            , show = False
            }
        , Element.Input.newPassword []
            { onChange = FieldUpdate "newpass2"
            , text = model.newPass2
            , placeholder = Just <| Element.Input.placeholder [] (Element.text "New password again")
            , label = Element.Input.labelAbove [] (Element.text "New password")
            , show = False
            }
        , Element.el [] <|
            case model.statusMessage of
                Pending ->
                    Element.text ""

                Success ->
                    Element.text "Password changed"

                Failed ->
                    Element.text "Password change failed"
        , if model.newPass /= model.newPass2 then
            Element.text "Passwords don't match"

          else
            CommonView.buttonToSendEvent "Submit" ChangePassword
        ]
