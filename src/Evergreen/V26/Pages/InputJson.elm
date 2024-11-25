module Evergreen.V26.Pages.InputJson exposing (..)

import Evergreen.V26.ClimbRoute
import Evergreen.V26.ConfirmComponent


type alias Model =
    { text : String
    , statusText : Maybe String
    , parsedRoutes : Maybe (List Evergreen.V26.ClimbRoute.NewRouteData)
    , confirmState : Evergreen.V26.ConfirmComponent.State
    }


type Msg
    = TextChanged String
    | SubmitToBackend (List Evergreen.V26.ClimbRoute.NewRouteData)
    | ConfirmComponentEvent Evergreen.V26.ConfirmComponent.Msg
