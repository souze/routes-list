module Evergreen.V26.Main.Pages.Msg exposing (..)

import Evergreen.V26.Pages.Admin
import Evergreen.V26.Pages.Admin.AddUser
import Evergreen.V26.Pages.Admin.ChangePassword
import Evergreen.V26.Pages.Admin.RemoveUser
import Evergreen.V26.Pages.Admin.ShowJson
import Evergreen.V26.Pages.ChangePassword
import Evergreen.V26.Pages.Home_
import Evergreen.V26.Pages.InputJson
import Evergreen.V26.Pages.MoreOptions
import Evergreen.V26.Pages.NewRoute
import Evergreen.V26.Pages.NotFound_
import Evergreen.V26.Pages.OutputJson
import Evergreen.V26.Pages.Routes.Filter_
import Evergreen.V26.Pages.SignIn
import Evergreen.V26.Pages.Stats


type Msg
    = Home_ Evergreen.V26.Pages.Home_.Msg
    | Admin Evergreen.V26.Pages.Admin.Msg
    | Admin_AddUser Evergreen.V26.Pages.Admin.AddUser.Msg
    | Admin_ChangePassword Evergreen.V26.Pages.Admin.ChangePassword.Msg
    | Admin_RemoveUser Evergreen.V26.Pages.Admin.RemoveUser.Msg
    | Admin_ShowJson Evergreen.V26.Pages.Admin.ShowJson.Msg
    | ChangePassword Evergreen.V26.Pages.ChangePassword.Msg
    | InputJson Evergreen.V26.Pages.InputJson.Msg
    | MoreOptions Evergreen.V26.Pages.MoreOptions.Msg
    | NewRoute Evergreen.V26.Pages.NewRoute.Msg
    | OutputJson Evergreen.V26.Pages.OutputJson.Msg
    | Routes_Filter_ Evergreen.V26.Pages.Routes.Filter_.Msg
    | SignIn Evergreen.V26.Pages.SignIn.Msg
    | Stats Evergreen.V26.Pages.Stats.Msg
    | NotFound_ Evergreen.V26.Pages.NotFound_.Msg
