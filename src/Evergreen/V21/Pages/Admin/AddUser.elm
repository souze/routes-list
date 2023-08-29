module Evergreen.V21.Pages.Admin.AddUser exposing (..)

import Evergreen.V21.FormDict


type alias Model =
    { form : Evergreen.V21.FormDict.FormDict
    }


type Msg
    = FieldUpdate String String
    | CreateUser
