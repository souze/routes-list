module Evergreen.V17.Pages.InputJson exposing (..)

import Evergreen.V17.ConfirmComponent
import Evergreen.V17.Route


type alias Model =
    { text : String
    , statusText : Maybe String
    , parsedRoutes : Maybe (List Evergreen.V17.Route.NewRouteData)
    , confirmState : Evergreen.V17.ConfirmComponent.State
    }


type Msg
    = TextChanged String
    | SubmitToBackend (List Evergreen.V17.Route.NewRouteData)
    | ConfirmComponentEvent Evergreen.V17.ConfirmComponent.Msg
