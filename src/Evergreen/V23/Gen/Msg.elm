module Evergreen.V23.Gen.Msg exposing (..)

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


type Msg
    = ChangePassword Evergreen.V23.Pages.ChangePassword.Msg
    | Home_ Evergreen.V23.Pages.Home_.Msg
    | InputJson Evergreen.V23.Pages.InputJson.Msg
    | MoreOptions Evergreen.V23.Pages.MoreOptions.Msg
    | NewRoute Evergreen.V23.Pages.NewRoute.Msg
    | OutputJson Evergreen.V23.Pages.OutputJson.Msg
    | Stats Evergreen.V23.Pages.Stats.Msg
    | Admin__AddUser Evergreen.V23.Pages.Admin.AddUser.Msg
    | Admin__ChangePassword Evergreen.V23.Pages.Admin.ChangePassword.Msg
    | Admin__Home_ Evergreen.V23.Pages.Admin.Home_.Msg
    | Admin__RemoveUser Evergreen.V23.Pages.Admin.RemoveUser.Msg
    | Admin__ShowJson Evergreen.V23.Pages.Admin.ShowJson.Msg
    | Routes__Filter_ Evergreen.V23.Pages.Routes.Filter_.Msg
    | SignIn__SignInDest_ Evergreen.V23.Pages.SignIn.SignInDest_.Msg
