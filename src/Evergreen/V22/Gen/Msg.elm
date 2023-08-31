module Evergreen.V22.Gen.Msg exposing (..)

import Evergreen.V22.Pages.Admin.AddUser
import Evergreen.V22.Pages.Admin.ChangePassword
import Evergreen.V22.Pages.Admin.Home_
import Evergreen.V22.Pages.Admin.RemoveUser
import Evergreen.V22.Pages.Admin.ShowJson
import Evergreen.V22.Pages.ChangePassword
import Evergreen.V22.Pages.Home_
import Evergreen.V22.Pages.InputJson
import Evergreen.V22.Pages.MoreOptions
import Evergreen.V22.Pages.NewRoute
import Evergreen.V22.Pages.OutputJson
import Evergreen.V22.Pages.Routes.Filter_
import Evergreen.V22.Pages.SignIn.SignInDest_
import Evergreen.V22.Pages.Stats


type Msg
    = ChangePassword Evergreen.V22.Pages.ChangePassword.Msg
    | Home_ Evergreen.V22.Pages.Home_.Msg
    | InputJson Evergreen.V22.Pages.InputJson.Msg
    | MoreOptions Evergreen.V22.Pages.MoreOptions.Msg
    | NewRoute Evergreen.V22.Pages.NewRoute.Msg
    | OutputJson Evergreen.V22.Pages.OutputJson.Msg
    | Stats Evergreen.V22.Pages.Stats.Msg
    | Admin__AddUser Evergreen.V22.Pages.Admin.AddUser.Msg
    | Admin__ChangePassword Evergreen.V22.Pages.Admin.ChangePassword.Msg
    | Admin__Home_ Evergreen.V22.Pages.Admin.Home_.Msg
    | Admin__RemoveUser Evergreen.V22.Pages.Admin.RemoveUser.Msg
    | Admin__ShowJson Evergreen.V22.Pages.Admin.ShowJson.Msg
    | Routes__Filter_ Evergreen.V22.Pages.Routes.Filter_.Msg
    | SignIn__SignInDest_ Evergreen.V22.Pages.SignIn.SignInDest_.Msg
