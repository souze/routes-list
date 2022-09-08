module Gen.Params.Admin.ShowJson exposing (Params, parser)

import Url.Parser as Parser exposing ((</>), Parser)


type alias Params =
    ()


parser =
    (Parser.s "admin" </> Parser.s "show-json")

