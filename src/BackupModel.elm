module BackupModel exposing (..)

import ClimbRoute exposing (RouteData)


type alias BackupModel =
    List { username : String, routes : List RouteData }
