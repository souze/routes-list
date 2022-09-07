module Bridge exposing (..)

import Route


type ToBackend
    = UpdateRoute Route.RouteData
    | RemoveRoute Route.RouteId
    | ToBackendCreateNewRoute Route.NewRouteData
    | ToBackendLogOut
    | ToBackendResetRouteList (List Route.NewRouteData)
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
