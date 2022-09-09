module Evergreen.V7.Pages.Admin.AddUser exposing (..)

import Evergreen.V7.FormDict


type alias Model =
    { form : Evergreen.V7.FormDict.FormDict
    }


type Msg
    = FieldUpdate String String
    | CreateUser
