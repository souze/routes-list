module Evergreen.V25.BackupModel exposing (..)

import Evergreen.V25.Route


type alias BackupModel =
    List
        { username : String
        , routes : List Evergreen.V25.Route.RouteData
        }
