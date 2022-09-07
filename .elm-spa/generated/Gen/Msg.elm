module Gen.Msg exposing (Msg(..))

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


type Msg
    = MoreOptions Pages.MoreOptions.Msg
    | RouteList Pages.RouteList.Msg
    | SignIn Pages.SignIn.Msg

