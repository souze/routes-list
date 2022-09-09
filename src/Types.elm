module Types exposing (..)

import BackendMsg
import BackupModel
import Bridge
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Date exposing (Date)
import DatePicker
import Dict exposing (Dict)
import Gen.Pages as Pages
import Lamdera
import Route exposing (..)
import Shared
import Time
import Url exposing (Url)


type alias FrontendModel =
    { url : Url
    , key : Key
    , shared : Shared.Model
    , page : Pages.Model
    }


type alias Password =
    String


type alias UserData =
    { username : String
    , password : Password
    , routes : List RouteData
    , nextId : RouteId
    }


type alias BackendModel =
    { sessions : Dict Lamdera.SessionId SessionData
    , users : Dict String UserData
    , currentTime : Time.Posix
    }


type alias SessionData =
    { lastTouched : Time.Posix
    , username : String
    }


type LoginFieldType
    = FieldTypeUsername
    | FieldTypePassword


type LoginPageMsg
    = LoginPageFieldChange LoginFieldType String
    | LoginPageSubmit


type FieldType
    = FieldAddUserUsername
    | FieldAddUserPassword
    | FieldRemoveUserUsername
    | FieldChangePasswordUsername
    | FieldChangePasswordPassword
    | FieldUserChangePasswordOldPass
    | FieldUserChangePasswordNewPass
    | FieldUserChangePasswordNewPass2


type FrontendMsg
    = ClickedLink UrlRequest
    | ChangedUrl Url
    | Shared Shared.Msg
    | Page Pages.Msg
    | NoOpFrontendMsg


type alias ToBackend =
    Bridge.ToBackend


type alias BackendMsg =
    BackendMsg.BackendMsg



-- = ClientConnected Lamdera.SessionId Lamdera.ClientId
-- | NoOpBackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List RouteData)
    | ToFrontendUserNewPasswordAccepted
    | ToFrontendUserNewPasswordRejected
    | ToFrontendYouAreAdmin
    | ToFrontendAdminWholeModel BackupModel.BackupModel
    | ToFrontendWrongUserNamePassword
    | ToFrontendYourNotLoggedIn
    | NoOpToFrontend
