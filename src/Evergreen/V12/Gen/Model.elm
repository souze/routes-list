module Evergreen.V12.Gen.Model exposing (..)

import Evergreen.V12.Gen.Params.Admin.AddUser
import Evergreen.V12.Gen.Params.Admin.ChangePassword
import Evergreen.V12.Gen.Params.Admin.Home_
import Evergreen.V12.Gen.Params.Admin.RemoveUser
import Evergreen.V12.Gen.Params.Admin.ShowJson
import Evergreen.V12.Gen.Params.ChangePassword
import Evergreen.V12.Gen.Params.Home_
import Evergreen.V12.Gen.Params.InputJson
import Evergreen.V12.Gen.Params.MoreOptions
import Evergreen.V12.Gen.Params.NewRoute
import Evergreen.V12.Gen.Params.NotFound
import Evergreen.V12.Gen.Params.OutputJson
import Evergreen.V12.Gen.Params.Routes.Filter_
import Evergreen.V12.Gen.Params.SignIn
import Evergreen.V12.Pages.Admin.AddUser
import Evergreen.V12.Pages.Admin.ChangePassword
import Evergreen.V12.Pages.Admin.Home_
import Evergreen.V12.Pages.Admin.RemoveUser
import Evergreen.V12.Pages.Admin.ShowJson
import Evergreen.V12.Pages.ChangePassword
import Evergreen.V12.Pages.Home_
import Evergreen.V12.Pages.InputJson
import Evergreen.V12.Pages.MoreOptions
import Evergreen.V12.Pages.NewRoute
import Evergreen.V12.Pages.OutputJson
import Evergreen.V12.Pages.Routes.Filter_
import Evergreen.V12.Pages.SignIn


type Model
    = Redirecting_
    | ChangePassword Evergreen.V12.Gen.Params.ChangePassword.Params Evergreen.V12.Pages.ChangePassword.Model
    | Home_ Evergreen.V12.Gen.Params.Home_.Params Evergreen.V12.Pages.Home_.Model
    | InputJson Evergreen.V12.Gen.Params.InputJson.Params Evergreen.V12.Pages.InputJson.Model
    | MoreOptions Evergreen.V12.Gen.Params.MoreOptions.Params Evergreen.V12.Pages.MoreOptions.Model
    | NewRoute Evergreen.V12.Gen.Params.NewRoute.Params Evergreen.V12.Pages.NewRoute.Model
    | OutputJson Evergreen.V12.Gen.Params.OutputJson.Params Evergreen.V12.Pages.OutputJson.Model
    | SignIn Evergreen.V12.Gen.Params.SignIn.Params Evergreen.V12.Pages.SignIn.Model
    | Admin__AddUser Evergreen.V12.Gen.Params.Admin.AddUser.Params Evergreen.V12.Pages.Admin.AddUser.Model
    | Admin__ChangePassword Evergreen.V12.Gen.Params.Admin.ChangePassword.Params Evergreen.V12.Pages.Admin.ChangePassword.Model
    | Admin__Home_ Evergreen.V12.Gen.Params.Admin.Home_.Params Evergreen.V12.Pages.Admin.Home_.Model
    | Admin__RemoveUser Evergreen.V12.Gen.Params.Admin.RemoveUser.Params Evergreen.V12.Pages.Admin.RemoveUser.Model
    | Admin__ShowJson Evergreen.V12.Gen.Params.Admin.ShowJson.Params Evergreen.V12.Pages.Admin.ShowJson.Model
    | Routes__Filter_ Evergreen.V12.Gen.Params.Routes.Filter_.Params Evergreen.V12.Pages.Routes.Filter_.Model
    | NotFound Evergreen.V12.Gen.Params.NotFound.Params
