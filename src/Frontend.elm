module Frontend exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation as Nav exposing (Key)
import Date
import Effect
import Element
import Json.Encode
import Lamdera
import Main as ElmLand
import Main.Pages.Msg as MainPagesMsg
import Pages.Admin.ShowJson
import Pages.ChangePassword
import Pages.SignIn
import Route as GenRoute
import Shared
import Shared.Msg
import Task
import Time
import Types exposing (..)
import Url exposing (Url)
import View


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = ElmLand.init Json.Encode.null
        , onUrlRequest = ElmLand.UrlRequested
        , onUrlChange = ElmLand.UrlChanged
        , update = ElmLand.update
        , updateFromBackend = updateFromBackend
        , subscriptions = ElmLand.subscriptions
        , view = ElmLand.view
        }



-- UPDATE


type alias Msg =
    FrontendMsg


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        AllRoutesAnnouncement routes ->
            ( model, sendSharedMsg (Shared.Msg.MsgFromBackend (Shared.Msg.AllRoutesAnnouncement routes)) )

        ToFrontendYourNotLoggedIn ->
            ( model, sendSharedMsg (Shared.Msg.MsgFromBackend Shared.Msg.LogOut) )

        ToFrontendYouAreAdmin ->
            ( model, sendSharedMsg (Shared.Msg.MsgFromBackend Shared.Msg.YouAreAdmin) )

        ToFrontendUserNewPasswordAccepted ->
            pageUpdate (MainPagesMsg.ChangePassword Pages.ChangePassword.FromBackendPasswordAccepted) model

        ToFrontendUserNewPasswordRejected ->
            pageUpdate (MainPagesMsg.ChangePassword Pages.ChangePassword.FromBackendPasswordRejected) model

        ToFrontendAdminWholeModel backupModel ->
            pageUpdate (MainPagesMsg.Admin_ShowJson (Pages.Admin.ShowJson.BackupModelFromBackend backupModel)) model

        ToFrontendWrongUserNamePassword ->
            pageUpdate (MainPagesMsg.SignIn Pages.SignIn.WrongUsernameOrPassword) model

        NoOpToFrontend ->
            ( model, Cmd.none )


pageUpdate : MainPagesMsg.Msg -> Model -> ( Model, Cmd Msg )
pageUpdate pageMsg model =
    let
        ( pageModel, pageCmd ) =
            ElmLand.updateFromPage pageMsg model
    in
    ( { model | page = pageModel }
    , pageCmd
    )


sendSharedMsg : Shared.Msg.Msg -> Cmd Msg
sendSharedMsg sharedMsg =
    Time.now |> Task.perform (always (ElmLand.Shared sharedMsg))
