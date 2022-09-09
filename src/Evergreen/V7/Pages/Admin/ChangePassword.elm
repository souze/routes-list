module Evergreen.V7.Pages.Admin.ChangePassword exposing (..)

import Evergreen.V7.FormDict


type alias Model =
    { form : Evergreen.V7.FormDict.FormDict
    }


type Msg
    = FieldUpdate String String
    | ChangePassword
