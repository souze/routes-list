module Evergreen.V22.Pages.InputJson exposing (..)

import Evergreen.V22.ConfirmComponent
import Evergreen.V22.Route


type alias Model =
    { text : String
    , statusText : Maybe String
    , parsedRoutes : Maybe (List Evergreen.V22.Route.NewRouteData)
    , confirmState : Evergreen.V22.ConfirmComponent.State
    }


type Msg
    = TextChanged String
    | SubmitToBackend (List Evergreen.V22.Route.NewRouteData)
    | ConfirmComponentEvent Evergreen.V22.ConfirmComponent.Msg
