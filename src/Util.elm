module Util exposing (..)


noSub : a -> Sub msg
noSub _ =
    Sub.none
