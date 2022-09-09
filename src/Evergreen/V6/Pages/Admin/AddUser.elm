module Evergreen.V6.Pages.Admin.AddUser exposing (..)

import Evergreen.V6.FormDict


type alias Model =
    { form : Evergreen.V6.FormDict.FormDict
    }


type Msg
    = FieldUpdate String String
    | CreateUser
