module Evergreen.V17.BackupModel exposing (..)

import Evergreen.V17.Route


type alias BackupModel =
    List
        { username : String
        , routes : List Evergreen.V17.Route.RouteData
        }
