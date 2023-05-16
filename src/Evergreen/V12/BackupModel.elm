module Evergreen.V12.BackupModel exposing (..)

import Evergreen.V12.Route


type alias BackupModel =
    List
        { username : String
        , routes : List Evergreen.V12.Route.RouteData
        }
