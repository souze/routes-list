module Evergreen.V21.Gen.Msg exposing (..)

import Evergreen.V21.Pages.Admin.AddUser
import Evergreen.V21.Pages.Admin.ChangePassword
import Evergreen.V21.Pages.Admin.Home_
import Evergreen.V21.Pages.Admin.RemoveUser
import Evergreen.V21.Pages.Admin.ShowJson
import Evergreen.V21.Pages.ChangePassword
import Evergreen.V21.Pages.Home_
import Evergreen.V21.Pages.InputJson
import Evergreen.V21.Pages.MoreOptions
import Evergreen.V21.Pages.NewRoute
import Evergreen.V21.Pages.OutputJson
import Evergreen.V21.Pages.Routes.Filter_
import Evergreen.V21.Pages.SignIn.SignInDest_
import Evergreen.V21.Pages.Stats


type Msg
    = ChangePassword Evergreen.V21.Pages.ChangePassword.Msg
    | Home_ Evergreen.V21.Pages.Home_.Msg
    | InputJson Evergreen.V21.Pages.InputJson.Msg
    | MoreOptions Evergreen.V21.Pages.MoreOptions.Msg
    | NewRoute Evergreen.V21.Pages.NewRoute.Msg
    | OutputJson Evergreen.V21.Pages.OutputJson.Msg
    | Stats Evergreen.V21.Pages.Stats.Msg
    | Admin__AddUser Evergreen.V21.Pages.Admin.AddUser.Msg
    | Admin__ChangePassword Evergreen.V21.Pages.Admin.ChangePassword.Msg
    | Admin__Home_ Evergreen.V21.Pages.Admin.Home_.Msg
    | Admin__RemoveUser Evergreen.V21.Pages.Admin.RemoveUser.Msg
    | Admin__ShowJson Evergreen.V21.Pages.Admin.ShowJson.Msg
    | Routes__Filter_ Evergreen.V21.Pages.Routes.Filter_.Msg
    | SignIn__SignInDest_ Evergreen.V21.Pages.SignIn.SignInDest_.Msg
