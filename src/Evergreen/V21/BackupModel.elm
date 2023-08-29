module Evergreen.V21.BackupModel exposing (..)

import Evergreen.V21.Route


type alias BackupModel =
    List
        { username : String
        , routes : List Evergreen.V21.Route.RouteData
        }
