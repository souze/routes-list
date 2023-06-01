module Evergreen.V14.Pages.Admin.AddUser exposing (..)

import Evergreen.V14.FormDict


type alias Model =
    { form : Evergreen.V14.FormDict.FormDict
    }


type Msg
    = FieldUpdate String String
    | CreateUser
