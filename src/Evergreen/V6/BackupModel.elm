module Evergreen.V6.BackupModel exposing (..)

import Evergreen.V6.Route


type alias BackupModel =
    List
        { username : String
        , routes : List Evergreen.V6.Route.RouteData
        }
