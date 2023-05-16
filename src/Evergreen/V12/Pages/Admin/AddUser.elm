module Evergreen.V12.Pages.Admin.AddUser exposing (..)

import Evergreen.V12.FormDict


type alias Model =
    { form : Evergreen.V12.FormDict.FormDict
    }


type Msg
    = FieldUpdate String String
    | CreateUser
