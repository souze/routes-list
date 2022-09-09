module Evergreen.V7.BackupModel exposing (..)

import Evergreen.V7.Route


type alias BackupModel =
    List
        { username : String
        , routes : List Evergreen.V7.Route.RouteData
        }
