module Evergreen.V3.Types exposing (..)

import Browser
import Browser.Navigation
import Date
import DatePicker
import Dict
import Evergreen.V3.BackendMsg
import Evergreen.V3.Route
import Gallery
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
    , galleryState : Gallery.State
    , route : Evergreen.V3.Route.RouteDataEdit
    }


type ViewFilter
    = ViewAll
    | ViewLog
    | ViewWishlist


type alias JsonError =
    String


type AdminMsg
    = AddUser
        { username : String
        , password : String
        }
    | RemoveUser String
    | RequestModel
    | AdminMsgChangePassword
        { username : String
        , password : String
        }


type ToBackend
    = UpdateRoute Evergreen.V3.Route.RouteData
    | RemoveRoute Evergreen.V3.Route.RouteId
    | ToBackendCreateNewRoute Evergreen.V3.Route.NewRouteData
    | ToBackendLogOut
    | ToBackendResetRouteList (List Evergreen.V3.Route.NewRouteData)
    | ToBackendLogIn String String
    | ToBackendRefreshSession
    | ToBackendAdminMsg AdminMsg
    | ToBackendUserChangePass
        { oldPassword : String
        , newPassword : String
        }
    | NoOpToBackend


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
        { routeData : Evergreen.V3.Route.NewRouteData
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
    { key : Browser.Navigation.Key
    , message : String
    , rows : List RowData
    , currentDate : Date.Date
    , page : Page
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
    , routes : List Evergreen.V3.Route.RouteData
    , nextId : Evergreen.V3.Route.RouteId
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
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | FrontendMsgFieldUpdate FieldType String
    | FrontendMsgAdminRequestModel
    | FrontendGalleryMsg Evergreen.V3.Route.RouteId Gallery.Msg
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
    | RouteButtonClicked Evergreen.V3.Route.RouteId
    | EditRouteEnable Evergreen.V3.Route.RouteId
    | EditRouteSave Evergreen.V3.Route.RouteData
    | EditRouteRemove Evergreen.V3.Route.RouteId
    | EditRouteDiscardChanges Evergreen.V3.Route.RouteId
    | EditRouteUpdated Evergreen.V3.Route.RouteIdOrNew String String
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
    | DatePickerUpdate Evergreen.V3.Route.RouteIdOrNew DatePicker.ChangeEvent
    | SendRefreshSessionToBackend Time.Posix
    | NoOpFrontendMsg


type alias BackendMsg =
    Evergreen.V3.BackendMsg.BackendMsg


type alias BackupModel =
    List
        { username : String
        , routes : List Evergreen.V3.Route.RouteData
        }


type ToFrontend
    = AllRoutesAnnouncement (List Evergreen.V3.Route.RouteData)
    | ToFrontendUserNewPasswordAccepted
    | ToFrontendUserNewPasswordRejected
    | ToFrontendYouAreAdmin
    | ToFrontendAdminWholeModel BackupModel
    | ToFrontendWrongUserNamePassword
    | ToFrontendYourNotLoggedIn
    | NoOpToFrontend
