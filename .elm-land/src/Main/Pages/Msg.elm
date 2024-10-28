module Main.Pages.Msg exposing (Msg(..))

import Pages.Home_
import Pages.Admin
import Pages.Admin.AddUser
import Pages.Admin.ChangePassword
import Pages.Admin.RemoveUser
import Pages.Admin.ShowJson
import Pages.ChangePassword
import Pages.InputJson
import Pages.MoreOptions
import Pages.NewRoute
import Pages.OutputJson
import Pages.Routes.Filter_
import Pages.SignIn
import Pages.Stats
import Pages.NotFound_


type Msg
    = Home_ Pages.Home_.Msg
    | Admin Pages.Admin.Msg
    | Admin_AddUser Pages.Admin.AddUser.Msg
    | Admin_ChangePassword Pages.Admin.ChangePassword.Msg
    | Admin_RemoveUser Pages.Admin.RemoveUser.Msg
    | Admin_ShowJson Pages.Admin.ShowJson.Msg
    | ChangePassword Pages.ChangePassword.Msg
    | InputJson Pages.InputJson.Msg
    | MoreOptions Pages.MoreOptions.Msg
    | NewRoute Pages.NewRoute.Msg
    | OutputJson Pages.OutputJson.Msg
    | Routes_Filter_ Pages.Routes.Filter_.Msg
    | SignIn Pages.SignIn.Msg
    | Stats Pages.Stats.Msg
    | NotFound_ Pages.NotFound_.Msg
