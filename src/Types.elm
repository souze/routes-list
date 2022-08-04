module Types exposing (..)

import BackendMsg
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Date exposing (Date)
import DatePicker
import Lamdera
import Route exposing (..)
import Time
import ToBackendMsg
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , message : String
    , rows : List RowData
    , newRouteData : Maybe NewRouteData
    , newRouteDatePickerData : DatePickerData
    , currentDate : Date
    , viewFilter : ViewFilter
    }


type ViewFilter
    = ViewAll
    | ViewLog
    | ViewWishlist


type alias DatePickerData =
    { dateText : String
    , pickerModel : DatePicker.Model
    }


type alias RowData =
    { expanded : Bool
    , datePickerData : DatePickerData
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
    | WishlistButtonPressed
    | LogButtonPressed
    | ViewAllButtonPressed
    | CreateNewRoute
    | SetCurrentDate Date
    | DatePickerUpdate RouteIdOrNew DatePicker.ChangeEvent
    | NoOpFrontendMsg


type ToBackend
    = UpdateRoute RouteData
    | RemoveRoute RouteId
    | ToBackendCreateNewRoute NewRouteData
    | NoOpToBackend


type alias BackendMsg =
    BackendMsg.BackendMsg



-- = ClientConnected Lamdera.SessionId Lamdera.ClientId
-- | NoOpBackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List RouteData)
    | NoOpToFrontend
