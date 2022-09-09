module Evergreen.V6.Gen.Model exposing (..)

import Evergreen.V6.Gen.Params.Admin.AddUser
import Evergreen.V6.Gen.Params.Admin.ChangePassword
import Evergreen.V6.Gen.Params.Admin.Home_
import Evergreen.V6.Gen.Params.Admin.RemoveUser
import Evergreen.V6.Gen.Params.Admin.ShowJson
import Evergreen.V6.Gen.Params.ChangePassword
import Evergreen.V6.Gen.Params.Home_
import Evergreen.V6.Gen.Params.InputJson
import Evergreen.V6.Gen.Params.MoreOptions
import Evergreen.V6.Gen.Params.NewRoute
import Evergreen.V6.Gen.Params.NotFound
import Evergreen.V6.Gen.Params.OutputJson
import Evergreen.V6.Gen.Params.Routes.Filter_
import Evergreen.V6.Gen.Params.SignIn
import Evergreen.V6.Pages.Admin.AddUser
import Evergreen.V6.Pages.Admin.ChangePassword
import Evergreen.V6.Pages.Admin.Home_
import Evergreen.V6.Pages.Admin.RemoveUser
import Evergreen.V6.Pages.Admin.ShowJson
import Evergreen.V6.Pages.ChangePassword
import Evergreen.V6.Pages.InputJson
import Evergreen.V6.Pages.MoreOptions
import Evergreen.V6.Pages.NewRoute
import Evergreen.V6.Pages.OutputJson
import Evergreen.V6.Pages.Routes.Filter_
import Evergreen.V6.Pages.SignIn


type Model
    = Redirecting_
    | ChangePassword Evergreen.V6.Gen.Params.ChangePassword.Params Evergreen.V6.Pages.ChangePassword.Model
    | Home_ Evergreen.V6.Gen.Params.Home_.Params
    | InputJson Evergreen.V6.Gen.Params.InputJson.Params Evergreen.V6.Pages.InputJson.Model
    | MoreOptions Evergreen.V6.Gen.Params.MoreOptions.Params Evergreen.V6.Pages.MoreOptions.Model
    | NewRoute Evergreen.V6.Gen.Params.NewRoute.Params Evergreen.V6.Pages.NewRoute.Model
    | OutputJson Evergreen.V6.Gen.Params.OutputJson.Params Evergreen.V6.Pages.OutputJson.Model
    | SignIn Evergreen.V6.Gen.Params.SignIn.Params Evergreen.V6.Pages.SignIn.Model
    | Admin__AddUser Evergreen.V6.Gen.Params.Admin.AddUser.Params Evergreen.V6.Pages.Admin.AddUser.Model
    | Admin__ChangePassword Evergreen.V6.Gen.Params.Admin.ChangePassword.Params Evergreen.V6.Pages.Admin.ChangePassword.Model
    | Admin__Home_ Evergreen.V6.Gen.Params.Admin.Home_.Params Evergreen.V6.Pages.Admin.Home_.Model
    | Admin__RemoveUser Evergreen.V6.Gen.Params.Admin.RemoveUser.Params Evergreen.V6.Pages.Admin.RemoveUser.Model
    | Admin__ShowJson Evergreen.V6.Gen.Params.Admin.ShowJson.Params Evergreen.V6.Pages.Admin.ShowJson.Model
    | Routes__Filter_ Evergreen.V6.Gen.Params.Routes.Filter_.Params Evergreen.V6.Pages.Routes.Filter_.Model
    | NotFound Evergreen.V6.Gen.Params.NotFound.Params
