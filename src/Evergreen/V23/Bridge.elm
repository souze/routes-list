module Evergreen.V23.Bridge exposing (..)

import Evergreen.V23.Route


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
    = UpdateRoute Evergreen.V23.Route.RouteData
    | RemoveRoute Evergreen.V23.Route.RouteId
    | ToBackendCreateNewRoute Evergreen.V23.Route.NewRouteData
    | ToBackendLogOut
    | ToBackendResetRouteList (List Evergreen.V23.Route.NewRouteData)
    | ToBackendLogIn String String
    | ToBackendRefreshSession
    | ToBackendAdminMsg AdminMsg
    | ToBackendUserChangePass
        { oldPassword : String
        , newPassword : String
        }
    | NoOpToBackend
