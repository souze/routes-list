module Evergreen.V14.BackupModel exposing (..)

import Evergreen.V14.Route


type alias BackupModel =
    List
        { username : String
        , routes : List Evergreen.V14.Route.RouteData
        }
