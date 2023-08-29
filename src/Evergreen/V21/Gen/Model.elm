module Evergreen.V21.Gen.Model exposing (..)

import Evergreen.V21.Gen.Params.Admin.AddUser
import Evergreen.V21.Gen.Params.Admin.ChangePassword
import Evergreen.V21.Gen.Params.Admin.Home_
import Evergreen.V21.Gen.Params.Admin.RemoveUser
import Evergreen.V21.Gen.Params.Admin.ShowJson
import Evergreen.V21.Gen.Params.ChangePassword
import Evergreen.V21.Gen.Params.Home_
import Evergreen.V21.Gen.Params.InputJson
import Evergreen.V21.Gen.Params.MoreOptions
import Evergreen.V21.Gen.Params.NewRoute
import Evergreen.V21.Gen.Params.NotFound
import Evergreen.V21.Gen.Params.OutputJson
import Evergreen.V21.Gen.Params.Routes.Filter_
import Evergreen.V21.Gen.Params.SignIn.SignInDest_
import Evergreen.V21.Gen.Params.Stats
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


type Model
    = Redirecting_
    | ChangePassword Evergreen.V21.Gen.Params.ChangePassword.Params Evergreen.V21.Pages.ChangePassword.Model
    | Home_ Evergreen.V21.Gen.Params.Home_.Params Evergreen.V21.Pages.Home_.Model
    | InputJson Evergreen.V21.Gen.Params.InputJson.Params Evergreen.V21.Pages.InputJson.Model
    | MoreOptions Evergreen.V21.Gen.Params.MoreOptions.Params Evergreen.V21.Pages.MoreOptions.Model
    | NewRoute Evergreen.V21.Gen.Params.NewRoute.Params Evergreen.V21.Pages.NewRoute.Model
    | OutputJson Evergreen.V21.Gen.Params.OutputJson.Params Evergreen.V21.Pages.OutputJson.Model
    | Stats Evergreen.V21.Gen.Params.Stats.Params Evergreen.V21.Pages.Stats.Model
    | Admin__AddUser Evergreen.V21.Gen.Params.Admin.AddUser.Params Evergreen.V21.Pages.Admin.AddUser.Model
    | Admin__ChangePassword Evergreen.V21.Gen.Params.Admin.ChangePassword.Params Evergreen.V21.Pages.Admin.ChangePassword.Model
    | Admin__Home_ Evergreen.V21.Gen.Params.Admin.Home_.Params Evergreen.V21.Pages.Admin.Home_.Model
    | Admin__RemoveUser Evergreen.V21.Gen.Params.Admin.RemoveUser.Params Evergreen.V21.Pages.Admin.RemoveUser.Model
    | Admin__ShowJson Evergreen.V21.Gen.Params.Admin.ShowJson.Params Evergreen.V21.Pages.Admin.ShowJson.Model
    | Routes__Filter_ Evergreen.V21.Gen.Params.Routes.Filter_.Params Evergreen.V21.Pages.Routes.Filter_.Model
    | SignIn__SignInDest_ Evergreen.V21.Gen.Params.SignIn.SignInDest_.Params Evergreen.V21.Pages.SignIn.SignInDest_.Model
    | NotFound Evergreen.V21.Gen.Params.NotFound.Params
