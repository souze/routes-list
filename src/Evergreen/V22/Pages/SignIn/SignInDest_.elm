module Evergreen.V22.Pages.SignIn.SignInDest_ exposing (..)


type alias Model =
    { username : String
    , password : String
    , showPassword : Bool
    , errorMsg : Maybe String
    }


type FieldType
    = UsernameField
    | PasswordField


type Msg
    = ClickedSignIn
    | FieldChanged FieldType String
    | ToggleShowPassword
    | WrongUsernameOrPassword
