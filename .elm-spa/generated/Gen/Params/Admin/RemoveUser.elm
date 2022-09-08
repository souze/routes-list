module Gen.Params.Admin.RemoveUser exposing (Params, parser)

import Url.Parser as Parser exposing ((</>), Parser)


type alias Params =
    ()


parser =
    (Parser.s "admin" </> Parser.s "remove-user")

