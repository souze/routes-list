module Evergreen.V26.ImageGallery exposing (..)


type alias Coords =
    { x : Float
    , y : Float
    }


type alias SwipeState =
    { start : Coords
    , curr : Coords
    }


type alias Model =
    { images : List String
    , swipeState : Maybe SwipeState
    }


type SwipeEvent
    = SwipeStart Coords
    | SwipeEnd Coords
    | SwipeMove Coords


type Msg
    = PrevPressed
    | NextPressed
    | BackPressed
    | Swiped SwipeEvent
