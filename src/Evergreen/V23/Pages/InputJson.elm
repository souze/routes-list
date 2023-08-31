module Evergreen.V23.Pages.InputJson exposing (..)

import Evergreen.V23.ConfirmComponent
import Evergreen.V23.Route


type alias Model =
    { text : String
    , statusText : Maybe String
    , parsedRoutes : Maybe (List Evergreen.V23.Route.NewRouteData)
    , confirmState : Evergreen.V23.ConfirmComponent.State
    }


type Msg
    = TextChanged String
    | SubmitToBackend (List Evergreen.V23.Route.NewRouteData)
    | ConfirmComponentEvent Evergreen.V23.ConfirmComponent.Msg
