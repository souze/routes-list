module Gen.Msg exposing (Msg(..))

import Gen.Params.ChangePassword
import Gen.Params.Home_
import Gen.Params.InputJson
import Gen.Params.MoreOptions
import Gen.Params.NewRoute
import Gen.Params.OutputJson
import Gen.Params.SignIn
import Gen.Params.Admin.AddUser
import Gen.Params.Admin.ChangePassword
import Gen.Params.Admin.Home_
import Gen.Params.Admin.RemoveUser
import Gen.Params.Admin.ShowJson
import Gen.Params.Routes.Filter_
import Gen.Params.NotFound
import Pages.ChangePassword
import Pages.Home_
import Pages.InputJson
import Pages.MoreOptions
import Pages.NewRoute
import Pages.OutputJson
import Pages.SignIn
import Pages.Admin.AddUser
import Pages.Admin.ChangePassword
import Pages.Admin.Home_
import Pages.Admin.RemoveUser
import Pages.Admin.ShowJson
import Pages.Routes.Filter_
import Pages.NotFound


type Msg
    = ChangePassword Pages.ChangePassword.Msg
    | Home_ Pages.Home_.Msg
    | InputJson Pages.InputJson.Msg
    | MoreOptions Pages.MoreOptions.Msg
    | NewRoute Pages.NewRoute.Msg
    | OutputJson Pages.OutputJson.Msg
    | SignIn Pages.SignIn.Msg
    | Admin__AddUser Pages.Admin.AddUser.Msg
    | Admin__ChangePassword Pages.Admin.ChangePassword.Msg
    | Admin__Home_ Pages.Admin.Home_.Msg
    | Admin__RemoveUser Pages.Admin.RemoveUser.Msg
    | Admin__ShowJson Pages.Admin.ShowJson.Msg
    | Routes__Filter_ Pages.Routes.Filter_.Msg

