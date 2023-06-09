module Evergreen.V18.BackupModel exposing (..)

import Evergreen.V18.Route


type alias BackupModel =
    List
        { username : String
        , routes : List Evergreen.V18.Route.RouteData
        }
