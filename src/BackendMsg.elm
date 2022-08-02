module BackendMsg exposing (BackendMsg(..))
import Lamdera

type BackendMsg
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg