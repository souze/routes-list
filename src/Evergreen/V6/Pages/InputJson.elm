module Evergreen.V6.Pages.InputJson exposing (..)

import Evergreen.V6.ConfirmComponent
import Evergreen.V6.Route


type alias Model =
    { text : String
    , statusText : Maybe String
    , parsedRoutes : Maybe (List Evergreen.V6.Route.NewRouteData)
    , confirmState : Evergreen.V6.ConfirmComponent.State
    }


type Msg
    = TextChanged String
    | SubmitToBackend (List Evergreen.V6.Route.NewRouteData)
    | ConfirmComponentEvent Evergreen.V6.ConfirmComponent.Msg
