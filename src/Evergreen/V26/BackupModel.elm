module Evergreen.V26.BackupModel exposing (..)

import Evergreen.V26.ClimbRoute


type alias BackupModel =
    List
        { username : String
        , routes : List Evergreen.V26.ClimbRoute.RouteData
        }
