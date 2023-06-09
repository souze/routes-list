module Evergreen.V18.Gen.Msg exposing (..)

import Evergreen.V18.Pages.Admin.AddUser
import Evergreen.V18.Pages.Admin.ChangePassword
import Evergreen.V18.Pages.Admin.Home_
import Evergreen.V18.Pages.Admin.RemoveUser
import Evergreen.V18.Pages.Admin.ShowJson
import Evergreen.V18.Pages.ChangePassword
import Evergreen.V18.Pages.Home_
import Evergreen.V18.Pages.InputJson
import Evergreen.V18.Pages.MoreOptions
import Evergreen.V18.Pages.NewRoute
import Evergreen.V18.Pages.OutputJson
import Evergreen.V18.Pages.Routes.Filter_
import Evergreen.V18.Pages.SignIn.SignInDest_
import Evergreen.V18.Pages.Stats


type Msg
    = ChangePassword Evergreen.V18.Pages.ChangePassword.Msg
    | Home_ Evergreen.V18.Pages.Home_.Msg
    | InputJson Evergreen.V18.Pages.InputJson.Msg
    | MoreOptions Evergreen.V18.Pages.MoreOptions.Msg
    | NewRoute Evergreen.V18.Pages.NewRoute.Msg
    | OutputJson Evergreen.V18.Pages.OutputJson.Msg
    | Stats Evergreen.V18.Pages.Stats.Msg
    | Admin__AddUser Evergreen.V18.Pages.Admin.AddUser.Msg
    | Admin__ChangePassword Evergreen.V18.Pages.Admin.ChangePassword.Msg
    | Admin__Home_ Evergreen.V18.Pages.Admin.Home_.Msg
    | Admin__RemoveUser Evergreen.V18.Pages.Admin.RemoveUser.Msg
    | Admin__ShowJson Evergreen.V18.Pages.Admin.ShowJson.Msg
    | Routes__Filter_ Evergreen.V18.Pages.Routes.Filter_.Msg
    | SignIn__SignInDest_ Evergreen.V18.Pages.SignIn.SignInDest_.Msg
