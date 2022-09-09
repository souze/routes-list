module Evergreen.V7.Bridge exposing (..)

import Evergreen.V7.Route


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
    = UpdateRoute Evergreen.V7.Route.RouteData
    | RemoveRoute Evergreen.V7.Route.RouteId
    | ToBackendCreateNewRoute Evergreen.V7.Route.NewRouteData
    | ToBackendLogOut
    | ToBackendResetRouteList (List Evergreen.V7.Route.NewRouteData)
    | ToBackendLogIn String String
    | ToBackendRefreshSession
    | ToBackendAdminMsg AdminMsg
    | ToBackendUserChangePass
        { oldPassword : String
        , newPassword : String
        }
    | NoOpToBackend
