module View exposing (View, fromString, map, none, placeholder, toBrowserDocument)

import Browser
import Element exposing (..)
import Html
import Route exposing (Route)
import Shared
import Shared.Model


type alias View msg =
    { title : String
    , body : Element msg
    }


placeholder : String -> View msg
placeholder str =
    { title = str
    , body = text str
    }


none : View msg
none =
    placeholder ""


map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn view =
    { title = view.title
    , body = Element.map fn view.body
    }


toBrowserDocument : { shared : Shared.Model.Model, route : Route (), view : View msg } -> Browser.Document msg
toBrowserDocument { view } =
    { title = view.title
    , body = [ Element.layout [] view.body ]
    }


fromString : String -> View msg
fromString str =
    { title = str
    , body = Element.text str
    }
