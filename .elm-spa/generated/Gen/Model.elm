module Gen.Model exposing (Model(..))

import Gen.Params.Home_
import Gen.Params.MoreOptions
import Gen.Params.SignIn
import Gen.Params.Routes.Filter_
import Gen.Params.NotFound
import Pages.Home_
import Pages.MoreOptions
import Pages.SignIn
import Pages.Routes.Filter_
import Pages.NotFound


type Model
    = Redirecting_
    | Home_ Gen.Params.Home_.Params
    | MoreOptions Gen.Params.MoreOptions.Params Pages.MoreOptions.Model
    | SignIn Gen.Params.SignIn.Params Pages.SignIn.Model
    | Routes__Filter_ Gen.Params.Routes.Filter_.Params Pages.Routes.Filter_.Model
    | NotFound Gen.Params.NotFound.Params

