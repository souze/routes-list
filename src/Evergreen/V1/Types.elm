module Evergreen.V1.Types exposing (..)

import Browser
import Browser.Navigation
import Date
import DatePicker
import Dict
import Evergreen.V1.BackendMsg
import Evergreen.V1.Route
import Lamdera
import Url


type alias DatePickerData =
    { dateText : String
    , pickerModel : DatePicker.Model
    }


type alias RowData =
    { expanded : Bool
    , datePickerData : DatePickerData
    , route : Evergreen.V1.Route.RouteDataEdit
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
        { routeData : Evergreen.V1.Route.NewRouteData
        , datePickerData : DatePickerData
        }
    | InputJsonPage String (Maybe JsonError)
    | ViewJsonPage
    | LoginPage LoginPageData


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , message : String
    , rows : List RowData
    , currentDate : Date.Date
    , page : Page
    }


type alias SessionData =
    { loggedIn : Bool
    }


type alias BackendModel =
    { routes : List Evergreen.V1.Route.RouteData
    , nextId : Evergreen.V1.Route.RouteId
    , sessions : Dict.Dict Lamdera.SessionId SessionData
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
    | RouteButtonClicked Evergreen.V1.Route.RouteId
    | EditRouteEnable Evergreen.V1.Route.RouteId
    | EditRouteSave Evergreen.V1.Route.RouteData
    | EditRouteRemove Evergreen.V1.Route.RouteId
    | EditRouteDiscardChanges Evergreen.V1.Route.RouteId
    | EditRouteUpdated Evergreen.V1.Route.RouteIdOrNew String String
    | JsonInputTextChanged String
    | JsonInputSubmitButtonPressed
    | NewRouteButtonPressed
    | WishlistButtonPressed
    | LogButtonPressed
    | ViewAllButtonPressed
    | CreateNewRoute
    | SetCurrentDate Date.Date
    | DatePickerUpdate Evergreen.V1.Route.RouteIdOrNew DatePicker.ChangeEvent
    | NoOpFrontendMsg


type ToBackend
    = UpdateRoute Evergreen.V1.Route.RouteData
    | RemoveRoute Evergreen.V1.Route.RouteId
    | ToBackendCreateNewRoute Evergreen.V1.Route.NewRouteData
    | ToBackendResetRouteList (List Evergreen.V1.Route.NewRouteData)
    | ToBackendLogIn String String
    | NoOpToBackend


type alias BackendMsg =
    Evergreen.V1.BackendMsg.BackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List Evergreen.V1.Route.RouteData)
    | ToFrontendWrongUserNamePassword
    | ToFrontendYourNotLoggedIn
    | NoOpToFrontend
