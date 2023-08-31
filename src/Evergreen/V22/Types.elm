module Evergreen.V22.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V22.BackendMsg
import Evergreen.V22.BackupModel
import Evergreen.V22.Bridge
import Evergreen.V22.Gen.Pages
import Evergreen.V22.Route
import Evergreen.V22.Shared
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V22.Shared.Model
    , page : Evergreen.V22.Gen.Pages.Model
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
    , routes : List Evergreen.V22.Route.RouteData
    , nextId : Evergreen.V22.Route.RouteId
    }


type alias BackendModel =
    { sessions : Dict.Dict Lamdera.SessionId SessionData
    , users : Dict.Dict String UserData
    , currentTime : Time.Posix
    }


type FrontendMsg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url.Url
    | Shared Evergreen.V22.Shared.Msg
    | Page Evergreen.V22.Gen.Pages.Msg
    | NoOpFrontendMsg


type alias ToBackend =
    Evergreen.V22.Bridge.ToBackend


type alias BackendMsg =
    Evergreen.V22.BackendMsg.BackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List Evergreen.V22.Route.RouteData)
    | ToFrontendUserNewPasswordAccepted
    | ToFrontendUserNewPasswordRejected
    | ToFrontendYouAreAdmin
    | ToFrontendAdminWholeModel Evergreen.V22.BackupModel.BackupModel
    | ToFrontendWrongUserNamePassword
    | ToFrontendYourNotLoggedIn
    | NoOpToFrontend
