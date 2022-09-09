module Evergreen.V6.Gen.Msg exposing (..)

import Evergreen.V6.Pages.Admin.AddUser
import Evergreen.V6.Pages.Admin.ChangePassword
import Evergreen.V6.Pages.Admin.Home_
import Evergreen.V6.Pages.Admin.RemoveUser
import Evergreen.V6.Pages.Admin.ShowJson
import Evergreen.V6.Pages.ChangePassword
import Evergreen.V6.Pages.InputJson
import Evergreen.V6.Pages.MoreOptions
import Evergreen.V6.Pages.NewRoute
import Evergreen.V6.Pages.OutputJson
import Evergreen.V6.Pages.Routes.Filter_
import Evergreen.V6.Pages.SignIn


type Msg
    = ChangePassword Evergreen.V6.Pages.ChangePassword.Msg
    | InputJson Evergreen.V6.Pages.InputJson.Msg
    | MoreOptions Evergreen.V6.Pages.MoreOptions.Msg
    | NewRoute Evergreen.V6.Pages.NewRoute.Msg
    | OutputJson Evergreen.V6.Pages.OutputJson.Msg
    | SignIn Evergreen.V6.Pages.SignIn.Msg
    | Admin__AddUser Evergreen.V6.Pages.Admin.AddUser.Msg
    | Admin__ChangePassword Evergreen.V6.Pages.Admin.ChangePassword.Msg
    | Admin__Home_ Evergreen.V6.Pages.Admin.Home_.Msg
    | Admin__RemoveUser Evergreen.V6.Pages.Admin.RemoveUser.Msg
    | Admin__ShowJson Evergreen.V6.Pages.Admin.ShowJson.Msg
    | Routes__Filter_ Evergreen.V6.Pages.Routes.Filter_.Msg
