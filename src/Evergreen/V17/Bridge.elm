module Evergreen.V17.Bridge exposing (..)

import Evergreen.V17.Route


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
    = UpdateRoute Evergreen.V17.Route.RouteData
    | RemoveRoute Evergreen.V17.Route.RouteId
    | ToBackendCreateNewRoute Evergreen.V17.Route.NewRouteData
    | ToBackendLogOut
    | ToBackendResetRouteList (List Evergreen.V17.Route.NewRouteData)
    | ToBackendLogIn String String
    | ToBackendRefreshSession
    | ToBackendAdminMsg AdminMsg
    | ToBackendUserChangePass
        { oldPassword : String
        , newPassword : String
        }
    | NoOpToBackend
