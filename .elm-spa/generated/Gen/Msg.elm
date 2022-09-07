module Gen.Msg exposing (Msg(..))

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


type Msg
    = MoreOptions Pages.MoreOptions.Msg
    | SignIn Pages.SignIn.Msg
    | Routes__Filter_ Pages.Routes.Filter_.Msg

