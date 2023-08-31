module Evergreen.V22.BackupModel exposing (..)

import Evergreen.V22.Route


type alias BackupModel =
    List
        { username : String
        , routes : List Evergreen.V22.Route.RouteData
        }
