module FormDict exposing (..)

import Dict exposing (Dict)


type FormDict
    = FormDict (Dict String String)


init : FormDict
init =
    FormDict Dict.empty


get : String -> FormDict -> String
get key (FormDict dict) =
    Dict.get key dict |> Maybe.withDefault ""


insert : String -> String -> FormDict -> FormDict
insert k v (FormDict dict) =
    FormDict (Dict.insert k v dict)
