module Evergreen.V12.Gen.Msg exposing (..)

import Evergreen.V12.Pages.Admin.AddUser
import Evergreen.V12.Pages.Admin.ChangePassword
import Evergreen.V12.Pages.Admin.Home_
import Evergreen.V12.Pages.Admin.RemoveUser
import Evergreen.V12.Pages.Admin.ShowJson
import Evergreen.V12.Pages.ChangePassword
import Evergreen.V12.Pages.Home_
import Evergreen.V12.Pages.InputJson
import Evergreen.V12.Pages.MoreOptions
import Evergreen.V12.Pages.NewRoute
import Evergreen.V12.Pages.OutputJson
import Evergreen.V12.Pages.Routes.Filter_
import Evergreen.V12.Pages.SignIn


type Msg
    = ChangePassword Evergreen.V12.Pages.ChangePassword.Msg
    | Home_ Evergreen.V12.Pages.Home_.Msg
    | InputJson Evergreen.V12.Pages.InputJson.Msg
    | MoreOptions Evergreen.V12.Pages.MoreOptions.Msg
    | NewRoute Evergreen.V12.Pages.NewRoute.Msg
    | OutputJson Evergreen.V12.Pages.OutputJson.Msg
    | SignIn Evergreen.V12.Pages.SignIn.Msg
    | Admin__AddUser Evergreen.V12.Pages.Admin.AddUser.Msg
    | Admin__ChangePassword Evergreen.V12.Pages.Admin.ChangePassword.Msg
    | Admin__Home_ Evergreen.V12.Pages.Admin.Home_.Msg
    | Admin__RemoveUser Evergreen.V12.Pages.Admin.RemoveUser.Msg
    | Admin__ShowJson Evergreen.V12.Pages.Admin.ShowJson.Msg
    | Routes__Filter_ Evergreen.V12.Pages.Routes.Filter_.Msg
