module Evergreen.V25.Pages.ChangePassword exposing (..)


type alias Model =
    { oldPass : String
    , newPass : String
    , newPass2 : String
    }


type Msg
    = FieldUpdate String String
    | ChangePassword
