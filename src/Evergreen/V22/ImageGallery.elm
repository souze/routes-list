module Evergreen.V22.ImageGallery exposing (..)


type alias Model =
    { images : List String
    }


type Msg
    = PrevPressed
    | NextPressed
    | BackPressed
