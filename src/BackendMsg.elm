module BackendMsg exposing (BackendMsg(..))
import Lamdera
import Time

type BackendMsg
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | ClientDisconnected Lamdera.SessionId Lamdera.ClientId
    | ClockTick Time.Posix
    | NoOpBackendMsg