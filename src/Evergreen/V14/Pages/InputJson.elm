module Evergreen.V14.Pages.InputJson exposing (..)

import Evergreen.V14.ConfirmComponent
import Evergreen.V14.Route


type alias Model =
    { text : String
    , statusText : Maybe String
    , parsedRoutes : Maybe (List Evergreen.V14.Route.NewRouteData)
    , confirmState : Evergreen.V14.ConfirmComponent.State
    }


type Msg
    = TextChanged String
    | SubmitToBackend (List Evergreen.V14.Route.NewRouteData)
    | ConfirmComponentEvent Evergreen.V14.ConfirmComponent.Msg
