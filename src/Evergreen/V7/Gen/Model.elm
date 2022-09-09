module Evergreen.V7.Gen.Model exposing (..)

import Evergreen.V7.Gen.Params.Admin.AddUser
import Evergreen.V7.Gen.Params.Admin.ChangePassword
import Evergreen.V7.Gen.Params.Admin.Home_
import Evergreen.V7.Gen.Params.Admin.RemoveUser
import Evergreen.V7.Gen.Params.Admin.ShowJson
import Evergreen.V7.Gen.Params.ChangePassword
import Evergreen.V7.Gen.Params.Home_
import Evergreen.V7.Gen.Params.InputJson
import Evergreen.V7.Gen.Params.MoreOptions
import Evergreen.V7.Gen.Params.NewRoute
import Evergreen.V7.Gen.Params.NotFound
import Evergreen.V7.Gen.Params.OutputJson
import Evergreen.V7.Gen.Params.Routes.Filter_
import Evergreen.V7.Gen.Params.SignIn
import Evergreen.V7.Pages.Admin.AddUser
import Evergreen.V7.Pages.Admin.ChangePassword
import Evergreen.V7.Pages.Admin.Home_
import Evergreen.V7.Pages.Admin.RemoveUser
import Evergreen.V7.Pages.Admin.ShowJson
import Evergreen.V7.Pages.ChangePassword
import Evergreen.V7.Pages.Home_
import Evergreen.V7.Pages.InputJson
import Evergreen.V7.Pages.MoreOptions
import Evergreen.V7.Pages.NewRoute
import Evergreen.V7.Pages.OutputJson
import Evergreen.V7.Pages.Routes.Filter_
import Evergreen.V7.Pages.SignIn


type Model
    = Redirecting_
    | ChangePassword Evergreen.V7.Gen.Params.ChangePassword.Params Evergreen.V7.Pages.ChangePassword.Model
    | Home_ Evergreen.V7.Gen.Params.Home_.Params Evergreen.V7.Pages.Home_.Model
    | InputJson Evergreen.V7.Gen.Params.InputJson.Params Evergreen.V7.Pages.InputJson.Model
    | MoreOptions Evergreen.V7.Gen.Params.MoreOptions.Params Evergreen.V7.Pages.MoreOptions.Model
    | NewRoute Evergreen.V7.Gen.Params.NewRoute.Params Evergreen.V7.Pages.NewRoute.Model
    | OutputJson Evergreen.V7.Gen.Params.OutputJson.Params Evergreen.V7.Pages.OutputJson.Model
    | SignIn Evergreen.V7.Gen.Params.SignIn.Params Evergreen.V7.Pages.SignIn.Model
    | Admin__AddUser Evergreen.V7.Gen.Params.Admin.AddUser.Params Evergreen.V7.Pages.Admin.AddUser.Model
    | Admin__ChangePassword Evergreen.V7.Gen.Params.Admin.ChangePassword.Params Evergreen.V7.Pages.Admin.ChangePassword.Model
    | Admin__Home_ Evergreen.V7.Gen.Params.Admin.Home_.Params Evergreen.V7.Pages.Admin.Home_.Model
    | Admin__RemoveUser Evergreen.V7.Gen.Params.Admin.RemoveUser.Params Evergreen.V7.Pages.Admin.RemoveUser.Model
    | Admin__ShowJson Evergreen.V7.Gen.Params.Admin.ShowJson.Params Evergreen.V7.Pages.Admin.ShowJson.Model
    | Routes__Filter_ Evergreen.V7.Gen.Params.Routes.Filter_.Params Evergreen.V7.Pages.Routes.Filter_.Model
    | NotFound Evergreen.V7.Gen.Params.NotFound.Params
