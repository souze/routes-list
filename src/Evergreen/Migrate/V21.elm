module Evergreen.Migrate.V21 exposing (..)

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

import Dict
import Evergreen.V18.BackupModel
import Evergreen.V18.ConfirmComponent
import Evergreen.V18.Filter
import Evergreen.V18.FormDict
import Evergreen.V18.Gen.Model
import Evergreen.V18.Gen.Msg
import Evergreen.V18.Gen.Pages
import Evergreen.V18.Gen.Params.Routes.Filter_
import Evergreen.V18.Gen.Params.SignIn.SignInDest_
import Evergreen.V18.Pages.Admin.AddUser
import Evergreen.V18.Pages.Admin.ChangePassword
import Evergreen.V18.Pages.Admin.Home_
import Evergreen.V18.Pages.Admin.RemoveUser
import Evergreen.V18.Pages.Admin.ShowJson
import Evergreen.V18.Pages.ChangePassword
import Evergreen.V18.Pages.Home_
import Evergreen.V18.Pages.InputJson
import Evergreen.V18.Pages.MoreOptions
import Evergreen.V18.Pages.NewRoute
import Evergreen.V18.Pages.OutputJson
import Evergreen.V18.Pages.Routes.Filter_
import Evergreen.V18.Pages.SignIn.SignInDest_
import Evergreen.V18.Pages.Stats
import Evergreen.V18.Route
import Evergreen.V18.RouteEditPane
import Evergreen.V18.Shared
import Evergreen.V18.Sorter
import Evergreen.V18.Types
import Evergreen.V21.BackupModel
import Evergreen.V21.ConfirmComponent
import Evergreen.V21.Filter
import Evergreen.V21.FormDict
import Evergreen.V21.Gen.Model
import Evergreen.V21.Gen.Msg
import Evergreen.V21.Gen.Pages
import Evergreen.V21.Gen.Params.Routes.Filter_
import Evergreen.V21.Gen.Params.SignIn.SignInDest_
import Evergreen.V21.Pages.Admin.AddUser
import Evergreen.V21.Pages.Admin.ChangePassword
import Evergreen.V21.Pages.Admin.Home_
import Evergreen.V21.Pages.Admin.RemoveUser
import Evergreen.V21.Pages.Admin.ShowJson
import Evergreen.V21.Pages.ChangePassword
import Evergreen.V21.Pages.Home_
import Evergreen.V21.Pages.InputJson
import Evergreen.V21.Pages.MoreOptions
import Evergreen.V21.Pages.NewRoute
import Evergreen.V21.Pages.OutputJson
import Evergreen.V21.Pages.Routes.Filter_
import Evergreen.V21.Pages.SignIn.SignInDest_
import Evergreen.V21.Pages.Stats
import Evergreen.V21.Route
import Evergreen.V21.RouteEditPane
import Evergreen.V21.Shared
import Evergreen.V21.Sorter
import Evergreen.V21.Types
import Lamdera.Migrations exposing (..)
import List
import Maybe
import String


frontendModel : Evergreen.V18.Types.FrontendModel -> ModelMigration Evergreen.V21.Types.FrontendModel Evergreen.V21.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V18.Types.BackendModel -> ModelMigration Evergreen.V21.Types.BackendModel Evergreen.V21.Types.BackendMsg
backendModel old =
    ModelUnchanged


frontendMsg : Evergreen.V18.Types.FrontendMsg -> MsgMigration Evergreen.V21.Types.FrontendMsg Evergreen.V21.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V18.Types.ToBackend -> MsgMigration Evergreen.V21.Types.ToBackend Evergreen.V21.Types.BackendMsg
toBackend old =
    MsgUnchanged


backendMsg : Evergreen.V18.Types.BackendMsg -> MsgMigration Evergreen.V21.Types.BackendMsg Evergreen.V21.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V18.Types.ToFrontend -> MsgMigration Evergreen.V21.Types.ToFrontend Evergreen.V21.Types.FrontendMsg
toFrontend old =
    MsgUnchanged


migrate_Types_FrontendModel : Evergreen.V18.Types.FrontendModel -> Evergreen.V21.Types.FrontendModel
migrate_Types_FrontendModel old =
    { url = old.url
    , key = old.key
    , shared = old.shared |> migrate_Shared_Model
    , page = old.page |> migrate_Gen_Pages_Model
    }


migrate_BackupModel_BackupModel : Evergreen.V18.BackupModel.BackupModel -> Evergreen.V21.BackupModel.BackupModel
migrate_BackupModel_BackupModel old =
    old
        |> List.map
            (\rec ->
                { username = rec.username
                , routes = rec.routes |> List.map migrate_Route_RouteData
                }
            )


migrate_ConfirmComponent_Msg : Evergreen.V18.ConfirmComponent.Msg -> Evergreen.V21.ConfirmComponent.Msg
migrate_ConfirmComponent_Msg old =
    case old of
        Evergreen.V18.ConfirmComponent.ConfirmCompTextChange p0 ->
            Evergreen.V21.ConfirmComponent.ConfirmCompTextChange p0

        Evergreen.V18.ConfirmComponent.FirstButtonPressed ->
            Evergreen.V21.ConfirmComponent.FirstButtonPressed


migrate_ConfirmComponent_State : Evergreen.V18.ConfirmComponent.State -> Evergreen.V21.ConfirmComponent.State
migrate_ConfirmComponent_State old =
    case old of
        Evergreen.V18.ConfirmComponent.Waiting ->
            Evergreen.V21.ConfirmComponent.Waiting

        Evergreen.V18.ConfirmComponent.Active p0 ->
            Evergreen.V21.ConfirmComponent.Active p0


migrate_Filter_Model : Evergreen.V18.Filter.Model -> Evergreen.V21.Filter.Model
migrate_Filter_Model old =
    { grade = old.grade
    , type_ = old.type_
    , tickdate = old.tickdate |> migrate_Filter_TickDateFilter
    }


migrate_Filter_Msg : Evergreen.V18.Filter.Msg -> Evergreen.V21.Filter.Msg
migrate_Filter_Msg old =
    case old of
        Evergreen.V18.Filter.PressedGradeFilter p0 ->
            Evergreen.V21.Filter.PressedGradeFilter p0

        Evergreen.V18.Filter.PressedTickdateFilter ->
            Evergreen.V21.Filter.PressedTickdateFilter

        Evergreen.V18.Filter.PressedTypeFilter p0 ->
            Evergreen.V21.Filter.PressedTypeFilter p0


migrate_Filter_TickDateFilter : Evergreen.V18.Filter.TickDateFilter -> Evergreen.V21.Filter.TickDateFilter
migrate_Filter_TickDateFilter old =
    case old of
        Evergreen.V18.Filter.TickdateRangeFrom ->
            Evergreen.V21.Filter.TickdateRangeFrom

        Evergreen.V18.Filter.TickdateRangeTo ->
            Evergreen.V21.Filter.TickdateRangeTo

        Evergreen.V18.Filter.TickdateRangeBetween ->
            Evergreen.V21.Filter.TickdateRangeBetween

        Evergreen.V18.Filter.ShowHasTickdate ->
            Evergreen.V21.Filter.ShowHasTickdate

        Evergreen.V18.Filter.ShowWithoutTickdate ->
            Evergreen.V21.Filter.ShowWithoutTickdate

        Evergreen.V18.Filter.ShowAllTickdates ->
            Evergreen.V21.Filter.ShowAllTickdates


migrate_FormDict_FormDict : Evergreen.V18.FormDict.FormDict -> Evergreen.V21.FormDict.FormDict
migrate_FormDict_FormDict old =
    case old of
        Evergreen.V18.FormDict.FormDict p0 ->
            Evergreen.V21.FormDict.FormDict p0


migrate_Gen_Model_Model : Evergreen.V18.Gen.Model.Model -> Evergreen.V21.Gen.Model.Model
migrate_Gen_Model_Model old =
    case old of
        Evergreen.V18.Gen.Model.Redirecting_ ->
            Evergreen.V21.Gen.Model.Redirecting_

        Evergreen.V18.Gen.Model.ChangePassword p0 p1 ->
            Evergreen.V21.Gen.Model.ChangePassword p0 (p1 |> migrate_Pages_ChangePassword_Model)

        Evergreen.V18.Gen.Model.Home_ p0 p1 ->
            Evergreen.V21.Gen.Model.Home_ p0 (p1 |> migrate_Pages_Home__Model)

        Evergreen.V18.Gen.Model.InputJson p0 p1 ->
            Evergreen.V21.Gen.Model.InputJson p0 (p1 |> migrate_Pages_InputJson_Model)

        Evergreen.V18.Gen.Model.MoreOptions p0 p1 ->
            Evergreen.V21.Gen.Model.MoreOptions p0 (p1 |> migrate_Pages_MoreOptions_Model)

        Evergreen.V18.Gen.Model.NewRoute p0 p1 ->
            Evergreen.V21.Gen.Model.NewRoute p0 (p1 |> migrate_Pages_NewRoute_Model)

        Evergreen.V18.Gen.Model.OutputJson p0 p1 ->
            Evergreen.V21.Gen.Model.OutputJson p0 (p1 |> migrate_Pages_OutputJson_Model)

        Evergreen.V18.Gen.Model.Stats p0 p1 ->
            Evergreen.V21.Gen.Model.Stats p0 (p1 |> migrate_Pages_Stats_Model)

        Evergreen.V18.Gen.Model.Admin__AddUser p0 p1 ->
            Evergreen.V21.Gen.Model.Admin__AddUser p0 (p1 |> migrate_Pages_Admin_AddUser_Model)

        Evergreen.V18.Gen.Model.Admin__ChangePassword p0 p1 ->
            Evergreen.V21.Gen.Model.Admin__ChangePassword p0
                (p1 |> migrate_Pages_Admin_ChangePassword_Model)

        Evergreen.V18.Gen.Model.Admin__Home_ p0 p1 ->
            Evergreen.V21.Gen.Model.Admin__Home_ p0 (p1 |> migrate_Pages_Admin_Home__Model)

        Evergreen.V18.Gen.Model.Admin__RemoveUser p0 p1 ->
            Evergreen.V21.Gen.Model.Admin__RemoveUser p0 (p1 |> migrate_Pages_Admin_RemoveUser_Model)

        Evergreen.V18.Gen.Model.Admin__ShowJson p0 p1 ->
            Evergreen.V21.Gen.Model.Admin__ShowJson p0 (p1 |> migrate_Pages_Admin_ShowJson_Model)

        Evergreen.V18.Gen.Model.Routes__Filter_ p0 p1 ->
            Evergreen.V21.Gen.Model.Routes__Filter_ (p0 |> migrate_Gen_Params_Routes_Filter__Params)
                (p1 |> migrate_Pages_Routes_Filter__Model)

        Evergreen.V18.Gen.Model.SignIn__SignInDest_ p0 p1 ->
            Evergreen.V21.Gen.Model.SignIn__SignInDest_ (p0 |> migrate_Gen_Params_SignIn_SignInDest__Params)
                (p1 |> migrate_Pages_SignIn_SignInDest__Model)

        Evergreen.V18.Gen.Model.NotFound p0 ->
            Evergreen.V21.Gen.Model.NotFound p0


migrate_Gen_Msg_Msg : Evergreen.V18.Gen.Msg.Msg -> Evergreen.V21.Gen.Msg.Msg
migrate_Gen_Msg_Msg old =
    case old of
        Evergreen.V18.Gen.Msg.ChangePassword p0 ->
            Evergreen.V21.Gen.Msg.ChangePassword (p0 |> migrate_Pages_ChangePassword_Msg)

        Evergreen.V18.Gen.Msg.Home_ p0 ->
            Evergreen.V21.Gen.Msg.Home_ (p0 |> migrate_Pages_Home__Msg)

        Evergreen.V18.Gen.Msg.InputJson p0 ->
            Evergreen.V21.Gen.Msg.InputJson (p0 |> migrate_Pages_InputJson_Msg)

        Evergreen.V18.Gen.Msg.MoreOptions p0 ->
            Evergreen.V21.Gen.Msg.MoreOptions (p0 |> migrate_Pages_MoreOptions_Msg)

        Evergreen.V18.Gen.Msg.NewRoute p0 ->
            Evergreen.V21.Gen.Msg.NewRoute (p0 |> migrate_Pages_NewRoute_Msg)

        Evergreen.V18.Gen.Msg.OutputJson p0 ->
            Evergreen.V21.Gen.Msg.OutputJson (p0 |> migrate_Pages_OutputJson_Msg)

        Evergreen.V18.Gen.Msg.Stats p0 ->
            Evergreen.V21.Gen.Msg.Stats (p0 |> migrate_Pages_Stats_Msg)

        Evergreen.V18.Gen.Msg.Admin__AddUser p0 ->
            Evergreen.V21.Gen.Msg.Admin__AddUser (p0 |> migrate_Pages_Admin_AddUser_Msg)

        Evergreen.V18.Gen.Msg.Admin__ChangePassword p0 ->
            Evergreen.V21.Gen.Msg.Admin__ChangePassword (p0 |> migrate_Pages_Admin_ChangePassword_Msg)

        Evergreen.V18.Gen.Msg.Admin__Home_ p0 ->
            Evergreen.V21.Gen.Msg.Admin__Home_ (p0 |> migrate_Pages_Admin_Home__Msg)

        Evergreen.V18.Gen.Msg.Admin__RemoveUser p0 ->
            Evergreen.V21.Gen.Msg.Admin__RemoveUser (p0 |> migrate_Pages_Admin_RemoveUser_Msg)

        Evergreen.V18.Gen.Msg.Admin__ShowJson p0 ->
            Evergreen.V21.Gen.Msg.Admin__ShowJson (p0 |> migrate_Pages_Admin_ShowJson_Msg)

        Evergreen.V18.Gen.Msg.Routes__Filter_ p0 ->
            Evergreen.V21.Gen.Msg.Routes__Filter_ (p0 |> migrate_Pages_Routes_Filter__Msg)

        Evergreen.V18.Gen.Msg.SignIn__SignInDest_ p0 ->
            Evergreen.V21.Gen.Msg.SignIn__SignInDest_ (p0 |> migrate_Pages_SignIn_SignInDest__Msg)


migrate_Gen_Pages_Model : Evergreen.V18.Gen.Pages.Model -> Evergreen.V21.Gen.Pages.Model
migrate_Gen_Pages_Model old =
    old |> migrate_Gen_Model_Model


migrate_Gen_Pages_Msg : Evergreen.V18.Gen.Pages.Msg -> Evergreen.V21.Gen.Pages.Msg
migrate_Gen_Pages_Msg old =
    old |> migrate_Gen_Msg_Msg


migrate_Gen_Params_Routes_Filter__Params : Evergreen.V18.Gen.Params.Routes.Filter_.Params -> Evergreen.V21.Gen.Params.Routes.Filter_.Params
migrate_Gen_Params_Routes_Filter__Params old =
    old


migrate_Gen_Params_SignIn_SignInDest__Params : Evergreen.V18.Gen.Params.SignIn.SignInDest_.Params -> Evergreen.V21.Gen.Params.SignIn.SignInDest_.Params
migrate_Gen_Params_SignIn_SignInDest__Params old =
    old


migrate_Pages_Admin_AddUser_Model : Evergreen.V18.Pages.Admin.AddUser.Model -> Evergreen.V21.Pages.Admin.AddUser.Model
migrate_Pages_Admin_AddUser_Model old =
    { form = old.form |> migrate_FormDict_FormDict
    }


migrate_Pages_Admin_AddUser_Msg : Evergreen.V18.Pages.Admin.AddUser.Msg -> Evergreen.V21.Pages.Admin.AddUser.Msg
migrate_Pages_Admin_AddUser_Msg old =
    case old of
        Evergreen.V18.Pages.Admin.AddUser.FieldUpdate p0 p1 ->
            Evergreen.V21.Pages.Admin.AddUser.FieldUpdate p0 p1

        Evergreen.V18.Pages.Admin.AddUser.CreateUser ->
            Evergreen.V21.Pages.Admin.AddUser.CreateUser


migrate_Pages_Admin_ChangePassword_Model : Evergreen.V18.Pages.Admin.ChangePassword.Model -> Evergreen.V21.Pages.Admin.ChangePassword.Model
migrate_Pages_Admin_ChangePassword_Model old =
    { form = old.form |> migrate_FormDict_FormDict
    }


migrate_Pages_Admin_ChangePassword_Msg : Evergreen.V18.Pages.Admin.ChangePassword.Msg -> Evergreen.V21.Pages.Admin.ChangePassword.Msg
migrate_Pages_Admin_ChangePassword_Msg old =
    case old of
        Evergreen.V18.Pages.Admin.ChangePassword.FieldUpdate p0 p1 ->
            Evergreen.V21.Pages.Admin.ChangePassword.FieldUpdate p0 p1

        Evergreen.V18.Pages.Admin.ChangePassword.ChangePassword ->
            Evergreen.V21.Pages.Admin.ChangePassword.ChangePassword


migrate_Pages_Admin_Home__Model : Evergreen.V18.Pages.Admin.Home_.Model -> Evergreen.V21.Pages.Admin.Home_.Model
migrate_Pages_Admin_Home__Model old =
    old


migrate_Pages_Admin_Home__Msg : Evergreen.V18.Pages.Admin.Home_.Msg -> Evergreen.V21.Pages.Admin.Home_.Msg
migrate_Pages_Admin_Home__Msg old =
    case old of
        Evergreen.V18.Pages.Admin.Home_.LogOut ->
            Evergreen.V21.Pages.Admin.Home_.LogOut


migrate_Pages_Admin_RemoveUser_Model : Evergreen.V18.Pages.Admin.RemoveUser.Model -> Evergreen.V21.Pages.Admin.RemoveUser.Model
migrate_Pages_Admin_RemoveUser_Model old =
    old


migrate_Pages_Admin_RemoveUser_Msg : Evergreen.V18.Pages.Admin.RemoveUser.Msg -> Evergreen.V21.Pages.Admin.RemoveUser.Msg
migrate_Pages_Admin_RemoveUser_Msg old =
    case old of
        Evergreen.V18.Pages.Admin.RemoveUser.FieldUpdate p0 ->
            Evergreen.V21.Pages.Admin.RemoveUser.FieldUpdate p0

        Evergreen.V18.Pages.Admin.RemoveUser.RemoveUser ->
            Evergreen.V21.Pages.Admin.RemoveUser.RemoveUser


migrate_Pages_Admin_ShowJson_Model : Evergreen.V18.Pages.Admin.ShowJson.Model -> Evergreen.V21.Pages.Admin.ShowJson.Model
migrate_Pages_Admin_ShowJson_Model old =
    old


migrate_Pages_Admin_ShowJson_Msg : Evergreen.V18.Pages.Admin.ShowJson.Msg -> Evergreen.V21.Pages.Admin.ShowJson.Msg
migrate_Pages_Admin_ShowJson_Msg old =
    case old of
        Evergreen.V18.Pages.Admin.ShowJson.BackupModelFromBackend p0 ->
            Evergreen.V21.Pages.Admin.ShowJson.BackupModelFromBackend (p0 |> migrate_BackupModel_BackupModel)


migrate_Pages_ChangePassword_Model : Evergreen.V18.Pages.ChangePassword.Model -> Evergreen.V21.Pages.ChangePassword.Model
migrate_Pages_ChangePassword_Model old =
    old


migrate_Pages_ChangePassword_Msg : Evergreen.V18.Pages.ChangePassword.Msg -> Evergreen.V21.Pages.ChangePassword.Msg
migrate_Pages_ChangePassword_Msg old =
    case old of
        Evergreen.V18.Pages.ChangePassword.FieldUpdate p0 p1 ->
            Evergreen.V21.Pages.ChangePassword.FieldUpdate p0 p1

        Evergreen.V18.Pages.ChangePassword.ChangePassword ->
            Evergreen.V21.Pages.ChangePassword.ChangePassword


migrate_Pages_Home__Model : Evergreen.V18.Pages.Home_.Model -> Evergreen.V21.Pages.Home_.Model
migrate_Pages_Home__Model old =
    old


migrate_Pages_Home__Msg : Evergreen.V18.Pages.Home_.Msg -> Evergreen.V21.Pages.Home_.Msg
migrate_Pages_Home__Msg old =
    case old of
        Evergreen.V18.Pages.Home_.ReplaceMe ->
            Evergreen.V21.Pages.Home_.ReplaceMe


migrate_Pages_InputJson_Model : Evergreen.V18.Pages.InputJson.Model -> Evergreen.V21.Pages.InputJson.Model
migrate_Pages_InputJson_Model old =
    { text = old.text
    , statusText = old.statusText
    , parsedRoutes = old.parsedRoutes |> Maybe.map (List.map migrate_Route_NewRouteData)
    , confirmState = old.confirmState |> migrate_ConfirmComponent_State
    }


migrate_Pages_InputJson_Msg : Evergreen.V18.Pages.InputJson.Msg -> Evergreen.V21.Pages.InputJson.Msg
migrate_Pages_InputJson_Msg old =
    case old of
        Evergreen.V18.Pages.InputJson.TextChanged p0 ->
            Evergreen.V21.Pages.InputJson.TextChanged p0

        Evergreen.V18.Pages.InputJson.SubmitToBackend p0 ->
            Evergreen.V21.Pages.InputJson.SubmitToBackend (p0 |> List.map migrate_Route_NewRouteData)

        Evergreen.V18.Pages.InputJson.ConfirmComponentEvent p0 ->
            Evergreen.V21.Pages.InputJson.ConfirmComponentEvent (p0 |> migrate_ConfirmComponent_Msg)


migrate_Pages_MoreOptions_Model : Evergreen.V18.Pages.MoreOptions.Model -> Evergreen.V21.Pages.MoreOptions.Model
migrate_Pages_MoreOptions_Model old =
    old


migrate_Pages_MoreOptions_Msg : Evergreen.V18.Pages.MoreOptions.Msg -> Evergreen.V21.Pages.MoreOptions.Msg
migrate_Pages_MoreOptions_Msg old =
    case old of
        Evergreen.V18.Pages.MoreOptions.Logout ->
            Evergreen.V21.Pages.MoreOptions.Logout


migrate_Pages_NewRoute_Model : Evergreen.V18.Pages.NewRoute.Model -> Evergreen.V21.Pages.NewRoute.Model
migrate_Pages_NewRoute_Model old =
    { newRouteData = old.newRouteData |> migrate_RouteEditPane_Model
    }


migrate_Pages_NewRoute_Msg : Evergreen.V18.Pages.NewRoute.Msg -> Evergreen.V21.Pages.NewRoute.Msg
migrate_Pages_NewRoute_Msg old =
    case old of
        Evergreen.V18.Pages.NewRoute.RouteEditMsg p0 ->
            Evergreen.V21.Pages.NewRoute.RouteEditMsg (p0 |> migrate_RouteEditPane_Msg)

        Evergreen.V18.Pages.NewRoute.CreateRoute ->
            Evergreen.V21.Pages.NewRoute.CreateRoute


migrate_Pages_OutputJson_Model : Evergreen.V18.Pages.OutputJson.Model -> Evergreen.V21.Pages.OutputJson.Model
migrate_Pages_OutputJson_Model old =
    old


migrate_Pages_OutputJson_Msg : Evergreen.V18.Pages.OutputJson.Msg -> Evergreen.V21.Pages.OutputJson.Msg
migrate_Pages_OutputJson_Msg old =
    case old of
        Evergreen.V18.Pages.OutputJson.NoOp ->
            Evergreen.V21.Pages.OutputJson.NoOp


migrate_Pages_Routes_Filter__ButtonId : Evergreen.V18.Pages.Routes.Filter_.ButtonId -> Evergreen.V21.Pages.Routes.Filter_.ButtonId
migrate_Pages_Routes_Filter__ButtonId old =
    case old of
        Evergreen.V18.Pages.Routes.Filter_.ExpandRouteButton p0 ->
            Evergreen.V21.Pages.Routes.Filter_.ExpandRouteButton (p0 |> migrate_Route_RouteId)

        Evergreen.V18.Pages.Routes.Filter_.EditRouteButton p0 ->
            Evergreen.V21.Pages.Routes.Filter_.EditRouteButton (p0 |> migrate_Route_RouteData)

        Evergreen.V18.Pages.Routes.Filter_.SaveButton p0 ->
            Evergreen.V21.Pages.Routes.Filter_.SaveButton (p0 |> migrate_Route_RouteData)

        Evergreen.V18.Pages.Routes.Filter_.DiscardButton p0 ->
            Evergreen.V21.Pages.Routes.Filter_.DiscardButton (p0 |> migrate_Route_RouteId)

        Evergreen.V18.Pages.Routes.Filter_.RemoveButton p0 ->
            Evergreen.V21.Pages.Routes.Filter_.RemoveButton (p0 |> migrate_Route_RouteId)

        Evergreen.V18.Pages.Routes.Filter_.CreateButton ->
            Evergreen.V21.Pages.Routes.Filter_.CreateButton


migrate_Pages_Routes_Filter__Filter : Evergreen.V18.Pages.Routes.Filter_.Filter -> Evergreen.V21.Pages.Routes.Filter_.Filter
migrate_Pages_Routes_Filter__Filter old =
    { filter = old.filter |> migrate_Filter_Model
    , sorter = old.sorter |> migrate_Sorter_Model
    }


migrate_Pages_Routes_Filter__Metadata : Evergreen.V18.Pages.Routes.Filter_.Metadata -> Evergreen.V21.Pages.Routes.Filter_.Metadata
migrate_Pages_Routes_Filter__Metadata old =
    { expanded = old.expanded
    , routeId = old.routeId |> migrate_Route_RouteId
    , editRoute = old.editRoute |> Maybe.map migrate_RouteEditPane_Model
    }


migrate_Pages_Routes_Filter__Model : Evergreen.V18.Pages.Routes.Filter_.Model -> Evergreen.V21.Pages.Routes.Filter_.Model
migrate_Pages_Routes_Filter__Model old =
    { filter = old.filter |> migrate_Pages_Routes_Filter__Filter
    , showSortBox = old.showSortBox
    , metadatas = old.metadatas |> Dict.map (\k -> migrate_Pages_Routes_Filter__Metadata)
    }


migrate_Pages_Routes_Filter__Msg : Evergreen.V18.Pages.Routes.Filter_.Msg -> Evergreen.V21.Pages.Routes.Filter_.Msg
migrate_Pages_Routes_Filter__Msg old =
    case old of
        Evergreen.V18.Pages.Routes.Filter_.ToggleFilters ->
            Evergreen.V21.Pages.Routes.Filter_.ToggleFilters

        Evergreen.V18.Pages.Routes.Filter_.ButtonPressed p0 ->
            Evergreen.V21.Pages.Routes.Filter_.ButtonPressed (p0 |> migrate_Pages_Routes_Filter__ButtonId)

        Evergreen.V18.Pages.Routes.Filter_.SortSelected p0 ->
            Evergreen.V21.Pages.Routes.Filter_.SortSelected (p0 |> migrate_Sorter_SorterMsg)

        Evergreen.V18.Pages.Routes.Filter_.FilterMsg p0 ->
            Evergreen.V21.Pages.Routes.Filter_.FilterMsg (p0 |> migrate_Filter_Msg)

        Evergreen.V18.Pages.Routes.Filter_.RouteEditPaneMsg p0 p1 ->
            Evergreen.V21.Pages.Routes.Filter_.RouteEditPaneMsg (p0 |> migrate_Route_RouteId)
                (p1 |> migrate_RouteEditPane_Msg)


migrate_Pages_SignIn_SignInDest__FieldType : String -> Evergreen.V21.Pages.SignIn.SignInDest_.FieldType
migrate_Pages_SignIn_SignInDest__FieldType old =
    case old of
        "password" ->
            Evergreen.V21.Pages.SignIn.SignInDest_.PasswordField

        _ ->
            Evergreen.V21.Pages.SignIn.SignInDest_.UsernameField


migrate_Pages_SignIn_SignInDest__Model : Evergreen.V18.Pages.SignIn.SignInDest_.Model -> Evergreen.V21.Pages.SignIn.SignInDest_.Model
migrate_Pages_SignIn_SignInDest__Model old =
    { username = old.username
    , password = old.password
    , showPassword = False
    , errorMsg = Nothing
    }


migrate_Pages_SignIn_SignInDest__Msg : Evergreen.V18.Pages.SignIn.SignInDest_.Msg -> Evergreen.V21.Pages.SignIn.SignInDest_.Msg
migrate_Pages_SignIn_SignInDest__Msg old =
    case old of
        Evergreen.V18.Pages.SignIn.SignInDest_.ClickedSignIn ->
            Evergreen.V21.Pages.SignIn.SignInDest_.ClickedSignIn

        Evergreen.V18.Pages.SignIn.SignInDest_.FieldChanged p0 p1 ->
            Evergreen.V21.Pages.SignIn.SignInDest_.FieldChanged (p0 |> migrate_Pages_SignIn_SignInDest__FieldType)
                p1


migrate_Pages_Stats_Model : Evergreen.V18.Pages.Stats.Model -> Evergreen.V21.Pages.Stats.Model
migrate_Pages_Stats_Model old =
    old


migrate_Pages_Stats_Msg : Evergreen.V18.Pages.Stats.Msg -> Evergreen.V21.Pages.Stats.Msg
migrate_Pages_Stats_Msg old =
    case old of
        Evergreen.V18.Pages.Stats.ReplaceMe ->
            Evergreen.V21.Pages.Stats.ReplaceMe


migrate_RouteEditPane_Model : Evergreen.V18.RouteEditPane.Model -> Evergreen.V21.RouteEditPane.Model
migrate_RouteEditPane_Model old =
    { route = old.route |> migrate_Route_NewRouteData
    , datePickerModel = old.datePickerModel
    , datePickerText = old.datePickerText
    }


migrate_RouteEditPane_Msg : Evergreen.V18.RouteEditPane.Msg -> Evergreen.V21.RouteEditPane.Msg
migrate_RouteEditPane_Msg old =
    case old of
        Evergreen.V18.RouteEditPane.FieldUpdated p0 p1 ->
            Evergreen.V21.RouteEditPane.FieldUpdated p0 p1

        Evergreen.V18.RouteEditPane.DatePickerUpdate p0 ->
            Evergreen.V21.RouteEditPane.DatePickerUpdate p0


migrate_Route_ClimbType : Evergreen.V18.Route.ClimbType -> Evergreen.V21.Route.ClimbType
migrate_Route_ClimbType old =
    case old of
        Evergreen.V18.Route.Trad ->
            Evergreen.V21.Route.Trad

        Evergreen.V18.Route.Sport ->
            Evergreen.V21.Route.Sport

        Evergreen.V18.Route.Boulder ->
            Evergreen.V21.Route.Boulder

        Evergreen.V18.Route.Mix ->
            Evergreen.V21.Route.Mix

        Evergreen.V18.Route.Aid ->
            Evergreen.V21.Route.Aid


migrate_Route_NewRouteData : Evergreen.V18.Route.NewRouteData -> Evergreen.V21.Route.NewRouteData
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


migrate_Route_RouteData : Evergreen.V18.Route.RouteData -> Evergreen.V21.Route.RouteData
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


migrate_Route_RouteId : Evergreen.V18.Route.RouteId -> Evergreen.V21.Route.RouteId
migrate_Route_RouteId old =
    case old of
        Evergreen.V18.Route.RouteId p0 ->
            Evergreen.V21.Route.RouteId p0


migrate_Shared_Model : Evergreen.V18.Shared.Model -> Evergreen.V21.Shared.Model
migrate_Shared_Model old =
    { routes = old.routes |> List.map migrate_Route_RouteData
    , user = old.user |> Maybe.map migrate_Shared_User
    , currentDate = old.currentDate
    }


migrate_Shared_Msg : Evergreen.V18.Shared.Msg -> Evergreen.V21.Shared.Msg
migrate_Shared_Msg old =
    case old of
        Evergreen.V18.Shared.Noop ->
            Evergreen.V21.Shared.Noop

        Evergreen.V18.Shared.MsgFromBackend p0 ->
            Evergreen.V21.Shared.MsgFromBackend (p0 |> migrate_Shared_SharedFromBackend)

        Evergreen.V18.Shared.SetCurrentDate p0 ->
            Evergreen.V21.Shared.SetCurrentDate p0


migrate_Shared_SharedFromBackend : Evergreen.V18.Shared.SharedFromBackend -> Evergreen.V21.Shared.SharedFromBackend
migrate_Shared_SharedFromBackend old =
    case old of
        Evergreen.V18.Shared.AllRoutesAnnouncement p0 ->
            Evergreen.V21.Shared.AllRoutesAnnouncement (p0 |> List.map migrate_Route_RouteData)

        Evergreen.V18.Shared.LogOut ->
            Evergreen.V21.Shared.LogOut

        Evergreen.V18.Shared.YouAreAdmin ->
            Evergreen.V21.Shared.YouAreAdmin


migrate_Shared_User : Evergreen.V18.Shared.User -> Evergreen.V21.Shared.User
migrate_Shared_User old =
    case old of
        Evergreen.V18.Shared.NormalUser ->
            Evergreen.V21.Shared.NormalUser

        Evergreen.V18.Shared.AdminUser ->
            Evergreen.V21.Shared.AdminUser


migrate_Sorter_Model : Evergreen.V18.Sorter.Model -> Evergreen.V21.Sorter.Model
migrate_Sorter_Model old =
    old |> List.map (Tuple.mapBoth migrate_Sorter_SortAttribute migrate_Sorter_SortOrder)


migrate_Sorter_SortAttribute : Evergreen.V18.Sorter.SortAttribute -> Evergreen.V21.Sorter.SortAttribute
migrate_Sorter_SortAttribute old =
    case old of
        Evergreen.V18.Sorter.Area ->
            Evergreen.V21.Sorter.Area

        Evergreen.V18.Sorter.Grade ->
            Evergreen.V21.Sorter.Grade

        Evergreen.V18.Sorter.Tickdate ->
            Evergreen.V21.Sorter.Tickdate

        Evergreen.V18.Sorter.Name ->
            Evergreen.V21.Sorter.Name


migrate_Sorter_SortOrder : Evergreen.V18.Sorter.SortOrder -> Evergreen.V21.Sorter.SortOrder
migrate_Sorter_SortOrder old =
    case old of
        Evergreen.V18.Sorter.Ascending ->
            Evergreen.V21.Sorter.Ascending

        Evergreen.V18.Sorter.Descending ->
            Evergreen.V21.Sorter.Descending


migrate_Sorter_SorterMsg : Evergreen.V18.Sorter.SorterMsg -> Evergreen.V21.Sorter.SorterMsg
migrate_Sorter_SorterMsg old =
    case old of
        Evergreen.V18.Sorter.SorterMsg p0 ->
            Evergreen.V21.Sorter.SorterMsg p0

        Evergreen.V18.Sorter.RemoveRow p0 ->
            Evergreen.V21.Sorter.RemoveRow p0


migrate_Types_FrontendMsg : Evergreen.V18.Types.FrontendMsg -> Evergreen.V21.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V18.Types.ClickedLink p0 ->
            Evergreen.V21.Types.ClickedLink p0

        Evergreen.V18.Types.ChangedUrl p0 ->
            Evergreen.V21.Types.ChangedUrl p0

        Evergreen.V18.Types.Shared p0 ->
            Evergreen.V21.Types.Shared (p0 |> migrate_Shared_Msg)

        Evergreen.V18.Types.Page p0 ->
            Evergreen.V21.Types.Page (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V18.Types.NoOpFrontendMsg ->
            Evergreen.V21.Types.NoOpFrontendMsg
