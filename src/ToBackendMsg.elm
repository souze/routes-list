module ToBackendMsg exposing (..)

import Route


type ToBackend
    = UpdateRoute Route.RouteData
    | RemoveRoute Route.RouteId
    | NoOpToBackend
