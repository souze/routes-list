module Layouts exposing (..)

import Layouts.Header


type Layout msg
    = Header Layouts.Header.Props


map : (msg1 -> msg2) -> Layout msg1 -> Layout msg2
map fn layout =
    case layout of
        Header data ->
            Header data
