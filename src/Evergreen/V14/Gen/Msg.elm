module Evergreen.V14.Gen.Msg exposing (..)

import Evergreen.V14.Pages.Admin.AddUser
import Evergreen.V14.Pages.Admin.ChangePassword
import Evergreen.V14.Pages.Admin.Home_
import Evergreen.V14.Pages.Admin.RemoveUser
import Evergreen.V14.Pages.Admin.ShowJson
import Evergreen.V14.Pages.ChangePassword
import Evergreen.V14.Pages.Home_
import Evergreen.V14.Pages.InputJson
import Evergreen.V14.Pages.MoreOptions
import Evergreen.V14.Pages.NewRoute
import Evergreen.V14.Pages.OutputJson
import Evergreen.V14.Pages.Routes.Filter_
import Evergreen.V14.Pages.SignIn.SignInDest_
import Evergreen.V14.Pages.Stats


type Msg
    = ChangePassword Evergreen.V14.Pages.ChangePassword.Msg
    | Home_ Evergreen.V14.Pages.Home_.Msg
    | InputJson Evergreen.V14.Pages.InputJson.Msg
    | MoreOptions Evergreen.V14.Pages.MoreOptions.Msg
    | NewRoute Evergreen.V14.Pages.NewRoute.Msg
    | OutputJson Evergreen.V14.Pages.OutputJson.Msg
    | Stats Evergreen.V14.Pages.Stats.Msg
    | Admin__AddUser Evergreen.V14.Pages.Admin.AddUser.Msg
    | Admin__ChangePassword Evergreen.V14.Pages.Admin.ChangePassword.Msg
    | Admin__Home_ Evergreen.V14.Pages.Admin.Home_.Msg
    | Admin__RemoveUser Evergreen.V14.Pages.Admin.RemoveUser.Msg
    | Admin__ShowJson Evergreen.V14.Pages.Admin.ShowJson.Msg
    | Routes__Filter_ Evergreen.V14.Pages.Routes.Filter_.Msg
    | SignIn__SignInDest_ Evergreen.V14.Pages.SignIn.SignInDest_.Msg
