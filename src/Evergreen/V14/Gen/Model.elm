module Evergreen.V14.Gen.Model exposing (..)

import Evergreen.V14.Gen.Params.Admin.AddUser
import Evergreen.V14.Gen.Params.Admin.ChangePassword
import Evergreen.V14.Gen.Params.Admin.Home_
import Evergreen.V14.Gen.Params.Admin.RemoveUser
import Evergreen.V14.Gen.Params.Admin.ShowJson
import Evergreen.V14.Gen.Params.ChangePassword
import Evergreen.V14.Gen.Params.Home_
import Evergreen.V14.Gen.Params.InputJson
import Evergreen.V14.Gen.Params.MoreOptions
import Evergreen.V14.Gen.Params.NewRoute
import Evergreen.V14.Gen.Params.NotFound
import Evergreen.V14.Gen.Params.OutputJson
import Evergreen.V14.Gen.Params.Routes.Filter_
import Evergreen.V14.Gen.Params.SignIn.SignInDest_
import Evergreen.V14.Gen.Params.Stats
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


type Model
    = Redirecting_
    | ChangePassword Evergreen.V14.Gen.Params.ChangePassword.Params Evergreen.V14.Pages.ChangePassword.Model
    | Home_ Evergreen.V14.Gen.Params.Home_.Params Evergreen.V14.Pages.Home_.Model
    | InputJson Evergreen.V14.Gen.Params.InputJson.Params Evergreen.V14.Pages.InputJson.Model
    | MoreOptions Evergreen.V14.Gen.Params.MoreOptions.Params Evergreen.V14.Pages.MoreOptions.Model
    | NewRoute Evergreen.V14.Gen.Params.NewRoute.Params Evergreen.V14.Pages.NewRoute.Model
    | OutputJson Evergreen.V14.Gen.Params.OutputJson.Params Evergreen.V14.Pages.OutputJson.Model
    | Stats Evergreen.V14.Gen.Params.Stats.Params Evergreen.V14.Pages.Stats.Model
    | Admin__AddUser Evergreen.V14.Gen.Params.Admin.AddUser.Params Evergreen.V14.Pages.Admin.AddUser.Model
    | Admin__ChangePassword Evergreen.V14.Gen.Params.Admin.ChangePassword.Params Evergreen.V14.Pages.Admin.ChangePassword.Model
    | Admin__Home_ Evergreen.V14.Gen.Params.Admin.Home_.Params Evergreen.V14.Pages.Admin.Home_.Model
    | Admin__RemoveUser Evergreen.V14.Gen.Params.Admin.RemoveUser.Params Evergreen.V14.Pages.Admin.RemoveUser.Model
    | Admin__ShowJson Evergreen.V14.Gen.Params.Admin.ShowJson.Params Evergreen.V14.Pages.Admin.ShowJson.Model
    | Routes__Filter_ Evergreen.V14.Gen.Params.Routes.Filter_.Params Evergreen.V14.Pages.Routes.Filter_.Model
    | SignIn__SignInDest_ Evergreen.V14.Gen.Params.SignIn.SignInDest_.Params Evergreen.V14.Pages.SignIn.SignInDest_.Model
    | NotFound Evergreen.V14.Gen.Params.NotFound.Params
