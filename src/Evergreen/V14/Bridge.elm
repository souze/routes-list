module Evergreen.V14.Bridge exposing (..)

import Evergreen.V14.Route


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
    = UpdateRoute Evergreen.V14.Route.RouteData
    | RemoveRoute Evergreen.V14.Route.RouteId
    | ToBackendCreateNewRoute Evergreen.V14.Route.NewRouteData
    | ToBackendLogOut
    | ToBackendResetRouteList (List Evergreen.V14.Route.NewRouteData)
    | ToBackendLogIn String String
    | ToBackendRefreshSession
    | ToBackendAdminMsg AdminMsg
    | ToBackendUserChangePass
        { oldPassword : String
        , newPassword : String
        }
    | NoOpToBackend
