module Evergreen.V7.Pages.InputJson exposing (..)

import Evergreen.V7.ConfirmComponent
import Evergreen.V7.Route


type alias Model =
    { text : String
    , statusText : Maybe String
    , parsedRoutes : Maybe (List Evergreen.V7.Route.NewRouteData)
    , confirmState : Evergreen.V7.ConfirmComponent.State
    }


type Msg
    = TextChanged String
    | SubmitToBackend (List Evergreen.V7.Route.NewRouteData)
    | ConfirmComponentEvent Evergreen.V7.ConfirmComponent.Msg
