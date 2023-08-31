module Evergreen.V22.ConfirmComponent exposing (..)


type State
    = Waiting
    | Active String


type Msg
    = ConfirmCompTextChange String
    | FirstButtonPressed
