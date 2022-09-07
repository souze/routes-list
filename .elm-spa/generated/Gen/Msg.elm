module Gen.Msg exposing (Msg(..))

import Gen.Params.ChangePassword
import Gen.Params.Home_
import Gen.Params.InputJson
import Gen.Params.MoreOptions
import Gen.Params.NewRoute
import Gen.Params.OutputJson
import Gen.Params.SignIn
import Gen.Params.Routes.Filter_
import Gen.Params.NotFound
import Pages.ChangePassword
import Pages.Home_
import Pages.InputJson
import Pages.MoreOptions
import Pages.NewRoute
import Pages.OutputJson
import Pages.SignIn
import Pages.Routes.Filter_
import Pages.NotFound


type Msg
    = ChangePassword Pages.ChangePassword.Msg
    | InputJson Pages.InputJson.Msg
    | MoreOptions Pages.MoreOptions.Msg
    | NewRoute Pages.NewRoute.Msg
    | OutputJson Pages.OutputJson.Msg
    | SignIn Pages.SignIn.Msg
    | Routes__Filter_ Pages.Routes.Filter_.Msg

