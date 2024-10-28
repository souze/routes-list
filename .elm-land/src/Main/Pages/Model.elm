module Main.Pages.Model exposing (Model(..))

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
import View exposing (View)


type Model
    = Home_ Pages.Home_.Model
    | Admin Pages.Admin.Model
    | Admin_AddUser Pages.Admin.AddUser.Model
    | Admin_ChangePassword Pages.Admin.ChangePassword.Model
    | Admin_RemoveUser Pages.Admin.RemoveUser.Model
    | Admin_ShowJson Pages.Admin.ShowJson.Model
    | ChangePassword Pages.ChangePassword.Model
    | InputJson Pages.InputJson.Model
    | MoreOptions Pages.MoreOptions.Model
    | NewRoute Pages.NewRoute.Model
    | OutputJson Pages.OutputJson.Model
    | Routes_Filter_ { filter : String } Pages.Routes.Filter_.Model
    | SignIn Pages.SignIn.Model
    | Stats Pages.Stats.Model
    | NotFound_ Pages.NotFound_.Model
    | Redirecting_
    | Loading_
