module Evergreen.V14.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V14.BackendMsg
import Evergreen.V14.BackupModel
import Evergreen.V14.Bridge
import Evergreen.V14.Gen.Pages
import Evergreen.V14.Route
import Evergreen.V14.Shared
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V14.Shared.Model
    , page : Evergreen.V14.Gen.Pages.Model
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
    , routes : List Evergreen.V14.Route.RouteData
    , nextId : Evergreen.V14.Route.RouteId
    }


type alias BackendModel =
    { sessions : Dict.Dict Lamdera.SessionId SessionData
    , users : Dict.Dict String UserData
    , currentTime : Time.Posix
    }


type FrontendMsg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url.Url
    | Shared Evergreen.V14.Shared.Msg
    | Page Evergreen.V14.Gen.Pages.Msg
    | NoOpFrontendMsg


type alias ToBackend =
    Evergreen.V14.Bridge.ToBackend


type alias BackendMsg =
    Evergreen.V14.BackendMsg.BackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List Evergreen.V14.Route.RouteData)
    | ToFrontendUserNewPasswordAccepted
    | ToFrontendUserNewPasswordRejected
    | ToFrontendYouAreAdmin
    | ToFrontendAdminWholeModel Evergreen.V14.BackupModel.BackupModel
    | ToFrontendWrongUserNamePassword
    | ToFrontendYourNotLoggedIn
    | NoOpToFrontend
