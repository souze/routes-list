module Evergreen.Migrate.V17 exposing (..)

{-| This migration file was automatically generated by the lamdera compiler.

It includes:

  - A migration for each of the 6 Lamdera core types that has changed
  - A function named `migrate_ModuleName_TypeName` for each changed/custom type

Expect to see:

  - `Unimplementеd` values as placeholders wherever I was unable to figure out a clear migration path for you
  - `@NOTICE` comments for things you should know about, i.e. new custom type constructors that won't get any
    value mappings from the old type by default

You can edit this file however you wish! It won't be generated again.

See <https://dashboard.lamdera.com/docs/evergreen> for more info.

-}

import Date
import DatePicker
import Dict
import Evergreen.V14.BackupModel
import Evergreen.V14.Bridge
import Evergreen.V14.ConfirmComponent
import Evergreen.V14.Filter
import Evergreen.V14.FormDict
import Evergreen.V14.Gen.Model
import Evergreen.V14.Gen.Msg
import Evergreen.V14.Gen.Pages
import Evergreen.V14.Gen.Params.Routes.Filter_
import Evergreen.V14.Gen.Params.SignIn.SignInDest_
import Evergreen.V14.Pages.Admin.AddUser
import Evergreen.V14.Pages.Admin.ChangePassword
import Evergreen.V14.Pages.Admin.Home_
import Evergreen.V14.Pages.Admin.RemoveUser
import Evergreen.V14.Pages.Admin.ShowJson
import Evergreen.V14.Pages.ChangePassword
import Evergreen.V14.Pages.Home_
import Evergreen.V14.Pages.InputJson
import Evergreen.V14.Pages.MoreOptions
import Evergreen.V14.Pages.NewRoute
import Evergreen.V14.Pages.OutputJson
import Evergreen.V14.Pages.Routes.Filter_
import Evergreen.V14.Pages.SignIn.SignInDest_
import Evergreen.V14.Pages.Stats
import Evergreen.V14.Route
import Evergreen.V14.Shared
import Evergreen.V14.Sorter
import Evergreen.V14.Types
import Evergreen.V17.BackupModel
import Evergreen.V17.Bridge
import Evergreen.V17.ConfirmComponent
import Evergreen.V17.Filter
import Evergreen.V17.FormDict
import Evergreen.V17.Gen.Model
import Evergreen.V17.Gen.Msg
import Evergreen.V17.Gen.Pages
import Evergreen.V17.Gen.Params.Routes.Filter_
import Evergreen.V17.Gen.Params.SignIn.SignInDest_
import Evergreen.V17.Pages.Admin.AddUser
import Evergreen.V17.Pages.Admin.ChangePassword
import Evergreen.V17.Pages.Admin.Home_
import Evergreen.V17.Pages.Admin.RemoveUser
import Evergreen.V17.Pages.Admin.ShowJson
import Evergreen.V17.Pages.ChangePassword
import Evergreen.V17.Pages.Home_
import Evergreen.V17.Pages.InputJson
import Evergreen.V17.Pages.MoreOptions
import Evergreen.V17.Pages.NewRoute
import Evergreen.V17.Pages.OutputJson
import Evergreen.V17.Pages.Routes.Filter_
import Evergreen.V17.Pages.SignIn.SignInDest_
import Evergreen.V17.Pages.Stats
import Evergreen.V17.Route
import Evergreen.V17.RouteEditPane
import Evergreen.V17.Shared
import Evergreen.V17.Sorter
import Evergreen.V17.Types
import Lamdera.Migrations exposing (..)
import List
import Maybe
import Route
import RouteEditPane
import Set exposing (Set)


frontendModel : Evergreen.V14.Types.FrontendModel -> ModelMigration Evergreen.V17.Types.FrontendModel Evergreen.V17.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V14.Types.BackendModel -> ModelMigration Evergreen.V17.Types.BackendModel Evergreen.V17.Types.BackendMsg
backendModel old =
    ModelMigrated ( migrate_Types_BackendModel old, Cmd.none )


frontendMsg : Evergreen.V14.Types.FrontendMsg -> MsgMigration Evergreen.V17.Types.FrontendMsg Evergreen.V17.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V14.Types.ToBackend -> MsgMigration Evergreen.V17.Types.ToBackend Evergreen.V17.Types.BackendMsg
toBackend old =
    MsgMigrated ( migrate_Types_ToBackend old, Cmd.none )


backendMsg : Evergreen.V14.Types.BackendMsg -> MsgMigration Evergreen.V17.Types.BackendMsg Evergreen.V17.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V14.Types.ToFrontend -> MsgMigration Evergreen.V17.Types.ToFrontend Evergreen.V17.Types.FrontendMsg
toFrontend old =
    MsgMigrated ( migrate_Types_ToFrontend old, Cmd.none )


migrate_Types_BackendModel : Evergreen.V14.Types.BackendModel -> Evergreen.V17.Types.BackendModel
migrate_Types_BackendModel old =
    { sessions = old.sessions
    , users = old.users |> Dict.map (\k -> migrate_Types_UserData)
    , currentTime = old.currentTime
    }


migrate_Types_FrontendModel : Evergreen.V14.Types.FrontendModel -> Evergreen.V17.Types.FrontendModel
migrate_Types_FrontendModel old =
    { url = old.url
    , key = old.key
    , shared = old.shared |> migrate_Shared_Model
    , page = old.page |> migrate_Gen_Pages_Model
    }


migrate_Types_ToBackend : Evergreen.V14.Types.ToBackend -> Evergreen.V17.Types.ToBackend
migrate_Types_ToBackend old =
    old |> migrate_Bridge_ToBackend


migrate_BackupModel_BackupModel : Evergreen.V14.BackupModel.BackupModel -> Evergreen.V17.BackupModel.BackupModel
migrate_BackupModel_BackupModel old =
    old
        |> List.map
            (\rec ->
                { username = rec.username
                , routes = rec.routes |> List.map migrate_Route_RouteData
                }
            )


migrate_Bridge_AdminMsg : Evergreen.V14.Bridge.AdminMsg -> Evergreen.V17.Bridge.AdminMsg
migrate_Bridge_AdminMsg old =
    case old of
        Evergreen.V14.Bridge.AddUser p0 ->
            Evergreen.V17.Bridge.AddUser p0

        Evergreen.V14.Bridge.RemoveUser p0 ->
            Evergreen.V17.Bridge.RemoveUser p0

        Evergreen.V14.Bridge.RequestModel ->
            Evergreen.V17.Bridge.RequestModel

        Evergreen.V14.Bridge.AdminMsgChangePassword p0 ->
            Evergreen.V17.Bridge.AdminMsgChangePassword p0


migrate_Bridge_ToBackend : Evergreen.V14.Bridge.ToBackend -> Evergreen.V17.Bridge.ToBackend
migrate_Bridge_ToBackend old =
    case old of
        Evergreen.V14.Bridge.UpdateRoute p0 ->
            Evergreen.V17.Bridge.UpdateRoute (p0 |> migrate_Route_RouteData)

        Evergreen.V14.Bridge.RemoveRoute p0 ->
            Evergreen.V17.Bridge.RemoveRoute (p0 |> migrate_Route_RouteId)

        Evergreen.V14.Bridge.ToBackendCreateNewRoute p0 ->
            Evergreen.V17.Bridge.ToBackendCreateNewRoute (p0 |> migrate_Route_NewRouteData)

        Evergreen.V14.Bridge.ToBackendLogOut ->
            Evergreen.V17.Bridge.ToBackendLogOut

        Evergreen.V14.Bridge.ToBackendResetRouteList p0 ->
            Evergreen.V17.Bridge.ToBackendResetRouteList (p0 |> List.map migrate_Route_NewRouteData)

        Evergreen.V14.Bridge.ToBackendLogIn p0 p1 ->
            Evergreen.V17.Bridge.ToBackendLogIn p0 p1

        Evergreen.V14.Bridge.ToBackendRefreshSession ->
            Evergreen.V17.Bridge.ToBackendRefreshSession

        Evergreen.V14.Bridge.ToBackendAdminMsg p0 ->
            Evergreen.V17.Bridge.ToBackendAdminMsg (p0 |> migrate_Bridge_AdminMsg)

        Evergreen.V14.Bridge.ToBackendUserChangePass p0 ->
            Evergreen.V17.Bridge.ToBackendUserChangePass p0

        Evergreen.V14.Bridge.NoOpToBackend ->
            Evergreen.V17.Bridge.NoOpToBackend


migrate_ConfirmComponent_Msg : Evergreen.V14.ConfirmComponent.Msg -> Evergreen.V17.ConfirmComponent.Msg
migrate_ConfirmComponent_Msg old =
    case old of
        Evergreen.V14.ConfirmComponent.ConfirmCompTextChange p0 ->
            Evergreen.V17.ConfirmComponent.ConfirmCompTextChange p0

        Evergreen.V14.ConfirmComponent.FirstButtonPressed ->
            Evergreen.V17.ConfirmComponent.FirstButtonPressed


migrate_ConfirmComponent_State : Evergreen.V14.ConfirmComponent.State -> Evergreen.V17.ConfirmComponent.State
migrate_ConfirmComponent_State old =
    case old of
        Evergreen.V14.ConfirmComponent.Waiting ->
            Evergreen.V17.ConfirmComponent.Waiting

        Evergreen.V14.ConfirmComponent.Active p0 ->
            Evergreen.V17.ConfirmComponent.Active p0


migrate_Filter_Model : Evergreen.V14.Filter.Model -> Evergreen.V17.Filter.Model
migrate_Filter_Model old =
    { grade = old.grade
    , type_ = Set.empty
    , tickdate = old.tickdate |> migrate_Filter_TickDateFilter
    }


migrate_Filter_Msg : Evergreen.V14.Filter.Msg -> Evergreen.V17.Filter.Msg
migrate_Filter_Msg old =
    case old of
        Evergreen.V14.Filter.PressedGradeFilter p0 ->
            Evergreen.V17.Filter.PressedGradeFilter ""

        Evergreen.V14.Filter.PressedTickdateFilter ->
            Evergreen.V17.Filter.PressedTickdateFilter


migrate_Filter_TickDateFilter : Evergreen.V14.Filter.TickDateFilter -> Evergreen.V17.Filter.TickDateFilter
migrate_Filter_TickDateFilter old =
    case old of
        Evergreen.V14.Filter.TickdateRangeFrom ->
            Evergreen.V17.Filter.TickdateRangeFrom

        Evergreen.V14.Filter.TickdateRangeTo ->
            Evergreen.V17.Filter.TickdateRangeTo

        Evergreen.V14.Filter.TickdateRangeBetween ->
            Evergreen.V17.Filter.TickdateRangeBetween

        Evergreen.V14.Filter.ShowHasTickdate ->
            Evergreen.V17.Filter.ShowHasTickdate

        Evergreen.V14.Filter.ShowWithoutTickdate ->
            Evergreen.V17.Filter.ShowWithoutTickdate

        Evergreen.V14.Filter.ShowAllTickdates ->
            Evergreen.V17.Filter.ShowAllTickdates


migrate_FormDict_FormDict : Evergreen.V14.FormDict.FormDict -> Evergreen.V17.FormDict.FormDict
migrate_FormDict_FormDict old =
    case old of
        Evergreen.V14.FormDict.FormDict p0 ->
            Evergreen.V17.FormDict.FormDict p0


migrate_Gen_Model_Model : Evergreen.V14.Gen.Model.Model -> Evergreen.V17.Gen.Model.Model
migrate_Gen_Model_Model old =
    case old of
        Evergreen.V14.Gen.Model.Redirecting_ ->
            Evergreen.V17.Gen.Model.Redirecting_

        Evergreen.V14.Gen.Model.ChangePassword p0 p1 ->
            Evergreen.V17.Gen.Model.ChangePassword p0 (p1 |> migrate_Pages_ChangePassword_Model)

        Evergreen.V14.Gen.Model.Home_ p0 p1 ->
            Evergreen.V17.Gen.Model.Home_ p0 (p1 |> migrate_Pages_Home__Model)

        Evergreen.V14.Gen.Model.InputJson p0 p1 ->
            Evergreen.V17.Gen.Model.InputJson p0 (p1 |> migrate_Pages_InputJson_Model)

        Evergreen.V14.Gen.Model.MoreOptions p0 p1 ->
            Evergreen.V17.Gen.Model.MoreOptions p0 (p1 |> migrate_Pages_MoreOptions_Model)

        Evergreen.V14.Gen.Model.NewRoute p0 p1 ->
            Evergreen.V17.Gen.Model.NewRoute p0 (p1 |> migrate_Pages_NewRoute_Model)

        Evergreen.V14.Gen.Model.OutputJson p0 p1 ->
            Evergreen.V17.Gen.Model.OutputJson p0 (p1 |> migrate_Pages_OutputJson_Model)

        Evergreen.V14.Gen.Model.Stats p0 p1 ->
            Evergreen.V17.Gen.Model.Stats p0 (p1 |> migrate_Pages_Stats_Model)

        Evergreen.V14.Gen.Model.Admin__AddUser p0 p1 ->
            Evergreen.V17.Gen.Model.Admin__AddUser p0 (p1 |> migrate_Pages_Admin_AddUser_Model)

        Evergreen.V14.Gen.Model.Admin__ChangePassword p0 p1 ->
            Evergreen.V17.Gen.Model.Admin__ChangePassword p0
                (p1 |> migrate_Pages_Admin_ChangePassword_Model)

        Evergreen.V14.Gen.Model.Admin__Home_ p0 p1 ->
            Evergreen.V17.Gen.Model.Admin__Home_ p0 (p1 |> migrate_Pages_Admin_Home__Model)

        Evergreen.V14.Gen.Model.Admin__RemoveUser p0 p1 ->
            Evergreen.V17.Gen.Model.Admin__RemoveUser p0 (p1 |> migrate_Pages_Admin_RemoveUser_Model)

        Evergreen.V14.Gen.Model.Admin__ShowJson p0 p1 ->
            Evergreen.V17.Gen.Model.Admin__ShowJson p0 (p1 |> migrate_Pages_Admin_ShowJson_Model)

        Evergreen.V14.Gen.Model.Routes__Filter_ p0 p1 ->
            Evergreen.V17.Gen.Model.Routes__Filter_ (p0 |> migrate_Gen_Params_Routes_Filter__Params)
                (p1 |> migrate_Pages_Routes_Filter__Model)

        Evergreen.V14.Gen.Model.SignIn__SignInDest_ p0 p1 ->
            Evergreen.V17.Gen.Model.SignIn__SignInDest_ (p0 |> migrate_Gen_Params_SignIn_SignInDest__Params)
                (p1 |> migrate_Pages_SignIn_SignInDest__Model)

        Evergreen.V14.Gen.Model.NotFound p0 ->
            Evergreen.V17.Gen.Model.NotFound p0


migrate_Gen_Msg_Msg : Evergreen.V14.Gen.Msg.Msg -> Evergreen.V17.Gen.Msg.Msg
migrate_Gen_Msg_Msg old =
    case old of
        Evergreen.V14.Gen.Msg.ChangePassword p0 ->
            Evergreen.V17.Gen.Msg.ChangePassword (p0 |> migrate_Pages_ChangePassword_Msg)

        Evergreen.V14.Gen.Msg.Home_ p0 ->
            Evergreen.V17.Gen.Msg.Home_ (p0 |> migrate_Pages_Home__Msg)

        Evergreen.V14.Gen.Msg.InputJson p0 ->
            Evergreen.V17.Gen.Msg.InputJson (p0 |> migrate_Pages_InputJson_Msg)

        Evergreen.V14.Gen.Msg.MoreOptions p0 ->
            Evergreen.V17.Gen.Msg.MoreOptions (p0 |> migrate_Pages_MoreOptions_Msg)

        Evergreen.V14.Gen.Msg.NewRoute p0 ->
            Evergreen.V17.Gen.Msg.NewRoute (p0 |> migrate_Pages_NewRoute_Msg)

        Evergreen.V14.Gen.Msg.OutputJson p0 ->
            Evergreen.V17.Gen.Msg.OutputJson (p0 |> migrate_Pages_OutputJson_Msg)

        Evergreen.V14.Gen.Msg.Stats p0 ->
            Evergreen.V17.Gen.Msg.Stats (p0 |> migrate_Pages_Stats_Msg)

        Evergreen.V14.Gen.Msg.Admin__AddUser p0 ->
            Evergreen.V17.Gen.Msg.Admin__AddUser (p0 |> migrate_Pages_Admin_AddUser_Msg)

        Evergreen.V14.Gen.Msg.Admin__ChangePassword p0 ->
            Evergreen.V17.Gen.Msg.Admin__ChangePassword (p0 |> migrate_Pages_Admin_ChangePassword_Msg)

        Evergreen.V14.Gen.Msg.Admin__Home_ p0 ->
            Evergreen.V17.Gen.Msg.Admin__Home_ (p0 |> migrate_Pages_Admin_Home__Msg)

        Evergreen.V14.Gen.Msg.Admin__RemoveUser p0 ->
            Evergreen.V17.Gen.Msg.Admin__RemoveUser (p0 |> migrate_Pages_Admin_RemoveUser_Msg)

        Evergreen.V14.Gen.Msg.Admin__ShowJson p0 ->
            Evergreen.V17.Gen.Msg.Admin__ShowJson (p0 |> migrate_Pages_Admin_ShowJson_Msg)

        Evergreen.V14.Gen.Msg.Routes__Filter_ p0 ->
            Evergreen.V17.Gen.Msg.Routes__Filter_ (p0 |> migrate_Pages_Routes_Filter__Msg)

        Evergreen.V14.Gen.Msg.SignIn__SignInDest_ p0 ->
            Evergreen.V17.Gen.Msg.SignIn__SignInDest_ (p0 |> migrate_Pages_SignIn_SignInDest__Msg)


migrate_Gen_Pages_Model : Evergreen.V14.Gen.Pages.Model -> Evergreen.V17.Gen.Pages.Model
migrate_Gen_Pages_Model old =
    old |> migrate_Gen_Model_Model


migrate_Gen_Pages_Msg : Evergreen.V14.Gen.Pages.Msg -> Evergreen.V17.Gen.Pages.Msg
migrate_Gen_Pages_Msg old =
    old |> migrate_Gen_Msg_Msg


migrate_Gen_Params_Routes_Filter__Params : Evergreen.V14.Gen.Params.Routes.Filter_.Params -> Evergreen.V17.Gen.Params.Routes.Filter_.Params
migrate_Gen_Params_Routes_Filter__Params old =
    old


migrate_Gen_Params_SignIn_SignInDest__Params : Evergreen.V14.Gen.Params.SignIn.SignInDest_.Params -> Evergreen.V17.Gen.Params.SignIn.SignInDest_.Params
migrate_Gen_Params_SignIn_SignInDest__Params old =
    old


migrate_Pages_Admin_AddUser_Model : Evergreen.V14.Pages.Admin.AddUser.Model -> Evergreen.V17.Pages.Admin.AddUser.Model
migrate_Pages_Admin_AddUser_Model old =
    { form = old.form |> migrate_FormDict_FormDict
    }


migrate_Pages_Admin_AddUser_Msg : Evergreen.V14.Pages.Admin.AddUser.Msg -> Evergreen.V17.Pages.Admin.AddUser.Msg
migrate_Pages_Admin_AddUser_Msg old =
    case old of
        Evergreen.V14.Pages.Admin.AddUser.FieldUpdate p0 p1 ->
            Evergreen.V17.Pages.Admin.AddUser.FieldUpdate p0 p1

        Evergreen.V14.Pages.Admin.AddUser.CreateUser ->
            Evergreen.V17.Pages.Admin.AddUser.CreateUser


migrate_Pages_Admin_ChangePassword_Model : Evergreen.V14.Pages.Admin.ChangePassword.Model -> Evergreen.V17.Pages.Admin.ChangePassword.Model
migrate_Pages_Admin_ChangePassword_Model old =
    { form = old.form |> migrate_FormDict_FormDict
    }


migrate_Pages_Admin_ChangePassword_Msg : Evergreen.V14.Pages.Admin.ChangePassword.Msg -> Evergreen.V17.Pages.Admin.ChangePassword.Msg
migrate_Pages_Admin_ChangePassword_Msg old =
    case old of
        Evergreen.V14.Pages.Admin.ChangePassword.FieldUpdate p0 p1 ->
            Evergreen.V17.Pages.Admin.ChangePassword.FieldUpdate p0 p1

        Evergreen.V14.Pages.Admin.ChangePassword.ChangePassword ->
            Evergreen.V17.Pages.Admin.ChangePassword.ChangePassword


migrate_Pages_Admin_Home__Model : Evergreen.V14.Pages.Admin.Home_.Model -> Evergreen.V17.Pages.Admin.Home_.Model
migrate_Pages_Admin_Home__Model old =
    old


migrate_Pages_Admin_Home__Msg : Evergreen.V14.Pages.Admin.Home_.Msg -> Evergreen.V17.Pages.Admin.Home_.Msg
migrate_Pages_Admin_Home__Msg old =
    case old of
        Evergreen.V14.Pages.Admin.Home_.LogOut ->
            Evergreen.V17.Pages.Admin.Home_.LogOut


migrate_Pages_Admin_RemoveUser_Model : Evergreen.V14.Pages.Admin.RemoveUser.Model -> Evergreen.V17.Pages.Admin.RemoveUser.Model
migrate_Pages_Admin_RemoveUser_Model old =
    old


migrate_Pages_Admin_RemoveUser_Msg : Evergreen.V14.Pages.Admin.RemoveUser.Msg -> Evergreen.V17.Pages.Admin.RemoveUser.Msg
migrate_Pages_Admin_RemoveUser_Msg old =
    case old of
        Evergreen.V14.Pages.Admin.RemoveUser.FieldUpdate p0 ->
            Evergreen.V17.Pages.Admin.RemoveUser.FieldUpdate p0

        Evergreen.V14.Pages.Admin.RemoveUser.RemoveUser ->
            Evergreen.V17.Pages.Admin.RemoveUser.RemoveUser


migrate_Pages_Admin_ShowJson_Model : Evergreen.V14.Pages.Admin.ShowJson.Model -> Evergreen.V17.Pages.Admin.ShowJson.Model
migrate_Pages_Admin_ShowJson_Model old =
    old


migrate_Pages_Admin_ShowJson_Msg : Evergreen.V14.Pages.Admin.ShowJson.Msg -> Evergreen.V17.Pages.Admin.ShowJson.Msg
migrate_Pages_Admin_ShowJson_Msg old =
    case old of
        Evergreen.V14.Pages.Admin.ShowJson.BackupModelFromBackend p0 ->
            Evergreen.V17.Pages.Admin.ShowJson.BackupModelFromBackend (p0 |> migrate_BackupModel_BackupModel)


migrate_Pages_ChangePassword_Model : Evergreen.V14.Pages.ChangePassword.Model -> Evergreen.V17.Pages.ChangePassword.Model
migrate_Pages_ChangePassword_Model old =
    old


migrate_Pages_ChangePassword_Msg : Evergreen.V14.Pages.ChangePassword.Msg -> Evergreen.V17.Pages.ChangePassword.Msg
migrate_Pages_ChangePassword_Msg old =
    case old of
        Evergreen.V14.Pages.ChangePassword.FieldUpdate p0 p1 ->
            Evergreen.V17.Pages.ChangePassword.FieldUpdate p0 p1

        Evergreen.V14.Pages.ChangePassword.ChangePassword ->
            Evergreen.V17.Pages.ChangePassword.ChangePassword


migrate_Pages_Home__Model : Evergreen.V14.Pages.Home_.Model -> Evergreen.V17.Pages.Home_.Model
migrate_Pages_Home__Model old =
    old


migrate_Pages_Home__Msg : Evergreen.V14.Pages.Home_.Msg -> Evergreen.V17.Pages.Home_.Msg
migrate_Pages_Home__Msg old =
    case old of
        Evergreen.V14.Pages.Home_.ReplaceMe ->
            Evergreen.V17.Pages.Home_.ReplaceMe


migrate_Pages_InputJson_Model : Evergreen.V14.Pages.InputJson.Model -> Evergreen.V17.Pages.InputJson.Model
migrate_Pages_InputJson_Model old =
    { text = old.text
    , statusText = old.statusText
    , parsedRoutes = old.parsedRoutes |> Maybe.map (List.map migrate_Route_NewRouteData)
    , confirmState = old.confirmState |> migrate_ConfirmComponent_State
    }


migrate_Pages_InputJson_Msg : Evergreen.V14.Pages.InputJson.Msg -> Evergreen.V17.Pages.InputJson.Msg
migrate_Pages_InputJson_Msg old =
    case old of
        Evergreen.V14.Pages.InputJson.TextChanged p0 ->
            Evergreen.V17.Pages.InputJson.TextChanged p0

        Evergreen.V14.Pages.InputJson.SubmitToBackend p0 ->
            Evergreen.V17.Pages.InputJson.SubmitToBackend (p0 |> List.map migrate_Route_NewRouteData)

        Evergreen.V14.Pages.InputJson.ConfirmComponentEvent p0 ->
            Evergreen.V17.Pages.InputJson.ConfirmComponentEvent (p0 |> migrate_ConfirmComponent_Msg)


migrate_Pages_MoreOptions_Model : Evergreen.V14.Pages.MoreOptions.Model -> Evergreen.V17.Pages.MoreOptions.Model
migrate_Pages_MoreOptions_Model old =
    old


migrate_Pages_MoreOptions_Msg : Evergreen.V14.Pages.MoreOptions.Msg -> Evergreen.V17.Pages.MoreOptions.Msg
migrate_Pages_MoreOptions_Msg old =
    case old of
        Evergreen.V14.Pages.MoreOptions.Logout ->
            Evergreen.V17.Pages.MoreOptions.Logout


migrate_Pages_NewRoute_Model : Evergreen.V14.Pages.NewRoute.Model -> Evergreen.V17.Pages.NewRoute.Model
migrate_Pages_NewRoute_Model old =
    { newRouteData =
        { route = migrate_Route_NewRouteData old.route
        , datePickerModel = DatePicker.initWithToday (Date.fromRataDie 1)
        , datePickerText = ""
        }
    }


migrate_Pages_NewRoute_Msg : Evergreen.V14.Pages.NewRoute.Msg -> Evergreen.V17.Pages.NewRoute.Msg
migrate_Pages_NewRoute_Msg old =
    case old of
        Evergreen.V14.Pages.NewRoute.FieldUpdated p0 p1 ->
            Evergreen.V17.Pages.NewRoute.RouteEditMsg (Evergreen.V17.RouteEditPane.FieldUpdated "" "")

        Evergreen.V14.Pages.NewRoute.DatePickerUpdate p0 ->
            Evergreen.V17.Pages.NewRoute.RouteEditMsg (Evergreen.V17.RouteEditPane.FieldUpdated "" "")

        Evergreen.V14.Pages.NewRoute.CreateRoute ->
            Evergreen.V17.Pages.NewRoute.CreateRoute


migrate_Pages_OutputJson_Model : Evergreen.V14.Pages.OutputJson.Model -> Evergreen.V17.Pages.OutputJson.Model
migrate_Pages_OutputJson_Model old =
    old


migrate_Pages_OutputJson_Msg : Evergreen.V14.Pages.OutputJson.Msg -> Evergreen.V17.Pages.OutputJson.Msg
migrate_Pages_OutputJson_Msg old =
    case old of
        Evergreen.V14.Pages.OutputJson.NoOp ->
            Evergreen.V17.Pages.OutputJson.NoOp


migrate_Pages_Routes_Filter__ButtonId : Evergreen.V14.Pages.Routes.Filter_.ButtonId -> Evergreen.V17.Pages.Routes.Filter_.ButtonId
migrate_Pages_Routes_Filter__ButtonId old =
    case old of
        Evergreen.V14.Pages.Routes.Filter_.ExpandRouteButton p0 ->
            Evergreen.V17.Pages.Routes.Filter_.ExpandRouteButton (p0 |> migrate_Route_RouteId)

        Evergreen.V14.Pages.Routes.Filter_.EditRouteButton p0 ->
            Evergreen.V17.Pages.Routes.Filter_.EditRouteButton (p0 |> migrate_Route_RouteData)

        Evergreen.V14.Pages.Routes.Filter_.SaveButton p0 ->
            Evergreen.V17.Pages.Routes.Filter_.SaveButton (p0 |> migrate_Route_RouteData)

        Evergreen.V14.Pages.Routes.Filter_.DiscardButton p0 ->
            Evergreen.V17.Pages.Routes.Filter_.DiscardButton (p0 |> migrate_Route_RouteId)

        Evergreen.V14.Pages.Routes.Filter_.RemoveButton p0 ->
            Evergreen.V17.Pages.Routes.Filter_.RemoveButton (p0 |> migrate_Route_RouteId)

        Evergreen.V14.Pages.Routes.Filter_.CreateButton ->
            Evergreen.V17.Pages.Routes.Filter_.CreateButton


migrate_Pages_Routes_Filter__Filter : Evergreen.V14.Pages.Routes.Filter_.Filter -> Evergreen.V17.Pages.Routes.Filter_.Filter
migrate_Pages_Routes_Filter__Filter old =
    { filter = old.filter |> migrate_Filter_Model
    , sorter = old.sorter |> migrate_Sorter_Model
    }


migrate_Pages_Routes_Filter__Metadata : Int -> Evergreen.V14.Pages.Routes.Filter_.Metadata -> Evergreen.V17.Pages.Routes.Filter_.Metadata
migrate_Pages_Routes_Filter__Metadata routeId old =
    { expanded = old.expanded
    , routeId = Evergreen.V17.Route.RouteId routeId
    , editRoute = old.editRoute |> Maybe.map migrate_RouteEditPane_Model
    }


migrate_Pages_Routes_Filter__Model : Evergreen.V14.Pages.Routes.Filter_.Model -> Evergreen.V17.Pages.Routes.Filter_.Model
migrate_Pages_Routes_Filter__Model old =
    { filter = old.filter |> migrate_Pages_Routes_Filter__Filter
    , showSortBox = old.showSortBox
    , currentDate = Date.fromRataDie 1
    , metadatas = old.metadatas |> Dict.map migrate_Pages_Routes_Filter__Metadata
    }


migrate_Pages_Routes_Filter__Msg : Evergreen.V14.Pages.Routes.Filter_.Msg -> Evergreen.V17.Pages.Routes.Filter_.Msg
migrate_Pages_Routes_Filter__Msg old =
    case old of
        Evergreen.V14.Pages.Routes.Filter_.ToggleFilters ->
            Evergreen.V17.Pages.Routes.Filter_.ToggleFilters

        Evergreen.V14.Pages.Routes.Filter_.ButtonPressed p0 ->
            Evergreen.V17.Pages.Routes.Filter_.ButtonPressed (p0 |> migrate_Pages_Routes_Filter__ButtonId)

        Evergreen.V14.Pages.Routes.Filter_.FieldUpdated p0 p1 p2 ->
            Evergreen.V17.Pages.Routes.Filter_.ToggleFilters

        Evergreen.V14.Pages.Routes.Filter_.DatePickerUpdate p0 p1 ->
            Evergreen.V17.Pages.Routes.Filter_.ToggleFilters

        Evergreen.V14.Pages.Routes.Filter_.SortSelected p0 ->
            Evergreen.V17.Pages.Routes.Filter_.SortSelected (p0 |> migrate_Sorter_SorterMsg)

        Evergreen.V14.Pages.Routes.Filter_.FilterMsg p0 ->
            Evergreen.V17.Pages.Routes.Filter_.FilterMsg (p0 |> migrate_Filter_Msg)


migrate_Pages_SignIn_SignInDest__Model : Evergreen.V14.Pages.SignIn.SignInDest_.Model -> Evergreen.V17.Pages.SignIn.SignInDest_.Model
migrate_Pages_SignIn_SignInDest__Model old =
    old


migrate_Pages_SignIn_SignInDest__Msg : Evergreen.V14.Pages.SignIn.SignInDest_.Msg -> Evergreen.V17.Pages.SignIn.SignInDest_.Msg
migrate_Pages_SignIn_SignInDest__Msg old =
    case old of
        Evergreen.V14.Pages.SignIn.SignInDest_.ClickedSignIn ->
            Evergreen.V17.Pages.SignIn.SignInDest_.ClickedSignIn

        Evergreen.V14.Pages.SignIn.SignInDest_.FieldChanged p0 p1 ->
            Evergreen.V17.Pages.SignIn.SignInDest_.FieldChanged p0 p1


migrate_Pages_Stats_Model : Evergreen.V14.Pages.Stats.Model -> Evergreen.V17.Pages.Stats.Model
migrate_Pages_Stats_Model old =
    old


migrate_Pages_Stats_Msg : Evergreen.V14.Pages.Stats.Msg -> Evergreen.V17.Pages.Stats.Msg
migrate_Pages_Stats_Msg old =
    case old of
        Evergreen.V14.Pages.Stats.ReplaceMe ->
            Evergreen.V17.Pages.Stats.ReplaceMe


newRouteDataFromExisting : Evergreen.V17.Route.RouteData -> Evergreen.V17.Route.NewRouteData
newRouteDataFromExisting r =
    { name = r.name
    , area = r.area
    , grade = r.grade
    , notes = r.notes
    , tickDate2 = r.tickDate2
    , type_ = r.type_
    , images = r.images
    , videos = r.videos
    }


migrate_RouteEditPane_Model : Evergreen.V14.Route.RouteData -> Evergreen.V17.RouteEditPane.Model
migrate_RouteEditPane_Model old =
    { route = newRouteDataFromExisting (migrate_Route_RouteData old)
    , datePickerModel = DatePicker.init
    , datePickerText = ""
    }


migrate_Route_ClimbType : Evergreen.V14.Route.ClimbType -> Evergreen.V17.Route.ClimbType
migrate_Route_ClimbType old =
    case old of
        Evergreen.V14.Route.Trad ->
            Evergreen.V17.Route.Trad

        Evergreen.V14.Route.Sport ->
            Evergreen.V17.Route.Sport

        Evergreen.V14.Route.Boulder ->
            Evergreen.V17.Route.Boulder

        Evergreen.V14.Route.Mix ->
            Evergreen.V17.Route.Mix


migrate_Route_NewRouteData : Evergreen.V14.Route.NewRouteData -> Evergreen.V17.Route.NewRouteData
migrate_Route_NewRouteData old =
    { name = old.name
    , area = old.area
    , grade = old.grade
    , notes = old.notes
    , tickDate2 = old.tickDate2
    , type_ = old.type_ |> migrate_Route_ClimbType
    , images = old.images
    , videos = old.videos
    }


migrate_Route_RouteData : Evergreen.V14.Route.RouteData -> Evergreen.V17.Route.RouteData
migrate_Route_RouteData old =
    { name = old.name
    , area = old.area
    , grade = old.grade
    , notes = old.notes
    , tickDate2 = old.tickDate2
    , type_ = old.type_ |> migrate_Route_ClimbType
    , images = old.images
    , videos = old.videos
    , id = old.id |> migrate_Route_RouteId
    }


migrate_Route_RouteId : Evergreen.V14.Route.RouteId -> Evergreen.V17.Route.RouteId
migrate_Route_RouteId old =
    case old of
        Evergreen.V14.Route.RouteId p0 ->
            Evergreen.V17.Route.RouteId p0


migrate_Shared_Model : Evergreen.V14.Shared.Model -> Evergreen.V17.Shared.Model
migrate_Shared_Model old =
    { routes = old.routes |> List.map migrate_Route_RouteData
    , user = old.user |> Maybe.map migrate_Shared_User
    , currentDate = old.currentDate
    }


migrate_Shared_Msg : Evergreen.V14.Shared.Msg -> Evergreen.V17.Shared.Msg
migrate_Shared_Msg old =
    case old of
        Evergreen.V14.Shared.Noop ->
            Evergreen.V17.Shared.Noop

        Evergreen.V14.Shared.MsgFromBackend p0 ->
            Evergreen.V17.Shared.MsgFromBackend (p0 |> migrate_Shared_SharedFromBackend)

        Evergreen.V14.Shared.SetCurrentDate p0 ->
            Evergreen.V17.Shared.SetCurrentDate p0


migrate_Shared_SharedFromBackend : Evergreen.V14.Shared.SharedFromBackend -> Evergreen.V17.Shared.SharedFromBackend
migrate_Shared_SharedFromBackend old =
    case old of
        Evergreen.V14.Shared.AllRoutesAnnouncement p0 ->
            Evergreen.V17.Shared.AllRoutesAnnouncement (p0 |> List.map migrate_Route_RouteData)

        Evergreen.V14.Shared.LogOut ->
            Evergreen.V17.Shared.LogOut

        Evergreen.V14.Shared.YouAreAdmin ->
            Evergreen.V17.Shared.YouAreAdmin


migrate_Shared_User : Evergreen.V14.Shared.User -> Evergreen.V17.Shared.User
migrate_Shared_User old =
    case old of
        Evergreen.V14.Shared.NormalUser ->
            Evergreen.V17.Shared.NormalUser

        Evergreen.V14.Shared.AdminUser ->
            Evergreen.V17.Shared.AdminUser


migrate_Sorter_Model : Evergreen.V14.Sorter.Model -> Evergreen.V17.Sorter.Model
migrate_Sorter_Model old =
    old |> List.map (Tuple.mapBoth migrate_Sorter_SortAttribute migrate_Sorter_SortOrder)


migrate_Sorter_SortAttribute : Evergreen.V14.Sorter.SortAttribute -> Evergreen.V17.Sorter.SortAttribute
migrate_Sorter_SortAttribute old =
    case old of
        Evergreen.V14.Sorter.Area ->
            Evergreen.V17.Sorter.Area

        Evergreen.V14.Sorter.Grade ->
            Evergreen.V17.Sorter.Grade

        Evergreen.V14.Sorter.Tickdate ->
            Evergreen.V17.Sorter.Tickdate

        Evergreen.V14.Sorter.Name ->
            Evergreen.V17.Sorter.Name


migrate_Sorter_SortOrder : Evergreen.V14.Sorter.SortOrder -> Evergreen.V17.Sorter.SortOrder
migrate_Sorter_SortOrder old =
    case old of
        Evergreen.V14.Sorter.Ascending ->
            Evergreen.V17.Sorter.Ascending

        Evergreen.V14.Sorter.Descending ->
            Evergreen.V17.Sorter.Descending


migrate_Sorter_SorterMsg : Evergreen.V14.Sorter.SorterMsg -> Evergreen.V17.Sorter.SorterMsg
migrate_Sorter_SorterMsg old =
    case old of
        Evergreen.V14.Sorter.SorterMsg p0 ->
            Evergreen.V17.Sorter.SorterMsg p0

        Evergreen.V14.Sorter.RemoveRow p0 ->
            Evergreen.V17.Sorter.RemoveRow p0


migrate_Types_FrontendMsg : Evergreen.V14.Types.FrontendMsg -> Evergreen.V17.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V14.Types.ClickedLink p0 ->
            Evergreen.V17.Types.ClickedLink p0

        Evergreen.V14.Types.ChangedUrl p0 ->
            Evergreen.V17.Types.ChangedUrl p0

        Evergreen.V14.Types.Shared p0 ->
            Evergreen.V17.Types.Shared (p0 |> migrate_Shared_Msg)

        Evergreen.V14.Types.Page p0 ->
            Evergreen.V17.Types.Page (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V14.Types.NoOpFrontendMsg ->
            Evergreen.V17.Types.NoOpFrontendMsg


migrate_Types_ToFrontend : Evergreen.V14.Types.ToFrontend -> Evergreen.V17.Types.ToFrontend
migrate_Types_ToFrontend old =
    case old of
        Evergreen.V14.Types.AllRoutesAnnouncement p0 ->
            Evergreen.V17.Types.AllRoutesAnnouncement (p0 |> List.map migrate_Route_RouteData)

        Evergreen.V14.Types.ToFrontendUserNewPasswordAccepted ->
            Evergreen.V17.Types.ToFrontendUserNewPasswordAccepted

        Evergreen.V14.Types.ToFrontendUserNewPasswordRejected ->
            Evergreen.V17.Types.ToFrontendUserNewPasswordRejected

        Evergreen.V14.Types.ToFrontendYouAreAdmin ->
            Evergreen.V17.Types.ToFrontendYouAreAdmin

        Evergreen.V14.Types.ToFrontendAdminWholeModel p0 ->
            Evergreen.V17.Types.ToFrontendAdminWholeModel (p0 |> migrate_BackupModel_BackupModel)

        Evergreen.V14.Types.ToFrontendWrongUserNamePassword ->
            Evergreen.V17.Types.ToFrontendWrongUserNamePassword

        Evergreen.V14.Types.ToFrontendYourNotLoggedIn ->
            Evergreen.V17.Types.ToFrontendYourNotLoggedIn

        Evergreen.V14.Types.NoOpToFrontend ->
            Evergreen.V17.Types.NoOpToFrontend


migrate_Types_UserData : Evergreen.V14.Types.UserData -> Evergreen.V17.Types.UserData
migrate_Types_UserData old =
    { username = old.username
    , password = old.password
    , routes = old.routes |> List.map migrate_Route_RouteData
    , nextId = old.nextId |> migrate_Route_RouteId
    }
