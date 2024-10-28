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
import Pages.Admin.ShowJson
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



-- INIT
-- initialFrontendModel : Url.Url -> Key -> Shared.Model -> Pages.Model -> Model
-- initialFrontendModel url key shared page =
--     { url = url
--     , key = key
--     , shared = shared
--     , page = page
--     }
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

        -- ToFrontendAdminWholeModel backupModel ->
        --     pageUpdate (Gen.Msg.Admin__ShowJson (Pages.Admin.ShowJson.BackupModelFromBackend backupModel)) model
        -- ToFrontendWrongUserNamePassword ->
        --     pageUpdate (Gen.Msg.SignIn__SignInDest_ Pages.SignIn.SignInDest_.WrongUsernameOrPassword) model
        _ ->
            ( model, Cmd.none )



-- pageUpdate : Pages.Msg -> Model -> ( Model, Cmd Msg )
-- pageUpdate pageMsg model =
--     let
--         ( page, effect ) =
--             Pages.update pageMsg model.page model.shared model.url model.key
--     in
--     ( { model | page = page }
--     , Effect.toCmd ( Shared, Page ) effect
--     )


sendSharedMsg : Shared.Msg.Msg -> Cmd Msg
sendSharedMsg sharedMsg =
    Time.now |> Task.perform (always (ElmLand.Shared sharedMsg))
