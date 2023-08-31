module Evergreen.V23.Pages.Admin.ChangePassword exposing (..)

import Evergreen.V23.FormDict


type alias Model =
    { form : Evergreen.V23.FormDict.FormDict
    }


type Msg
    = FieldUpdate String String
    | ChangePassword
