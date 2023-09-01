module Evergreen.V25.Pages.InputJson exposing (..)

import Evergreen.V25.ConfirmComponent
import Evergreen.V25.Route


type alias Model =
    { text : String
    , statusText : Maybe String
    , parsedRoutes : Maybe (List Evergreen.V25.Route.NewRouteData)
    , confirmState : Evergreen.V25.ConfirmComponent.State
    }


type Msg
    = TextChanged String
    | SubmitToBackend (List Evergreen.V25.Route.NewRouteData)
    | ConfirmComponentEvent Evergreen.V25.ConfirmComponent.Msg
