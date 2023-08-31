module Evergreen.V23.BackupModel exposing (..)

import Evergreen.V23.Route


type alias BackupModel =
    List
        { username : String
        , routes : List Evergreen.V23.Route.RouteData
        }
