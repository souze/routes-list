module Evergreen.V18.Pages.InputJson exposing (..)

import Evergreen.V18.ConfirmComponent
import Evergreen.V18.Route


type alias Model =
    { text : String
    , statusText : Maybe String
    , parsedRoutes : Maybe (List Evergreen.V18.Route.NewRouteData)
    , confirmState : Evergreen.V18.ConfirmComponent.State
    }


type Msg
    = TextChanged String
    | SubmitToBackend (List Evergreen.V18.Route.NewRouteData)
    | ConfirmComponentEvent Evergreen.V18.ConfirmComponent.Msg
