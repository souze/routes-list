module Bridge exposing (..)

import ClimbRoute


type ToBackend
    = UpdateRoute ClimbRoute.RouteData
    | RemoveRoute ClimbRoute.RouteId
    | ToBackendCreateNewRoute ClimbRoute.NewRouteData
    | ToBackendLogOut
    | ToBackendResetRouteList (List ClimbRoute.NewRouteData)
    | ToBackendLogIn String String
    | ToBackendRefreshSession
    | ToBackendAdminMsg AdminMsg
    | ToBackendUserChangePass { oldPassword : String, newPassword : String }
    | NoOpToBackend


type AdminMsg
    = AddUser { username : String, password : String }
    | RemoveUser String
    | RequestModel
    | AdminMsgChangePassword { username : String, password : String }
