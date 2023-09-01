module Evergreen.V25.Pages.Admin.ChangePassword exposing (..)

import Evergreen.V25.FormDict


type alias Model =
    { form : Evergreen.V25.FormDict.FormDict
    }


type Msg
    = FieldUpdate String String
    | ChangePassword
