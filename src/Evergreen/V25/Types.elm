module Evergreen.V25.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V25.BackendMsg
import Evergreen.V25.BackupModel
import Evergreen.V25.Bridge
import Evergreen.V25.Gen.Pages
import Evergreen.V25.Route
import Evergreen.V25.Shared
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V25.Shared.Model
    , page : Evergreen.V25.Gen.Pages.Model
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
    , routes : List Evergreen.V25.Route.RouteData
    , nextId : Evergreen.V25.Route.RouteId
    }


type alias BackendModel =
    { sessions : Dict.Dict Lamdera.SessionId SessionData
    , users : Dict.Dict String UserData
    , currentTime : Time.Posix
    }


type FrontendMsg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url.Url
    | Shared Evergreen.V25.Shared.Msg
    | Page Evergreen.V25.Gen.Pages.Msg
    | NoOpFrontendMsg


type alias ToBackend =
    Evergreen.V25.Bridge.ToBackend


type alias BackendMsg =
    Evergreen.V25.BackendMsg.BackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List Evergreen.V25.Route.RouteData)
    | ToFrontendUserNewPasswordAccepted
    | ToFrontendUserNewPasswordRejected
    | ToFrontendYouAreAdmin
    | ToFrontendAdminWholeModel Evergreen.V25.BackupModel.BackupModel
    | ToFrontendWrongUserNamePassword
    | ToFrontendYourNotLoggedIn
    | NoOpToFrontend
