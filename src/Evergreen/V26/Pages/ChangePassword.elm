module Evergreen.V26.Pages.ChangePassword exposing (..)


type StatusMessage
    = Pending
    | Success
    | Failed


type alias Model =
    { oldPass : String
    , newPass : String
    , newPass2 : String
    , statusMessage : StatusMessage
    }


type Msg
    = FieldUpdate String String
    | ChangePassword
    | FromBackendPasswordAccepted
    | FromBackendPasswordRejected
