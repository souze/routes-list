module Evergreen.V22.Pages.Admin.AddUser exposing (..)

import Evergreen.V22.FormDict


type alias Model =
    { form : Evergreen.V22.FormDict.FormDict
    }


type Msg
    = FieldUpdate String String
    | CreateUser
