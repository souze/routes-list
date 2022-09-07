module Gen.Model exposing (Model(..))

import Gen.Params.Home_
import Gen.Params.MoreOptions
import Gen.Params.RouteList
import Gen.Params.SignIn
import Gen.Params.NotFound
import Pages.Home_
import Pages.MoreOptions
import Pages.RouteList
import Pages.SignIn
import Pages.NotFound


type Model
    = Redirecting_
    | Home_ Gen.Params.Home_.Params
    | MoreOptions Gen.Params.MoreOptions.Params Pages.MoreOptions.Model
    | RouteList Gen.Params.RouteList.Params Pages.RouteList.Model
    | SignIn Gen.Params.SignIn.Params Pages.SignIn.Model
    | NotFound Gen.Params.NotFound.Params

