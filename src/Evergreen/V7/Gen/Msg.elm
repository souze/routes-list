module Evergreen.V7.Gen.Msg exposing (..)

import Evergreen.V7.Pages.Admin.AddUser
import Evergreen.V7.Pages.Admin.ChangePassword
import Evergreen.V7.Pages.Admin.Home_
import Evergreen.V7.Pages.Admin.RemoveUser
import Evergreen.V7.Pages.Admin.ShowJson
import Evergreen.V7.Pages.ChangePassword
import Evergreen.V7.Pages.Home_
import Evergreen.V7.Pages.InputJson
import Evergreen.V7.Pages.MoreOptions
import Evergreen.V7.Pages.NewRoute
import Evergreen.V7.Pages.OutputJson
import Evergreen.V7.Pages.Routes.Filter_
import Evergreen.V7.Pages.SignIn


type Msg
    = ChangePassword Evergreen.V7.Pages.ChangePassword.Msg
    | Home_ Evergreen.V7.Pages.Home_.Msg
    | InputJson Evergreen.V7.Pages.InputJson.Msg
    | MoreOptions Evergreen.V7.Pages.MoreOptions.Msg
    | NewRoute Evergreen.V7.Pages.NewRoute.Msg
    | OutputJson Evergreen.V7.Pages.OutputJson.Msg
    | SignIn Evergreen.V7.Pages.SignIn.Msg
    | Admin__AddUser Evergreen.V7.Pages.Admin.AddUser.Msg
    | Admin__ChangePassword Evergreen.V7.Pages.Admin.ChangePassword.Msg
    | Admin__Home_ Evergreen.V7.Pages.Admin.Home_.Msg
    | Admin__RemoveUser Evergreen.V7.Pages.Admin.RemoveUser.Msg
    | Admin__ShowJson Evergreen.V7.Pages.Admin.ShowJson.Msg
    | Routes__Filter_ Evergreen.V7.Pages.Routes.Filter_.Msg
