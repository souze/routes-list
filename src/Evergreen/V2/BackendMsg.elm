module Evergreen.V2.BackendMsg exposing (..)

import Lamdera
import Time


type BackendMsg
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | ClientDisconnected Lamdera.SessionId Lamdera.ClientId
    | ClockTick Time.Posix
    | NoOpBackendMsg
