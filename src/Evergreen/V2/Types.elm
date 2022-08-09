module Evergreen.V2.Types exposing (..)

import Browser
import Browser.Navigation
import Date
import DatePicker
import Dict
import Evergreen.V2.BackendMsg
import Evergreen.V2.Route
import Lamdera
import Time
import Url


type alias DatePickerData =
    { dateText : String
    , pickerModel : DatePicker.Model
    }


type alias RowData =
    { expanded : Bool
    , datePickerData : DatePickerData
    , route : Evergreen.V2.Route.RouteDataEdit
    }


type ViewFilter
    = ViewAll
    | ViewLog
    | ViewWishlist


type alias JsonError =
    String


type alias LoginPageData =
    { username : String
    , password : String
    }


type Page
    = RoutePage ViewFilter
    | NewRoutePage
        { routeData : Evergreen.V2.Route.NewRouteData
        , datePickerData : DatePickerData
        }
    | InputJsonPage String (Maybe JsonError)
    | ViewJsonPage
    | LoginPage LoginPageData
    | MoreOptionsPage


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , message : String
    , rows : List RowData
    , currentDate : Date.Date
    , page : Page
    }


type alias SessionData =
    { loggedIn : Bool
    , lastTouched : Time.Posix
    }


type alias BackendModel =
    { routes : List Evergreen.V2.Route.RouteData
    , nextId : Evergreen.V2.Route.RouteId
    , sessions : Dict.Dict Lamdera.SessionId SessionData
    , currentTime : Time.Posix
    }


type LoginFieldType
    = FieldTypeUsername
    | FieldTypePassword


type LoginPageMsg
    = LoginPageFieldChange LoginFieldType String
    | LoginPageSubmit


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | LoginPageMsg LoginPageMsg
    | InputJsonButtonPressed
    | ViewAsJsonButtonPressed
    | RouteButtonClicked Evergreen.V2.Route.RouteId
    | EditRouteEnable Evergreen.V2.Route.RouteId
    | EditRouteSave Evergreen.V2.Route.RouteData
    | EditRouteRemove Evergreen.V2.Route.RouteId
    | EditRouteDiscardChanges Evergreen.V2.Route.RouteId
    | EditRouteUpdated Evergreen.V2.Route.RouteIdOrNew String String
    | JsonInputTextChanged String
    | JsonInputSubmitButtonPressed
    | NewRouteButtonPressed
    | WishlistButtonPressed
    | LogButtonPressed
    | ViewAllButtonPressed
    | MoreOptionsButtonPressed
    | CreateNewRoute
    | SetCurrentDate Date.Date
    | DatePickerUpdate Evergreen.V2.Route.RouteIdOrNew DatePicker.ChangeEvent
    | SendRefreshSessionToBackend Time.Posix
    | NoOpFrontendMsg


type ToBackend
    = UpdateRoute Evergreen.V2.Route.RouteData
    | RemoveRoute Evergreen.V2.Route.RouteId
    | ToBackendCreateNewRoute Evergreen.V2.Route.NewRouteData
    | ToBackendResetRouteList (List Evergreen.V2.Route.NewRouteData)
    | ToBackendLogIn String String
    | ToBackendRefreshSession
    | NoOpToBackend


type alias BackendMsg =
    Evergreen.V2.BackendMsg.BackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List Evergreen.V2.Route.RouteData)
    | ToFrontendWrongUserNamePassword
    | ToFrontendYourNotLoggedIn
    | NoOpToFrontend
