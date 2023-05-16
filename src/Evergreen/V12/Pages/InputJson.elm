module Evergreen.V12.Pages.InputJson exposing (..)

import Evergreen.V12.ConfirmComponent
import Evergreen.V12.Route


type alias Model =
    { text : String
    , statusText : Maybe String
    , parsedRoutes : Maybe (List Evergreen.V12.Route.NewRouteData)
    , confirmState : Evergreen.V12.ConfirmComponent.State
    }


type Msg
    = TextChanged String
    | SubmitToBackend (List Evergreen.V12.Route.NewRouteData)
    | ConfirmComponentEvent Evergreen.V12.ConfirmComponent.Msg
