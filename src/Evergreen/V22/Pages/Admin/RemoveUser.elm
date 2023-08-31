module Evergreen.V22.Pages.Admin.RemoveUser exposing (..)


type alias Model =
    { username : String
    }


type Msg
    = FieldUpdate String
    | RemoveUser
