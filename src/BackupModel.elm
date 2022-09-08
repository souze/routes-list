module BackupModel exposing (..)

import Route exposing (RouteData)


type alias BackupModel =
    List { username : String, routes : List RouteData }
