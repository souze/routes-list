module Evergreen.V18.Pages.Admin.ChangePassword exposing (..)

import Evergreen.V18.FormDict


type alias Model =
    { form : Evergreen.V18.FormDict.FormDict
    }


type Msg
    = FieldUpdate String String
    | ChangePassword
