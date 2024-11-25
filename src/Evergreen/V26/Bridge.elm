module Evergreen.V26.Bridge exposing (..)

import Evergreen.V26.ClimbRoute


type AdminMsg
    = AddUser
        { username : String
        , password : String
        }
    | RemoveUser String
    | RequestModel
    | AdminMsgChangePassword
        { username : String
        , password : String
        }


type ToBackend
    = UpdateRoute Evergreen.V26.ClimbRoute.RouteData
    | RemoveRoute Evergreen.V26.ClimbRoute.RouteId
    | ToBackendCreateNewRoute Evergreen.V26.ClimbRoute.NewRouteData
    | ToBackendLogOut
    | ToBackendResetRouteList (List Evergreen.V26.ClimbRoute.NewRouteData)
    | ToBackendLogIn String String
    | ToBackendRefreshSession
    | ToBackendAdminMsg AdminMsg
    | ToBackendUserChangePass
        { oldPassword : String
        , newPassword : String
        }
    | NoOpToBackend
