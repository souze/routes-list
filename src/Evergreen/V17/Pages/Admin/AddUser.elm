module Evergreen.V17.Pages.Admin.AddUser exposing (..)

import Evergreen.V17.FormDict


type alias Model =
    { form : Evergreen.V17.FormDict.FormDict
    }


type Msg
    = FieldUpdate String String
    | CreateUser
