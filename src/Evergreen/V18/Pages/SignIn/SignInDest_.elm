module Evergreen.V18.Pages.SignIn.SignInDest_ exposing (..)


type alias Model =
    { username : String
    , password : String
    }


type Msg
    = ClickedSignIn
    | FieldChanged String String
