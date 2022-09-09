module Evergreen.V6.Pages.SignIn exposing (..)


type alias Model =
    { username : String
    , password : String
    }


type Msg
    = ClickedSignIn
    | FieldChanged String String
