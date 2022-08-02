module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Lamdera
import Time
import Url exposing (Url)
import BackendMsg
import ToBackendMsg
import Route exposing (..)


type alias FrontendModel =
    { key : Key
    , message : String
    , rows : List RowData
    , newRouteData : Maybe NewRouteData
    }


type alias RowData =
    { expanded : Bool
    , route : RouteDataEdit
    }


type alias BackendModel =
    { routes : List RouteData
    , nextId : RouteId
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | RouteButtonClicked RouteId
    | EditRouteEnable RouteId
    | EditRouteSave RouteData
    | EditRouteRemove RouteId
    | EditRouteDiscardChanges RouteId
    | EditRouteUpdated RouteIdOrNew String String
    | NewRouteButtonPressed
    | CreateNewRoute
    | NoOpFrontendMsg


type ToBackend
    = UpdateRoute RouteData
    | RemoveRoute RouteId
    | ToBackendCreateNewRoute NewRouteData
    | NoOpToBackend


type alias BackendMsg = BackendMsg.BackendMsg
    -- = ClientConnected Lamdera.SessionId Lamdera.ClientId
    -- | NoOpBackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List RouteData)
    | NoOpToFrontend
