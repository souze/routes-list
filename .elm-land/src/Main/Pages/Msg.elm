module Main.Pages.Msg exposing (Msg(..))

import Pages.Home_
import Pages.Admin.AddUser
import Pages.Admin.ChangePassword
import Pages.Admin.RemoveUser
import Pages.Admin.ShowJson
import Pages.Admin.Home_
import Pages.ChangePassword
import Pages.InputJson
import Pages.MoreOptions
import Pages.NewRoute
import Pages.OutputJson
import Pages.Routes.Filter_
import Pages.SignIn.SignInDest_
import Pages.Stats
import Pages.NotFound_


type Msg
    = Home_ Pages.Home_.Msg
    | Admin_AddUser Pages.Admin.AddUser.Msg
    | Admin_ChangePassword Pages.Admin.ChangePassword.Msg
    | Admin_RemoveUser Pages.Admin.RemoveUser.Msg
    | Admin_ShowJson Pages.Admin.ShowJson.Msg
    | Admin_Home_ Pages.Admin.Home_.Msg
    | ChangePassword Pages.ChangePassword.Msg
    | InputJson Pages.InputJson.Msg
    | MoreOptions Pages.MoreOptions.Msg
    | NewRoute Pages.NewRoute.Msg
    | OutputJson Pages.OutputJson.Msg
    | Routes_Filter_ Pages.Routes.Filter_.Msg
    | SignIn_SignInDest_ Pages.SignIn.SignInDest_.Msg
    | Stats Pages.Stats.Msg
    | NotFound_ Pages.NotFound_.Msg
