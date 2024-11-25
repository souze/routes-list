module Evergreen.V26.Pages.Admin.AddUser exposing (..)

import Evergreen.V26.FormDict


type alias Model =
    { form : Evergreen.V26.FormDict.FormDict
    }


type Msg
    = FieldUpdate String String
    | CreateUser
