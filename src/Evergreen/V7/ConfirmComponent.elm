module Evergreen.V7.ConfirmComponent exposing (..)


type State
    = Waiting
    | Active String


type Msg
    = ConfirmCompTextChange String
    | FirstButtonPressed
