module Evergreen.V23.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V23.BackendMsg
import Evergreen.V23.BackupModel
import Evergreen.V23.Bridge
import Evergreen.V23.Gen.Pages
import Evergreen.V23.Route
import Evergreen.V23.Shared
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V23.Shared.Model
    , page : Evergreen.V23.Gen.Pages.Model
    }


type alias SessionData =
    { lastTouched : Time.Posix
    , username : String
    }


type alias Password =
    String


type alias UserData =
    { username : String
    , password : Password
    , routes : List Evergreen.V23.Route.RouteData
    , nextId : Evergreen.V23.Route.RouteId
    }


type alias BackendModel =
    { sessions : Dict.Dict Lamdera.SessionId SessionData
    , users : Dict.Dict String UserData
    , currentTime : Time.Posix
    }


type FrontendMsg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url.Url
    | Shared Evergreen.V23.Shared.Msg
    | Page Evergreen.V23.Gen.Pages.Msg
    | NoOpFrontendMsg


type alias ToBackend =
    Evergreen.V23.Bridge.ToBackend


type alias BackendMsg =
    Evergreen.V23.BackendMsg.BackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List Evergreen.V23.Route.RouteData)
    | ToFrontendUserNewPasswordAccepted
    | ToFrontendUserNewPasswordRejected
    | ToFrontendYouAreAdmin
    | ToFrontendAdminWholeModel Evergreen.V23.BackupModel.BackupModel
    | ToFrontendWrongUserNamePassword
    | ToFrontendYourNotLoggedIn
    | NoOpToFrontend
