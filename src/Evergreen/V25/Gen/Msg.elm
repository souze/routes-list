module Evergreen.V25.Gen.Msg exposing (..)

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


type Msg
    = ChangePassword Evergreen.V25.Pages.ChangePassword.Msg
    | Home_ Evergreen.V25.Pages.Home_.Msg
    | InputJson Evergreen.V25.Pages.InputJson.Msg
    | MoreOptions Evergreen.V25.Pages.MoreOptions.Msg
    | NewRoute Evergreen.V25.Pages.NewRoute.Msg
    | OutputJson Evergreen.V25.Pages.OutputJson.Msg
    | Stats Evergreen.V25.Pages.Stats.Msg
    | Admin__AddUser Evergreen.V25.Pages.Admin.AddUser.Msg
    | Admin__ChangePassword Evergreen.V25.Pages.Admin.ChangePassword.Msg
    | Admin__Home_ Evergreen.V25.Pages.Admin.Home_.Msg
    | Admin__RemoveUser Evergreen.V25.Pages.Admin.RemoveUser.Msg
    | Admin__ShowJson Evergreen.V25.Pages.Admin.ShowJson.Msg
    | Routes__Filter_ Evergreen.V25.Pages.Routes.Filter_.Msg
    | SignIn__SignInDest_ Evergreen.V25.Pages.SignIn.SignInDest_.Msg
