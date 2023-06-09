module Evergreen.V18.Gen.Model exposing (..)

import Evergreen.V18.Gen.Params.Admin.AddUser
import Evergreen.V18.Gen.Params.Admin.ChangePassword
import Evergreen.V18.Gen.Params.Admin.Home_
import Evergreen.V18.Gen.Params.Admin.RemoveUser
import Evergreen.V18.Gen.Params.Admin.ShowJson
import Evergreen.V18.Gen.Params.ChangePassword
import Evergreen.V18.Gen.Params.Home_
import Evergreen.V18.Gen.Params.InputJson
import Evergreen.V18.Gen.Params.MoreOptions
import Evergreen.V18.Gen.Params.NewRoute
import Evergreen.V18.Gen.Params.NotFound
import Evergreen.V18.Gen.Params.OutputJson
import Evergreen.V18.Gen.Params.Routes.Filter_
import Evergreen.V18.Gen.Params.SignIn.SignInDest_
import Evergreen.V18.Gen.Params.Stats
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


type Model
    = Redirecting_
    | ChangePassword Evergreen.V18.Gen.Params.ChangePassword.Params Evergreen.V18.Pages.ChangePassword.Model
    | Home_ Evergreen.V18.Gen.Params.Home_.Params Evergreen.V18.Pages.Home_.Model
    | InputJson Evergreen.V18.Gen.Params.InputJson.Params Evergreen.V18.Pages.InputJson.Model
    | MoreOptions Evergreen.V18.Gen.Params.MoreOptions.Params Evergreen.V18.Pages.MoreOptions.Model
    | NewRoute Evergreen.V18.Gen.Params.NewRoute.Params Evergreen.V18.Pages.NewRoute.Model
    | OutputJson Evergreen.V18.Gen.Params.OutputJson.Params Evergreen.V18.Pages.OutputJson.Model
    | Stats Evergreen.V18.Gen.Params.Stats.Params Evergreen.V18.Pages.Stats.Model
    | Admin__AddUser Evergreen.V18.Gen.Params.Admin.AddUser.Params Evergreen.V18.Pages.Admin.AddUser.Model
    | Admin__ChangePassword Evergreen.V18.Gen.Params.Admin.ChangePassword.Params Evergreen.V18.Pages.Admin.ChangePassword.Model
    | Admin__Home_ Evergreen.V18.Gen.Params.Admin.Home_.Params Evergreen.V18.Pages.Admin.Home_.Model
    | Admin__RemoveUser Evergreen.V18.Gen.Params.Admin.RemoveUser.Params Evergreen.V18.Pages.Admin.RemoveUser.Model
    | Admin__ShowJson Evergreen.V18.Gen.Params.Admin.ShowJson.Params Evergreen.V18.Pages.Admin.ShowJson.Model
    | Routes__Filter_ Evergreen.V18.Gen.Params.Routes.Filter_.Params Evergreen.V18.Pages.Routes.Filter_.Model
    | SignIn__SignInDest_ Evergreen.V18.Gen.Params.SignIn.SignInDest_.Params Evergreen.V18.Pages.SignIn.SignInDest_.Model
    | NotFound Evergreen.V18.Gen.Params.NotFound.Params
