module Evergreen.V22.Bridge exposing (..)

import Evergreen.V22.Route


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
    = UpdateRoute Evergreen.V22.Route.RouteData
    | RemoveRoute Evergreen.V22.Route.RouteId
    | ToBackendCreateNewRoute Evergreen.V22.Route.NewRouteData
    | ToBackendLogOut
    | ToBackendResetRouteList (List Evergreen.V22.Route.NewRouteData)
    | ToBackendLogIn String String
    | ToBackendRefreshSession
    | ToBackendAdminMsg AdminMsg
    | ToBackendUserChangePass
        { oldPassword : String
        , newPassword : String
        }
    | NoOpToBackend
