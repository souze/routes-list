module Evergreen.V17.Gen.Msg exposing (..)

import Evergreen.V17.Pages.Admin.AddUser
import Evergreen.V17.Pages.Admin.ChangePassword
import Evergreen.V17.Pages.Admin.Home_
import Evergreen.V17.Pages.Admin.RemoveUser
import Evergreen.V17.Pages.Admin.ShowJson
import Evergreen.V17.Pages.ChangePassword
import Evergreen.V17.Pages.Home_
import Evergreen.V17.Pages.InputJson
import Evergreen.V17.Pages.MoreOptions
import Evergreen.V17.Pages.NewRoute
import Evergreen.V17.Pages.OutputJson
import Evergreen.V17.Pages.Routes.Filter_
import Evergreen.V17.Pages.SignIn.SignInDest_
import Evergreen.V17.Pages.Stats


type Msg
    = ChangePassword Evergreen.V17.Pages.ChangePassword.Msg
    | Home_ Evergreen.V17.Pages.Home_.Msg
    | InputJson Evergreen.V17.Pages.InputJson.Msg
    | MoreOptions Evergreen.V17.Pages.MoreOptions.Msg
    | NewRoute Evergreen.V17.Pages.NewRoute.Msg
    | OutputJson Evergreen.V17.Pages.OutputJson.Msg
    | Stats Evergreen.V17.Pages.Stats.Msg
    | Admin__AddUser Evergreen.V17.Pages.Admin.AddUser.Msg
    | Admin__ChangePassword Evergreen.V17.Pages.Admin.ChangePassword.Msg
    | Admin__Home_ Evergreen.V17.Pages.Admin.Home_.Msg
    | Admin__RemoveUser Evergreen.V17.Pages.Admin.RemoveUser.Msg
    | Admin__ShowJson Evergreen.V17.Pages.Admin.ShowJson.Msg
    | Routes__Filter_ Evergreen.V17.Pages.Routes.Filter_.Msg
    | SignIn__SignInDest_ Evergreen.V17.Pages.SignIn.SignInDest_.Msg
