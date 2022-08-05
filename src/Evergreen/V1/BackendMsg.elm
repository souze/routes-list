module Evergreen.V1.BackendMsg exposing (..)

import Lamdera


type BackendMsg
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | ClientDisconnected Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg
