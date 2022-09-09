module Evergreen.V6.Types exposing (..)

import Browser
import Browser.Navigation
import Date
import DatePicker
import Dict
import Evergreen.V6.BackendMsg
import Evergreen.V6.BackupModel
import Evergreen.V6.Bridge
import Evergreen.V6.Gen.Pages
import Evergreen.V6.Route
import Evergreen.V6.Shared
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
    , route : Evergreen.V6.Route.RouteDataEdit
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


type AdminPage
    = AdminHomePage
    | AdminInputJson
    | AdminShowJson String
    | AdminAddUser String String
    | AdminRemoveUser String
    | AdminChangePassword String String


type Page
    = RoutePage ViewFilter
    | NewRoutePage
        { routeData : Evergreen.V6.Route.NewRouteData
        , datePickerData : DatePickerData
        }
    | InputJsonPage String (Maybe JsonError)
    | ConfirmPage
        { text : String
        , label : String
        , code : String
        , event : ToBackend
        , abortPage : Page
        }
    | ViewJsonPage
    | ChangePasswordPage
        { oldPassword : String
        , newPassword : String
        , newPassword2 : String
        , status : String
        }
    | LoginPage LoginPageData
    | MoreOptionsPage
    | SpinnerPage String
    | AdminPage AdminPage


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V6.Shared.Model
    , page : Evergreen.V6.Gen.Pages.Model
    , message : String
    , rows : List RowData
    , currentDate : Date.Date
    , currentPage : Page
    }


type alias SessionData =
    { lastTouched : Time.Posix
    , username : String
    }


type alias Password =
    String


type alias UserData =
    { username : String
    , password : Password
    , routes : List Evergreen.V6.Route.RouteData
    , nextId : Evergreen.V6.Route.RouteId
    }


type alias BackendModel =
    { sessions : Dict.Dict Lamdera.SessionId SessionData
    , users : Dict.Dict String UserData
    , currentTime : Time.Posix
    }


type FieldType
    = FieldAddUserUsername
    | FieldAddUserPassword
    | FieldRemoveUserUsername
    | FieldChangePasswordUsername
    | FieldChangePasswordPassword
    | FieldUserChangePasswordOldPass
    | FieldUserChangePasswordNewPass
    | FieldUserChangePasswordNewPass2


type LoginFieldType
    = FieldTypeUsername
    | FieldTypePassword


type LoginPageMsg
    = LoginPageFieldChange LoginFieldType String
    | LoginPageSubmit


type FrontendMsg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url.Url
    | Shared Evergreen.V6.Shared.Msg
    | Page Evergreen.V6.Gen.Pages.Msg
    | FrontendMsgFieldUpdate FieldType String
    | FrontendMsgAdminRequestModel
    | FrontendMsgAddUser String String
    | FrontendMsgRemoveUser String
    | FrontendMsgAdminChangePassword String String
    | FrontendMsgUserChangePassword
        { oldPassword : String
        , newPassword : String
        , newPassword2 : String
        }
    | LoginPageMsg LoginPageMsg
    | InputJsonButtonPressed
    | ViewAsJsonButtonPressed
    | LogoutButtonPressed
    | RouteButtonClicked Evergreen.V6.Route.RouteId
    | EditRouteEnable Evergreen.V6.Route.RouteId
    | EditRouteSave Evergreen.V6.Route.RouteData
    | EditRouteRemove Evergreen.V6.Route.RouteId
    | EditRouteDiscardChanges Evergreen.V6.Route.RouteId
    | EditRouteUpdated Evergreen.V6.Route.RouteIdOrNew String String
    | JsonInputTextChanged String
    | FrontendMsgConfirmButtonPressed
    | JsonInputSubmitButtonPressed
    | FrontendMsgGoToPage Page
    | NewRouteButtonPressed
    | WishlistButtonPressed
    | LogButtonPressed
    | ViewAllButtonPressed
    | MoreOptionsButtonPressed
    | CreateNewRoute
    | SetCurrentDate Date.Date
    | DatePickerUpdate Evergreen.V6.Route.RouteIdOrNew DatePicker.ChangeEvent
    | SendRefreshSessionToBackend Time.Posix
    | NoOpFrontendMsg


type alias ToBackend =
    Evergreen.V6.Bridge.ToBackend


type alias BackendMsg =
    Evergreen.V6.BackendMsg.BackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List Evergreen.V6.Route.RouteData)
    | ToFrontendUserNewPasswordAccepted
    | ToFrontendUserNewPasswordRejected
    | ToFrontendYouAreAdmin
    | ToFrontendAdminWholeModel Evergreen.V6.BackupModel.BackupModel
    | ToFrontendWrongUserNamePassword
    | ToFrontendYourNotLoggedIn
    | NoOpToFrontend
