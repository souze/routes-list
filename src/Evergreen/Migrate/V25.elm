module Evergreen.Migrate.V25 exposing (..)

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
import Evergreen.V23.BackupModel
import Evergreen.V23.ConfirmComponent
import Evergreen.V23.Filter
import Evergreen.V23.FormDict
import Evergreen.V23.Gen.Model
import Evergreen.V23.Gen.Msg
import Evergreen.V23.Gen.Pages
import Evergreen.V23.Gen.Params.Routes.Filter_
import Evergreen.V23.Gen.Params.SignIn.SignInDest_
import Evergreen.V23.ImageGallery
import Evergreen.V23.Pages.Admin.AddUser
import Evergreen.V23.Pages.Admin.ChangePassword
import Evergreen.V23.Pages.Admin.Home_
import Evergreen.V23.Pages.Admin.RemoveUser
import Evergreen.V23.Pages.Admin.ShowJson
import Evergreen.V23.Pages.ChangePassword
import Evergreen.V23.Pages.Home_
import Evergreen.V23.Pages.InputJson
import Evergreen.V23.Pages.MoreOptions
import Evergreen.V23.Pages.NewRoute
import Evergreen.V23.Pages.OutputJson
import Evergreen.V23.Pages.Routes.Filter_
import Evergreen.V23.Pages.SignIn.SignInDest_
import Evergreen.V23.Pages.Stats
import Evergreen.V23.Route
import Evergreen.V23.RouteEditPane
import Evergreen.V23.Shared
import Evergreen.V23.Sorter
import Evergreen.V23.Types
import Evergreen.V25.BackupModel
import Evergreen.V25.ConfirmComponent
import Evergreen.V25.Filter
import Evergreen.V25.FormDict
import Evergreen.V25.Gen.Model
import Evergreen.V25.Gen.Msg
import Evergreen.V25.Gen.Pages
import Evergreen.V25.Gen.Params.Routes.Filter_
import Evergreen.V25.Gen.Params.SignIn.SignInDest_
import Evergreen.V25.ImageGallery
import Evergreen.V25.Pages.Admin.AddUser
import Evergreen.V25.Pages.Admin.ChangePassword
import Evergreen.V25.Pages.Admin.Home_
import Evergreen.V25.Pages.Admin.RemoveUser
import Evergreen.V25.Pages.Admin.ShowJson
import Evergreen.V25.Pages.ChangePassword
import Evergreen.V25.Pages.Home_
import Evergreen.V25.Pages.InputJson
import Evergreen.V25.Pages.MoreOptions
import Evergreen.V25.Pages.NewRoute
import Evergreen.V25.Pages.OutputJson
import Evergreen.V25.Pages.Routes.Filter_
import Evergreen.V25.Pages.SignIn.SignInDest_
import Evergreen.V25.Pages.Stats
import Evergreen.V25.Route
import Evergreen.V25.RouteEditPane
import Evergreen.V25.Shared
import Evergreen.V25.Sorter
import Evergreen.V25.Types
import Lamdera.Migrations exposing (..)
import List
import Maybe


frontendModel : Evergreen.V23.Types.FrontendModel -> ModelMigration Evergreen.V25.Types.FrontendModel Evergreen.V25.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V23.Types.BackendModel -> ModelMigration Evergreen.V25.Types.BackendModel Evergreen.V25.Types.BackendMsg
backendModel old =
    ModelUnchanged


frontendMsg : Evergreen.V23.Types.FrontendMsg -> MsgMigration Evergreen.V25.Types.FrontendMsg Evergreen.V25.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V23.Types.ToBackend -> MsgMigration Evergreen.V25.Types.ToBackend Evergreen.V25.Types.BackendMsg
toBackend old =
    MsgUnchanged


backendMsg : Evergreen.V23.Types.BackendMsg -> MsgMigration Evergreen.V25.Types.BackendMsg Evergreen.V25.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V23.Types.ToFrontend -> MsgMigration Evergreen.V25.Types.ToFrontend Evergreen.V25.Types.FrontendMsg
toFrontend old =
    MsgUnchanged


migrate_Types_FrontendModel : Evergreen.V23.Types.FrontendModel -> Evergreen.V25.Types.FrontendModel
migrate_Types_FrontendModel old =
    { url = old.url
    , key = old.key
    , shared = old.shared |> migrate_Shared_Model
    , page = old.page |> migrate_Gen_Pages_Model
    }


migrate_BackupModel_BackupModel : Evergreen.V23.BackupModel.BackupModel -> Evergreen.V25.BackupModel.BackupModel
migrate_BackupModel_BackupModel old =
    old
        |> List.map
            (\rec ->
                { username = rec.username
                , routes = rec.routes |> List.map migrate_Route_RouteData
                }
            )


migrate_ConfirmComponent_Msg : Evergreen.V23.ConfirmComponent.Msg -> Evergreen.V25.ConfirmComponent.Msg
migrate_ConfirmComponent_Msg old =
    case old of
        Evergreen.V23.ConfirmComponent.ConfirmCompTextChange p0 ->
            Evergreen.V25.ConfirmComponent.ConfirmCompTextChange p0

        Evergreen.V23.ConfirmComponent.FirstButtonPressed ->
            Evergreen.V25.ConfirmComponent.FirstButtonPressed


migrate_ConfirmComponent_State : Evergreen.V23.ConfirmComponent.State -> Evergreen.V25.ConfirmComponent.State
migrate_ConfirmComponent_State old =
    case old of
        Evergreen.V23.ConfirmComponent.Waiting ->
            Evergreen.V25.ConfirmComponent.Waiting

        Evergreen.V23.ConfirmComponent.Active p0 ->
            Evergreen.V25.ConfirmComponent.Active p0


migrate_Filter_Model : Evergreen.V23.Filter.Model -> Evergreen.V25.Filter.Model
migrate_Filter_Model old =
    { grade = old.grade
    , type_ = old.type_
    , tickdate = old.tickdate |> migrate_Filter_TickDateFilter
    , tags = old.tags
    }


migrate_Filter_Msg : Evergreen.V23.Filter.Msg -> Evergreen.V25.Filter.Msg
migrate_Filter_Msg old =
    case old of
        Evergreen.V23.Filter.PressedGradeFilter p0 ->
            Evergreen.V25.Filter.PressedGradeFilter p0

        Evergreen.V23.Filter.PressedTickdateFilter ->
            Evergreen.V25.Filter.PressedTickdateFilter

        Evergreen.V23.Filter.PressedTypeFilter p0 ->
            Evergreen.V25.Filter.PressedTypeFilter p0

        Evergreen.V23.Filter.PressedTagFilter p0 ->
            Evergreen.V25.Filter.PressedTagFilter p0


migrate_Filter_TickDateFilter : Evergreen.V23.Filter.TickDateFilter -> Evergreen.V25.Filter.TickDateFilter
migrate_Filter_TickDateFilter old =
    case old of
        Evergreen.V23.Filter.TickdateRangeFrom ->
            Evergreen.V25.Filter.TickdateRangeFrom

        Evergreen.V23.Filter.TickdateRangeTo ->
            Evergreen.V25.Filter.TickdateRangeTo

        Evergreen.V23.Filter.TickdateRangeBetween ->
            Evergreen.V25.Filter.TickdateRangeBetween

        Evergreen.V23.Filter.ShowHasTickdate ->
            Evergreen.V25.Filter.ShowHasTickdate

        Evergreen.V23.Filter.ShowWithoutTickdate ->
            Evergreen.V25.Filter.ShowWithoutTickdate

        Evergreen.V23.Filter.ShowAllTickdates ->
            Evergreen.V25.Filter.ShowAllTickdates


migrate_FormDict_FormDict : Evergreen.V23.FormDict.FormDict -> Evergreen.V25.FormDict.FormDict
migrate_FormDict_FormDict old =
    case old of
        Evergreen.V23.FormDict.FormDict p0 ->
            Evergreen.V25.FormDict.FormDict p0


migrate_Gen_Model_Model : Evergreen.V23.Gen.Model.Model -> Evergreen.V25.Gen.Model.Model
migrate_Gen_Model_Model old =
    case old of
        Evergreen.V23.Gen.Model.Redirecting_ ->
            Evergreen.V25.Gen.Model.Redirecting_

        Evergreen.V23.Gen.Model.ChangePassword p0 p1 ->
            Evergreen.V25.Gen.Model.ChangePassword p0 (p1 |> migrate_Pages_ChangePassword_Model)

        Evergreen.V23.Gen.Model.Home_ p0 p1 ->
            Evergreen.V25.Gen.Model.Home_ p0 (p1 |> migrate_Pages_Home__Model)

        Evergreen.V23.Gen.Model.InputJson p0 p1 ->
            Evergreen.V25.Gen.Model.InputJson p0 (p1 |> migrate_Pages_InputJson_Model)

        Evergreen.V23.Gen.Model.MoreOptions p0 p1 ->
            Evergreen.V25.Gen.Model.MoreOptions p0 (p1 |> migrate_Pages_MoreOptions_Model)

        Evergreen.V23.Gen.Model.NewRoute p0 p1 ->
            Evergreen.V25.Gen.Model.NewRoute p0 (p1 |> migrate_Pages_NewRoute_Model)

        Evergreen.V23.Gen.Model.OutputJson p0 p1 ->
            Evergreen.V25.Gen.Model.OutputJson p0 (p1 |> migrate_Pages_OutputJson_Model)

        Evergreen.V23.Gen.Model.Stats p0 p1 ->
            Evergreen.V25.Gen.Model.Stats p0 (p1 |> migrate_Pages_Stats_Model)

        Evergreen.V23.Gen.Model.Admin__AddUser p0 p1 ->
            Evergreen.V25.Gen.Model.Admin__AddUser p0 (p1 |> migrate_Pages_Admin_AddUser_Model)

        Evergreen.V23.Gen.Model.Admin__ChangePassword p0 p1 ->
            Evergreen.V25.Gen.Model.Admin__ChangePassword p0
                (p1 |> migrate_Pages_Admin_ChangePassword_Model)

        Evergreen.V23.Gen.Model.Admin__Home_ p0 p1 ->
            Evergreen.V25.Gen.Model.Admin__Home_ p0 (p1 |> migrate_Pages_Admin_Home__Model)

        Evergreen.V23.Gen.Model.Admin__RemoveUser p0 p1 ->
            Evergreen.V25.Gen.Model.Admin__RemoveUser p0 (p1 |> migrate_Pages_Admin_RemoveUser_Model)

        Evergreen.V23.Gen.Model.Admin__ShowJson p0 p1 ->
            Evergreen.V25.Gen.Model.Admin__ShowJson p0 (p1 |> migrate_Pages_Admin_ShowJson_Model)

        Evergreen.V23.Gen.Model.Routes__Filter_ p0 p1 ->
            Evergreen.V25.Gen.Model.Routes__Filter_ (p0 |> migrate_Gen_Params_Routes_Filter__Params)
                (p1 |> migrate_Pages_Routes_Filter__Model)

        Evergreen.V23.Gen.Model.SignIn__SignInDest_ p0 p1 ->
            Evergreen.V25.Gen.Model.SignIn__SignInDest_ (p0 |> migrate_Gen_Params_SignIn_SignInDest__Params)
                (p1 |> migrate_Pages_SignIn_SignInDest__Model)

        Evergreen.V23.Gen.Model.NotFound p0 ->
            Evergreen.V25.Gen.Model.NotFound p0


migrate_Gen_Msg_Msg : Evergreen.V23.Gen.Msg.Msg -> Evergreen.V25.Gen.Msg.Msg
migrate_Gen_Msg_Msg old =
    case old of
        Evergreen.V23.Gen.Msg.ChangePassword p0 ->
            Evergreen.V25.Gen.Msg.ChangePassword (p0 |> migrate_Pages_ChangePassword_Msg)

        Evergreen.V23.Gen.Msg.Home_ p0 ->
            Evergreen.V25.Gen.Msg.Home_ (p0 |> migrate_Pages_Home__Msg)

        Evergreen.V23.Gen.Msg.InputJson p0 ->
            Evergreen.V25.Gen.Msg.InputJson (p0 |> migrate_Pages_InputJson_Msg)

        Evergreen.V23.Gen.Msg.MoreOptions p0 ->
            Evergreen.V25.Gen.Msg.MoreOptions (p0 |> migrate_Pages_MoreOptions_Msg)

        Evergreen.V23.Gen.Msg.NewRoute p0 ->
            Evergreen.V25.Gen.Msg.NewRoute (p0 |> migrate_Pages_NewRoute_Msg)

        Evergreen.V23.Gen.Msg.OutputJson p0 ->
            Evergreen.V25.Gen.Msg.OutputJson (p0 |> migrate_Pages_OutputJson_Msg)

        Evergreen.V23.Gen.Msg.Stats p0 ->
            Evergreen.V25.Gen.Msg.Stats (p0 |> migrate_Pages_Stats_Msg)

        Evergreen.V23.Gen.Msg.Admin__AddUser p0 ->
            Evergreen.V25.Gen.Msg.Admin__AddUser (p0 |> migrate_Pages_Admin_AddUser_Msg)

        Evergreen.V23.Gen.Msg.Admin__ChangePassword p0 ->
            Evergreen.V25.Gen.Msg.Admin__ChangePassword (p0 |> migrate_Pages_Admin_ChangePassword_Msg)

        Evergreen.V23.Gen.Msg.Admin__Home_ p0 ->
            Evergreen.V25.Gen.Msg.Admin__Home_ (p0 |> migrate_Pages_Admin_Home__Msg)

        Evergreen.V23.Gen.Msg.Admin__RemoveUser p0 ->
            Evergreen.V25.Gen.Msg.Admin__RemoveUser (p0 |> migrate_Pages_Admin_RemoveUser_Msg)

        Evergreen.V23.Gen.Msg.Admin__ShowJson p0 ->
            Evergreen.V25.Gen.Msg.Admin__ShowJson (p0 |> migrate_Pages_Admin_ShowJson_Msg)

        Evergreen.V23.Gen.Msg.Routes__Filter_ p0 ->
            Evergreen.V25.Gen.Msg.Routes__Filter_ (p0 |> migrate_Pages_Routes_Filter__Msg)

        Evergreen.V23.Gen.Msg.SignIn__SignInDest_ p0 ->
            Evergreen.V25.Gen.Msg.SignIn__SignInDest_ (p0 |> migrate_Pages_SignIn_SignInDest__Msg)


migrate_Gen_Pages_Model : Evergreen.V23.Gen.Pages.Model -> Evergreen.V25.Gen.Pages.Model
migrate_Gen_Pages_Model old =
    old |> migrate_Gen_Model_Model


migrate_Gen_Pages_Msg : Evergreen.V23.Gen.Pages.Msg -> Evergreen.V25.Gen.Pages.Msg
migrate_Gen_Pages_Msg old =
    old |> migrate_Gen_Msg_Msg


migrate_Gen_Params_Routes_Filter__Params : Evergreen.V23.Gen.Params.Routes.Filter_.Params -> Evergreen.V25.Gen.Params.Routes.Filter_.Params
migrate_Gen_Params_Routes_Filter__Params old =
    old


migrate_Gen_Params_SignIn_SignInDest__Params : Evergreen.V23.Gen.Params.SignIn.SignInDest_.Params -> Evergreen.V25.Gen.Params.SignIn.SignInDest_.Params
migrate_Gen_Params_SignIn_SignInDest__Params old =
    old


migrate_ImageGallery_Model : Evergreen.V23.ImageGallery.Model -> Evergreen.V25.ImageGallery.Model
migrate_ImageGallery_Model old =
    { images = old.images
    , swipeState = Nothing
    }


migrate_ImageGallery_Msg : Evergreen.V23.ImageGallery.Msg -> Evergreen.V25.ImageGallery.Msg
migrate_ImageGallery_Msg old =
    case old of
        Evergreen.V23.ImageGallery.PrevPressed ->
            Evergreen.V25.ImageGallery.PrevPressed

        Evergreen.V23.ImageGallery.NextPressed ->
            Evergreen.V25.ImageGallery.NextPressed

        Evergreen.V23.ImageGallery.BackPressed ->
            Evergreen.V25.ImageGallery.BackPressed


migrate_Pages_Admin_AddUser_Model : Evergreen.V23.Pages.Admin.AddUser.Model -> Evergreen.V25.Pages.Admin.AddUser.Model
migrate_Pages_Admin_AddUser_Model old =
    { form = old.form |> migrate_FormDict_FormDict
    }


migrate_Pages_Admin_AddUser_Msg : Evergreen.V23.Pages.Admin.AddUser.Msg -> Evergreen.V25.Pages.Admin.AddUser.Msg
migrate_Pages_Admin_AddUser_Msg old =
    case old of
        Evergreen.V23.Pages.Admin.AddUser.FieldUpdate p0 p1 ->
            Evergreen.V25.Pages.Admin.AddUser.FieldUpdate p0 p1

        Evergreen.V23.Pages.Admin.AddUser.CreateUser ->
            Evergreen.V25.Pages.Admin.AddUser.CreateUser


migrate_Pages_Admin_ChangePassword_Model : Evergreen.V23.Pages.Admin.ChangePassword.Model -> Evergreen.V25.Pages.Admin.ChangePassword.Model
migrate_Pages_Admin_ChangePassword_Model old =
    { form = old.form |> migrate_FormDict_FormDict
    }


migrate_Pages_Admin_ChangePassword_Msg : Evergreen.V23.Pages.Admin.ChangePassword.Msg -> Evergreen.V25.Pages.Admin.ChangePassword.Msg
migrate_Pages_Admin_ChangePassword_Msg old =
    case old of
        Evergreen.V23.Pages.Admin.ChangePassword.FieldUpdate p0 p1 ->
            Evergreen.V25.Pages.Admin.ChangePassword.FieldUpdate p0 p1

        Evergreen.V23.Pages.Admin.ChangePassword.ChangePassword ->
            Evergreen.V25.Pages.Admin.ChangePassword.ChangePassword


migrate_Pages_Admin_Home__Model : Evergreen.V23.Pages.Admin.Home_.Model -> Evergreen.V25.Pages.Admin.Home_.Model
migrate_Pages_Admin_Home__Model old =
    old


migrate_Pages_Admin_Home__Msg : Evergreen.V23.Pages.Admin.Home_.Msg -> Evergreen.V25.Pages.Admin.Home_.Msg
migrate_Pages_Admin_Home__Msg old =
    case old of
        Evergreen.V23.Pages.Admin.Home_.LogOut ->
            Evergreen.V25.Pages.Admin.Home_.LogOut


migrate_Pages_Admin_RemoveUser_Model : Evergreen.V23.Pages.Admin.RemoveUser.Model -> Evergreen.V25.Pages.Admin.RemoveUser.Model
migrate_Pages_Admin_RemoveUser_Model old =
    old


migrate_Pages_Admin_RemoveUser_Msg : Evergreen.V23.Pages.Admin.RemoveUser.Msg -> Evergreen.V25.Pages.Admin.RemoveUser.Msg
migrate_Pages_Admin_RemoveUser_Msg old =
    case old of
        Evergreen.V23.Pages.Admin.RemoveUser.FieldUpdate p0 ->
            Evergreen.V25.Pages.Admin.RemoveUser.FieldUpdate p0

        Evergreen.V23.Pages.Admin.RemoveUser.RemoveUser ->
            Evergreen.V25.Pages.Admin.RemoveUser.RemoveUser


migrate_Pages_Admin_ShowJson_Model : Evergreen.V23.Pages.Admin.ShowJson.Model -> Evergreen.V25.Pages.Admin.ShowJson.Model
migrate_Pages_Admin_ShowJson_Model old =
    old


migrate_Pages_Admin_ShowJson_Msg : Evergreen.V23.Pages.Admin.ShowJson.Msg -> Evergreen.V25.Pages.Admin.ShowJson.Msg
migrate_Pages_Admin_ShowJson_Msg old =
    case old of
        Evergreen.V23.Pages.Admin.ShowJson.BackupModelFromBackend p0 ->
            Evergreen.V25.Pages.Admin.ShowJson.BackupModelFromBackend (p0 |> migrate_BackupModel_BackupModel)


migrate_Pages_ChangePassword_Model : Evergreen.V23.Pages.ChangePassword.Model -> Evergreen.V25.Pages.ChangePassword.Model
migrate_Pages_ChangePassword_Model old =
    old


migrate_Pages_ChangePassword_Msg : Evergreen.V23.Pages.ChangePassword.Msg -> Evergreen.V25.Pages.ChangePassword.Msg
migrate_Pages_ChangePassword_Msg old =
    case old of
        Evergreen.V23.Pages.ChangePassword.FieldUpdate p0 p1 ->
            Evergreen.V25.Pages.ChangePassword.FieldUpdate p0 p1

        Evergreen.V23.Pages.ChangePassword.ChangePassword ->
            Evergreen.V25.Pages.ChangePassword.ChangePassword


migrate_Pages_Home__Model : Evergreen.V23.Pages.Home_.Model -> Evergreen.V25.Pages.Home_.Model
migrate_Pages_Home__Model old =
    old


migrate_Pages_Home__Msg : Evergreen.V23.Pages.Home_.Msg -> Evergreen.V25.Pages.Home_.Msg
migrate_Pages_Home__Msg old =
    case old of
        Evergreen.V23.Pages.Home_.ReplaceMe ->
            Evergreen.V25.Pages.Home_.ReplaceMe


migrate_Pages_InputJson_Model : Evergreen.V23.Pages.InputJson.Model -> Evergreen.V25.Pages.InputJson.Model
migrate_Pages_InputJson_Model old =
    { text = old.text
    , statusText = old.statusText
    , parsedRoutes = old.parsedRoutes |> Maybe.map (List.map migrate_Route_NewRouteData)
    , confirmState = old.confirmState |> migrate_ConfirmComponent_State
    }


migrate_Pages_InputJson_Msg : Evergreen.V23.Pages.InputJson.Msg -> Evergreen.V25.Pages.InputJson.Msg
migrate_Pages_InputJson_Msg old =
    case old of
        Evergreen.V23.Pages.InputJson.TextChanged p0 ->
            Evergreen.V25.Pages.InputJson.TextChanged p0

        Evergreen.V23.Pages.InputJson.SubmitToBackend p0 ->
            Evergreen.V25.Pages.InputJson.SubmitToBackend (p0 |> List.map migrate_Route_NewRouteData)

        Evergreen.V23.Pages.InputJson.ConfirmComponentEvent p0 ->
            Evergreen.V25.Pages.InputJson.ConfirmComponentEvent (p0 |> migrate_ConfirmComponent_Msg)


migrate_Pages_MoreOptions_Model : Evergreen.V23.Pages.MoreOptions.Model -> Evergreen.V25.Pages.MoreOptions.Model
migrate_Pages_MoreOptions_Model old =
    old


migrate_Pages_MoreOptions_Msg : Evergreen.V23.Pages.MoreOptions.Msg -> Evergreen.V25.Pages.MoreOptions.Msg
migrate_Pages_MoreOptions_Msg old =
    case old of
        Evergreen.V23.Pages.MoreOptions.Logout ->
            Evergreen.V25.Pages.MoreOptions.Logout


migrate_Pages_NewRoute_Model : Evergreen.V23.Pages.NewRoute.Model -> Evergreen.V25.Pages.NewRoute.Model
migrate_Pages_NewRoute_Model old =
    { newRouteData = old.newRouteData |> migrate_RouteEditPane_Model
    }


migrate_Pages_NewRoute_Msg : Evergreen.V23.Pages.NewRoute.Msg -> Evergreen.V25.Pages.NewRoute.Msg
migrate_Pages_NewRoute_Msg old =
    case old of
        Evergreen.V23.Pages.NewRoute.RouteEditMsg p0 ->
            Evergreen.V25.Pages.NewRoute.RouteEditMsg (p0 |> migrate_RouteEditPane_Msg)

        Evergreen.V23.Pages.NewRoute.CreateRoute ->
            Evergreen.V25.Pages.NewRoute.CreateRoute


migrate_Pages_OutputJson_Model : Evergreen.V23.Pages.OutputJson.Model -> Evergreen.V25.Pages.OutputJson.Model
migrate_Pages_OutputJson_Model old =
    old


migrate_Pages_OutputJson_Msg : Evergreen.V23.Pages.OutputJson.Msg -> Evergreen.V25.Pages.OutputJson.Msg
migrate_Pages_OutputJson_Msg old =
    case old of
        Evergreen.V23.Pages.OutputJson.NoOp ->
            Evergreen.V25.Pages.OutputJson.NoOp


migrate_Pages_Routes_Filter__ButtonId : Evergreen.V23.Pages.Routes.Filter_.ButtonId -> Evergreen.V25.Pages.Routes.Filter_.ButtonId
migrate_Pages_Routes_Filter__ButtonId old =
    case old of
        Evergreen.V23.Pages.Routes.Filter_.ExpandRouteButton p0 ->
            Evergreen.V25.Pages.Routes.Filter_.ExpandRouteButton (p0 |> migrate_Route_RouteId)

        Evergreen.V23.Pages.Routes.Filter_.EditRouteButton p0 ->
            Evergreen.V25.Pages.Routes.Filter_.EditRouteButton (p0 |> migrate_Route_RouteData)

        Evergreen.V23.Pages.Routes.Filter_.SaveButton p0 ->
            Evergreen.V25.Pages.Routes.Filter_.SaveButton (p0 |> migrate_Route_RouteData)

        Evergreen.V23.Pages.Routes.Filter_.DiscardButton p0 ->
            Evergreen.V25.Pages.Routes.Filter_.DiscardButton (p0 |> migrate_Route_RouteId)

        Evergreen.V23.Pages.Routes.Filter_.RemoveButton p0 ->
            Evergreen.V25.Pages.Routes.Filter_.RemoveButton (p0 |> migrate_Route_RouteId)

        Evergreen.V23.Pages.Routes.Filter_.CreateButton ->
            Evergreen.V25.Pages.Routes.Filter_.CreateButton


migrate_Pages_Routes_Filter__Filter : Evergreen.V23.Pages.Routes.Filter_.Filter -> Evergreen.V25.Pages.Routes.Filter_.Filter
migrate_Pages_Routes_Filter__Filter old =
    { filter = old.filter |> migrate_Filter_Model
    , sorter = old.sorter |> migrate_Sorter_Model
    }


migrate_Pages_Routes_Filter__Metadata : Evergreen.V23.Pages.Routes.Filter_.Metadata -> Evergreen.V25.Pages.Routes.Filter_.Metadata
migrate_Pages_Routes_Filter__Metadata old =
    { expanded = old.expanded
    , routeId = old.routeId |> migrate_Route_RouteId
    , editRoute = old.editRoute |> Maybe.map migrate_RouteEditPane_Model
    }


migrate_Pages_Routes_Filter__Model : Evergreen.V23.Pages.Routes.Filter_.Model -> Evergreen.V25.Pages.Routes.Filter_.Model
migrate_Pages_Routes_Filter__Model old =
    { filter = old.filter |> migrate_Pages_Routes_Filter__Filter
    , showSortBox = old.showSortBox
    , metadatas = old.metadatas |> Dict.map (\k -> migrate_Pages_Routes_Filter__Metadata)
    , galleryModel = old.galleryModel |> Maybe.map migrate_ImageGallery_Model
    }


migrate_Pages_Routes_Filter__Msg : Evergreen.V23.Pages.Routes.Filter_.Msg -> Evergreen.V25.Pages.Routes.Filter_.Msg
migrate_Pages_Routes_Filter__Msg old =
    case old of
        Evergreen.V23.Pages.Routes.Filter_.ToggleFilters ->
            Evergreen.V25.Pages.Routes.Filter_.ToggleFilters

        Evergreen.V23.Pages.Routes.Filter_.ButtonPressed p0 ->
            Evergreen.V25.Pages.Routes.Filter_.ButtonPressed (p0 |> migrate_Pages_Routes_Filter__ButtonId)

        Evergreen.V23.Pages.Routes.Filter_.SortSelected p0 ->
            Evergreen.V25.Pages.Routes.Filter_.SortSelected (p0 |> migrate_Sorter_SorterMsg)

        Evergreen.V23.Pages.Routes.Filter_.FilterMsg p0 ->
            Evergreen.V25.Pages.Routes.Filter_.FilterMsg (p0 |> migrate_Filter_Msg)

        Evergreen.V23.Pages.Routes.Filter_.RouteEditPaneMsg p0 p1 ->
            Evergreen.V25.Pages.Routes.Filter_.RouteEditPaneMsg (p0 |> migrate_Route_RouteId)
                (p1 |> migrate_RouteEditPane_Msg)

        Evergreen.V23.Pages.Routes.Filter_.GalleryMsg p0 ->
            Evergreen.V25.Pages.Routes.Filter_.GalleryMsg (p0 |> migrate_ImageGallery_Msg)

        Evergreen.V23.Pages.Routes.Filter_.ThumbnailPressed p0 p1 ->
            Evergreen.V25.Pages.Routes.Filter_.ThumbnailPressed p0 p1


migrate_Pages_SignIn_SignInDest__FieldType : Evergreen.V23.Pages.SignIn.SignInDest_.FieldType -> Evergreen.V25.Pages.SignIn.SignInDest_.FieldType
migrate_Pages_SignIn_SignInDest__FieldType old =
    case old of
        Evergreen.V23.Pages.SignIn.SignInDest_.UsernameField ->
            Evergreen.V25.Pages.SignIn.SignInDest_.UsernameField

        Evergreen.V23.Pages.SignIn.SignInDest_.PasswordField ->
            Evergreen.V25.Pages.SignIn.SignInDest_.PasswordField


migrate_Pages_SignIn_SignInDest__Model : Evergreen.V23.Pages.SignIn.SignInDest_.Model -> Evergreen.V25.Pages.SignIn.SignInDest_.Model
migrate_Pages_SignIn_SignInDest__Model old =
    old


migrate_Pages_SignIn_SignInDest__Msg : Evergreen.V23.Pages.SignIn.SignInDest_.Msg -> Evergreen.V25.Pages.SignIn.SignInDest_.Msg
migrate_Pages_SignIn_SignInDest__Msg old =
    case old of
        Evergreen.V23.Pages.SignIn.SignInDest_.ClickedSignIn ->
            Evergreen.V25.Pages.SignIn.SignInDest_.ClickedSignIn

        Evergreen.V23.Pages.SignIn.SignInDest_.FieldChanged p0 p1 ->
            Evergreen.V25.Pages.SignIn.SignInDest_.FieldChanged (p0 |> migrate_Pages_SignIn_SignInDest__FieldType)
                p1

        Evergreen.V23.Pages.SignIn.SignInDest_.ToggleShowPassword ->
            Evergreen.V25.Pages.SignIn.SignInDest_.ToggleShowPassword

        Evergreen.V23.Pages.SignIn.SignInDest_.WrongUsernameOrPassword ->
            Evergreen.V25.Pages.SignIn.SignInDest_.WrongUsernameOrPassword


migrate_Pages_Stats_Model : Evergreen.V23.Pages.Stats.Model -> Evergreen.V25.Pages.Stats.Model
migrate_Pages_Stats_Model old =
    old


migrate_Pages_Stats_Msg : Evergreen.V23.Pages.Stats.Msg -> Evergreen.V25.Pages.Stats.Msg
migrate_Pages_Stats_Msg old =
    case old of
        Evergreen.V23.Pages.Stats.ReplaceMe ->
            Evergreen.V25.Pages.Stats.ReplaceMe


migrate_RouteEditPane_Model : Evergreen.V23.RouteEditPane.Model -> Evergreen.V25.RouteEditPane.Model
migrate_RouteEditPane_Model old =
    { route = old.route |> migrate_Route_NewRouteData
    , datePickerModel = old.datePickerModel
    , datePickerText = old.datePickerText
    , picturesText = old.picturesText
    , tagText = old.tagText
    }


migrate_RouteEditPane_Msg : Evergreen.V23.RouteEditPane.Msg -> Evergreen.V25.RouteEditPane.Msg
migrate_RouteEditPane_Msg old =
    case old of
        Evergreen.V23.RouteEditPane.FieldUpdated p0 p1 ->
            Evergreen.V25.RouteEditPane.FieldUpdated p0 p1

        Evergreen.V23.RouteEditPane.DatePickerUpdate p0 ->
            Evergreen.V25.RouteEditPane.DatePickerUpdate p0

        Evergreen.V23.RouteEditPane.AddTagPressed p0 ->
            Evergreen.V25.RouteEditPane.AddTagPressed p0

        Evergreen.V23.RouteEditPane.RemoveTagPressed p0 ->
            Evergreen.V25.RouteEditPane.RemoveTagPressed p0


migrate_Route_ClimbType : Evergreen.V23.Route.ClimbType -> Evergreen.V25.Route.ClimbType
migrate_Route_ClimbType old =
    case old of
        Evergreen.V23.Route.Trad ->
            Evergreen.V25.Route.Trad

        Evergreen.V23.Route.Sport ->
            Evergreen.V25.Route.Sport

        Evergreen.V23.Route.Boulder ->
            Evergreen.V25.Route.Boulder

        Evergreen.V23.Route.Mix ->
            Evergreen.V25.Route.Mix

        Evergreen.V23.Route.Aid ->
            Evergreen.V25.Route.Aid


migrate_Route_NewRouteData : Evergreen.V23.Route.NewRouteData -> Evergreen.V25.Route.NewRouteData
migrate_Route_NewRouteData old =
    { name = old.name
    , area = old.area
    , grade = old.grade
    , notes = old.notes
    , tags = old.tags
    , tickDate2 = old.tickDate2
    , type_ = old.type_ |> migrate_Route_ClimbType
    , images = old.images
    , videos = old.videos
    }


migrate_Route_RouteData : Evergreen.V23.Route.RouteData -> Evergreen.V25.Route.RouteData
migrate_Route_RouteData old =
    { name = old.name
    , area = old.area
    , grade = old.grade
    , notes = old.notes
    , tags = old.tags
    , tickDate2 = old.tickDate2
    , type_ = old.type_ |> migrate_Route_ClimbType
    , images = old.images
    , videos = old.videos
    , id = old.id |> migrate_Route_RouteId
    }


migrate_Route_RouteId : Evergreen.V23.Route.RouteId -> Evergreen.V25.Route.RouteId
migrate_Route_RouteId old =
    case old of
        Evergreen.V23.Route.RouteId p0 ->
            Evergreen.V25.Route.RouteId p0


migrate_Shared_Model : Evergreen.V23.Shared.Model -> Evergreen.V25.Shared.Model
migrate_Shared_Model old =
    { routes = old.routes |> List.map migrate_Route_RouteData
    , user = old.user |> Maybe.map migrate_Shared_User
    , currentDate = old.currentDate
    }


migrate_Shared_Msg : Evergreen.V23.Shared.Msg -> Evergreen.V25.Shared.Msg
migrate_Shared_Msg old =
    case old of
        Evergreen.V23.Shared.Noop ->
            Evergreen.V25.Shared.Noop

        Evergreen.V23.Shared.MsgFromBackend p0 ->
            Evergreen.V25.Shared.MsgFromBackend (p0 |> migrate_Shared_SharedFromBackend)

        Evergreen.V23.Shared.SetCurrentDate p0 ->
            Evergreen.V25.Shared.SetCurrentDate p0


migrate_Shared_SharedFromBackend : Evergreen.V23.Shared.SharedFromBackend -> Evergreen.V25.Shared.SharedFromBackend
migrate_Shared_SharedFromBackend old =
    case old of
        Evergreen.V23.Shared.AllRoutesAnnouncement p0 ->
            Evergreen.V25.Shared.AllRoutesAnnouncement (p0 |> List.map migrate_Route_RouteData)

        Evergreen.V23.Shared.LogOut ->
            Evergreen.V25.Shared.LogOut

        Evergreen.V23.Shared.YouAreAdmin ->
            Evergreen.V25.Shared.YouAreAdmin


migrate_Shared_User : Evergreen.V23.Shared.User -> Evergreen.V25.Shared.User
migrate_Shared_User old =
    case old of
        Evergreen.V23.Shared.NormalUser ->
            Evergreen.V25.Shared.NormalUser

        Evergreen.V23.Shared.AdminUser ->
            Evergreen.V25.Shared.AdminUser


migrate_Sorter_Model : Evergreen.V23.Sorter.Model -> Evergreen.V25.Sorter.Model
migrate_Sorter_Model old =
    old |> List.map (Tuple.mapBoth migrate_Sorter_SortAttribute migrate_Sorter_SortOrder)


migrate_Sorter_SortAttribute : Evergreen.V23.Sorter.SortAttribute -> Evergreen.V25.Sorter.SortAttribute
migrate_Sorter_SortAttribute old =
    case old of
        Evergreen.V23.Sorter.Area ->
            Evergreen.V25.Sorter.Area

        Evergreen.V23.Sorter.Grade ->
            Evergreen.V25.Sorter.Grade

        Evergreen.V23.Sorter.Tickdate ->
            Evergreen.V25.Sorter.Tickdate

        Evergreen.V23.Sorter.Name ->
            Evergreen.V25.Sorter.Name


migrate_Sorter_SortOrder : Evergreen.V23.Sorter.SortOrder -> Evergreen.V25.Sorter.SortOrder
migrate_Sorter_SortOrder old =
    case old of
        Evergreen.V23.Sorter.Ascending ->
            Evergreen.V25.Sorter.Ascending

        Evergreen.V23.Sorter.Descending ->
            Evergreen.V25.Sorter.Descending


migrate_Sorter_SorterMsg : Evergreen.V23.Sorter.SorterMsg -> Evergreen.V25.Sorter.SorterMsg
migrate_Sorter_SorterMsg old =
    case old of
        Evergreen.V23.Sorter.SorterMsg p0 ->
            Evergreen.V25.Sorter.SorterMsg p0

        Evergreen.V23.Sorter.RemoveRow p0 ->
            Evergreen.V25.Sorter.RemoveRow p0


migrate_Types_FrontendMsg : Evergreen.V23.Types.FrontendMsg -> Evergreen.V25.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V23.Types.ClickedLink p0 ->
            Evergreen.V25.Types.ClickedLink p0

        Evergreen.V23.Types.ChangedUrl p0 ->
            Evergreen.V25.Types.ChangedUrl p0

        Evergreen.V23.Types.Shared p0 ->
            Evergreen.V25.Types.Shared (p0 |> migrate_Shared_Msg)

        Evergreen.V23.Types.Page p0 ->
            Evergreen.V25.Types.Page (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V23.Types.NoOpFrontendMsg ->
            Evergreen.V25.Types.NoOpFrontendMsg