module Evergreen.V26.Main.Pages.Model exposing (..)

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


type Model
    = Home_ Evergreen.V26.Pages.Home_.Model
    | Admin Evergreen.V26.Pages.Admin.Model
    | Admin_AddUser Evergreen.V26.Pages.Admin.AddUser.Model
    | Admin_ChangePassword Evergreen.V26.Pages.Admin.ChangePassword.Model
    | Admin_RemoveUser Evergreen.V26.Pages.Admin.RemoveUser.Model
    | Admin_ShowJson Evergreen.V26.Pages.Admin.ShowJson.Model
    | ChangePassword Evergreen.V26.Pages.ChangePassword.Model
    | InputJson Evergreen.V26.Pages.InputJson.Model
    | MoreOptions Evergreen.V26.Pages.MoreOptions.Model
    | NewRoute Evergreen.V26.Pages.NewRoute.Model
    | OutputJson Evergreen.V26.Pages.OutputJson.Model
    | Routes_Filter_
        { filter : String
        }
        Evergreen.V26.Pages.Routes.Filter_.Model
    | SignIn Evergreen.V26.Pages.SignIn.Model
    | Stats Evergreen.V26.Pages.Stats.Model
    | NotFound_ Evergreen.V26.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
