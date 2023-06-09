module Evergreen.V17.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V17.BackendMsg
import Evergreen.V17.BackupModel
import Evergreen.V17.Bridge
import Evergreen.V17.Gen.Pages
import Evergreen.V17.Route
import Evergreen.V17.Shared
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V17.Shared.Model
    , page : Evergreen.V17.Gen.Pages.Model
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
    , routes : List Evergreen.V17.Route.RouteData
    , nextId : Evergreen.V17.Route.RouteId
    }


type alias BackendModel =
    { sessions : Dict.Dict Lamdera.SessionId SessionData
    , users : Dict.Dict String UserData
    , currentTime : Time.Posix
    }


type FrontendMsg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url.Url
    | Shared Evergreen.V17.Shared.Msg
    | Page Evergreen.V17.Gen.Pages.Msg
    | NoOpFrontendMsg


type alias ToBackend =
    Evergreen.V17.Bridge.ToBackend


type alias BackendMsg =
    Evergreen.V17.BackendMsg.BackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List Evergreen.V17.Route.RouteData)
    | ToFrontendUserNewPasswordAccepted
    | ToFrontendUserNewPasswordRejected
    | ToFrontendYouAreAdmin
    | ToFrontendAdminWholeModel Evergreen.V17.BackupModel.BackupModel
    | ToFrontendWrongUserNamePassword
    | ToFrontendYourNotLoggedIn
    | NoOpToFrontend
