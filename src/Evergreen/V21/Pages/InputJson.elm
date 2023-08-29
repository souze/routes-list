module Evergreen.V21.Pages.InputJson exposing (..)

import Evergreen.V21.ConfirmComponent
import Evergreen.V21.Route


type alias Model =
    { text : String
    , statusText : Maybe String
    , parsedRoutes : Maybe (List Evergreen.V21.Route.NewRouteData)
    , confirmState : Evergreen.V21.ConfirmComponent.State
    }


type Msg
    = TextChanged String
    | SubmitToBackend (List Evergreen.V21.Route.NewRouteData)
    | ConfirmComponentEvent Evergreen.V21.ConfirmComponent.Msg
