module Types exposing (..)

import BackendMsg
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Date exposing (Date)
import DatePicker
import Dict exposing (Dict)
import Lamdera
import Route exposing (..)
import Time
import ToBackendMsg
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , message : String
    , rows : List RowData
    , currentDate : Date
    , page : Page
    }


type Page
    = RoutePage ViewFilter
    | NewRoutePage { routeData : NewRouteData, datePickerData : DatePickerData }
    | InputJsonPage String (Maybe JsonError)
    | ViewJsonPage
    | LoginPage LoginPageData
    | MoreOptionsPage


type alias LoginPageData =
    { username : String, password : String }


type alias JsonError =
    String


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
    , sessions : Dict Lamdera.SessionId SessionData
    }


type alias SessionData =
    { loggedIn : Bool }


type LoginFieldType
    = FieldTypeUsername
    | FieldTypePassword


type LoginPageMsg
    = LoginPageFieldChange LoginFieldType String
    | LoginPageSubmit


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | LoginPageMsg LoginPageMsg
    | InputJsonButtonPressed
    | ViewAsJsonButtonPressed
    | RouteButtonClicked RouteId
    | EditRouteEnable RouteId
    | EditRouteSave RouteData
    | EditRouteRemove RouteId
    | EditRouteDiscardChanges RouteId
    | EditRouteUpdated RouteIdOrNew String String
    | JsonInputTextChanged String
    | JsonInputSubmitButtonPressed
    | NewRouteButtonPressed
    | WishlistButtonPressed
    | LogButtonPressed
    | ViewAllButtonPressed
    | MoreOptionsButtonPressed
    | CreateNewRoute
    | SetCurrentDate Date
    | DatePickerUpdate RouteIdOrNew DatePicker.ChangeEvent
    | NoOpFrontendMsg


type ToBackend
    = UpdateRoute RouteData
    | RemoveRoute RouteId
    | ToBackendCreateNewRoute NewRouteData
    | ToBackendResetRouteList (List NewRouteData)
    | ToBackendLogIn String String
    | NoOpToBackend


type alias BackendMsg =
    BackendMsg.BackendMsg



-- = ClientConnected Lamdera.SessionId Lamdera.ClientId
-- | NoOpBackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List RouteData)
    | ToFrontendWrongUserNamePassword
    | ToFrontendYourNotLoggedIn
    | NoOpToFrontend
