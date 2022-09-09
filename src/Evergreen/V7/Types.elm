module Evergreen.V7.Types exposing (..)

import Browser
import Browser.Navigation
import Date
import DatePicker
import Dict
import Evergreen.V7.BackendMsg
import Evergreen.V7.BackupModel
import Evergreen.V7.Bridge
import Evergreen.V7.Gen.Pages
import Evergreen.V7.Route
import Evergreen.V7.Shared
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V7.Shared.Model
    , page : Evergreen.V7.Gen.Pages.Model
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
    , routes : List Evergreen.V7.Route.RouteData
    , nextId : Evergreen.V7.Route.RouteId
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


type ViewFilter
    = ViewAll
    | ViewLog
    | ViewWishlist


type alias DatePickerData =
    { dateText : String
    , pickerModel : DatePicker.Model
    }


type alias JsonError =
    String


type alias ToBackend =
    Evergreen.V7.Bridge.ToBackend


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
        { routeData : Evergreen.V7.Route.NewRouteData
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


type FrontendMsg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url.Url
    | Shared Evergreen.V7.Shared.Msg
    | Page Evergreen.V7.Gen.Pages.Msg
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
    | RouteButtonClicked Evergreen.V7.Route.RouteId
    | EditRouteEnable Evergreen.V7.Route.RouteId
    | EditRouteSave Evergreen.V7.Route.RouteData
    | EditRouteRemove Evergreen.V7.Route.RouteId
    | EditRouteDiscardChanges Evergreen.V7.Route.RouteId
    | EditRouteUpdated Evergreen.V7.Route.RouteIdOrNew String String
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
    | DatePickerUpdate Evergreen.V7.Route.RouteIdOrNew DatePicker.ChangeEvent
    | SendRefreshSessionToBackend Time.Posix
    | NoOpFrontendMsg


type alias ToBackend =
    Evergreen.V7.Bridge.ToBackend


type alias BackendMsg =
    Evergreen.V7.BackendMsg.BackendMsg


type ToFrontend
    = AllRoutesAnnouncement (List Evergreen.V7.Route.RouteData)
    | ToFrontendUserNewPasswordAccepted
    | ToFrontendUserNewPasswordRejected
    | ToFrontendYouAreAdmin
    | ToFrontendAdminWholeModel Evergreen.V7.BackupModel.BackupModel
    | ToFrontendWrongUserNamePassword
    | ToFrontendYourNotLoggedIn
    | NoOpToFrontend
