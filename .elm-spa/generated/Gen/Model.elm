module Gen.Model exposing (Model(..))

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


type Model
    = Redirecting_
    | ChangePassword Gen.Params.ChangePassword.Params Pages.ChangePassword.Model
    | Home_ Gen.Params.Home_.Params
    | InputJson Gen.Params.InputJson.Params Pages.InputJson.Model
    | MoreOptions Gen.Params.MoreOptions.Params Pages.MoreOptions.Model
    | NewRoute Gen.Params.NewRoute.Params Pages.NewRoute.Model
    | OutputJson Gen.Params.OutputJson.Params Pages.OutputJson.Model
    | SignIn Gen.Params.SignIn.Params Pages.SignIn.Model
    | Routes__Filter_ Gen.Params.Routes.Filter_.Params Pages.Routes.Filter_.Model
    | NotFound Gen.Params.NotFound.Params

