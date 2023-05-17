module Pages.ChangePassword exposing (Model, Msg(..), page)

import Bridge
import CommonView
import Element exposing (Element)
import Element.Input
import Gen.Params.ChangePassword exposing (Params)
import Lamdera
import Page
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.element
        (\user ->
            { init = init
            , update = update
            , view = view
            , subscriptions = subscriptions
            }
        )



-- INIT


type alias Model =
    { oldPass : String
    , newPass : String
    , newPass2 : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" "" ""
    , Cmd.none
    )



-- UPDATE


type Msg
    = FieldUpdate String String
    | ChangePassword


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldUpdate fieldName newValue ->
            ( model |> updateField fieldName newValue
            , Cmd.none
            )

        ChangePassword ->
            ( model
            , Lamdera.sendToBackend <|
                Bridge.ToBackendUserChangePass { oldPassword = model.oldPass, newPassword = model.newPass }
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
    CommonView.mainColumnWithToprow
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
        , if model.newPass /= model.newPass2 then
            Element.text "Passwords don't match"

          else
            CommonView.buttonToSendEvent "Submit" ChangePassword
        ]
