module Evergreen.V12.Pages.SignIn exposing (..)


type alias Model =
    { username : String
    , password : String
    }


type Msg
    = ClickedSignIn
    | FieldChanged String String
