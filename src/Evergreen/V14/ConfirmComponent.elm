module Evergreen.V14.ConfirmComponent exposing (..)


type State
    = Waiting
    | Active String


type Msg
    = ConfirmCompTextChange String
    | FirstButtonPressed
