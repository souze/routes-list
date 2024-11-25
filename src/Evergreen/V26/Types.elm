module Evergreen.V26.Types exposing (..)

import Dict
import Evergreen.V26.BackendMsg
import Evergreen.V26.BackupModel
import Evergreen.V26.Bridge
import Evergreen.V26.ClimbRoute
import Evergreen.V26.Main
import Lamdera
import Time


type alias FrontendModel =
    Evergreen.V26.Main.Model


type alias SessionData =
    { lastTouched : Time.Posix
    , username : String
    }


type alias Password =
    String


type alias UserData =
    { username : String
    , password : Password
    , routes : List Evergreen.V26.ClimbRoute.RouteData
    , nextId : Evergreen.V26.ClimbRoute.RouteId
    }


type alias BackendModel =
    { sessions : Dict.Dict Lamdera.SessionId SessionData
    , users : Dict.Dict String UserData
    , currentTime : Time.Posix
    }


type alias FrontendMsg =
    Evergreen.V26.Main.Msg


type alias ToBackend =
    Evergreen.V26.Bridge.ToBackend


type alias BackendMsg =
    Evergreen.V26.BackendMsg.BackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List Evergreen.V26.ClimbRoute.RouteData)
    | ToFrontendUserNewPasswordAccepted
    | ToFrontendUserNewPasswordRejected
    | ToFrontendYouAreAdmin
    | ToFrontendAdminWholeModel Evergreen.V26.BackupModel.BackupModel
    | ToFrontendWrongUserNamePassword
    | ToFrontendYourNotLoggedIn
    | NoOpToFrontend
