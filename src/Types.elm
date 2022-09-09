module Types exposing (..)

import BackendMsg
import BackupModel
import Bridge
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Date exposing (Date)
import DatePicker
import Dict exposing (Dict)
import Gen.Pages as Pages
import Lamdera
import Route exposing (..)
import Shared
import Time
import Url exposing (Url)


type alias FrontendModel =
    { url : Url
    , key : Key
    , shared : Shared.Model
    , page : Pages.Model
    }


type Page
    = RoutePage ViewFilter
    | NewRoutePage { routeData : NewRouteData, datePickerData : DatePickerData }
    | InputJsonPage String (Maybe JsonError)
    | ConfirmPage { text : String, label : String, code : String, event : ToBackend, abortPage : Page }
    | ViewJsonPage
    | ChangePasswordPage { oldPassword : String, newPassword : String, newPassword2 : String, status : String }
    | LoginPage LoginPageData
    | MoreOptionsPage
    | SpinnerPage String
    | AdminPage AdminPage


type AdminPage
    = AdminHomePage
    | AdminInputJson
    | AdminShowJson String
    | AdminAddUser String String
    | AdminRemoveUser String
    | AdminChangePassword String String


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


type alias Password =
    String


type alias UserData =
    { username : String
    , password : Password
    , routes : List RouteData
    , nextId : RouteId
    }


type alias BackendModel =
    { sessions : Dict Lamdera.SessionId SessionData
    , users : Dict String UserData
    , currentTime : Time.Posix
    }


type alias SessionData =
    { lastTouched : Time.Posix
    , username : String
    }


type LoginFieldType
    = FieldTypeUsername
    | FieldTypePassword


type LoginPageMsg
    = LoginPageFieldChange LoginFieldType String
    | LoginPageSubmit


type FieldType
    = FieldAddUserUsername
    | FieldAddUserPassword
    | FieldRemoveUserUsername
    | FieldChangePasswordUsername
    | FieldChangePasswordPassword
    | FieldUserChangePasswordOldPass
    | FieldUserChangePasswordNewPass
    | FieldUserChangePasswordNewPass2


type FrontendMsg
    = ClickedLink UrlRequest
    | ChangedUrl Url
    | Shared Shared.Msg
    | Page Pages.Msg
    | FrontendMsgFieldUpdate FieldType String
    | FrontendMsgAdminRequestModel
    | FrontendMsgAddUser String String
    | FrontendMsgRemoveUser String
    | FrontendMsgAdminChangePassword String String
    | FrontendMsgUserChangePassword { oldPassword : String, newPassword : String, newPassword2 : String }
    | LoginPageMsg LoginPageMsg
    | InputJsonButtonPressed
    | ViewAsJsonButtonPressed
    | LogoutButtonPressed
    | RouteButtonClicked RouteId
    | EditRouteEnable RouteId
    | EditRouteSave RouteData
    | EditRouteRemove RouteId
    | EditRouteDiscardChanges RouteId
    | EditRouteUpdated RouteIdOrNew String String
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
    | SetCurrentDate Date
    | DatePickerUpdate RouteIdOrNew DatePicker.ChangeEvent
    | SendRefreshSessionToBackend Time.Posix
    | NoOpFrontendMsg


type alias ToBackend =
    Bridge.ToBackend


type alias BackendMsg =
    BackendMsg.BackendMsg



-- = ClientConnected Lamdera.SessionId Lamdera.ClientId
-- | NoOpBackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List RouteData)
    | ToFrontendUserNewPasswordAccepted
    | ToFrontendUserNewPasswordRejected
    | ToFrontendYouAreAdmin
    | ToFrontendAdminWholeModel BackupModel.BackupModel
    | ToFrontendWrongUserNamePassword
    | ToFrontendYourNotLoggedIn
    | NoOpToFrontend
