module Gen.Params.Admin.AddUser exposing (Params, parser)

import Url.Parser as Parser exposing ((</>), Parser)


type alias Params =
    ()


parser =
    (Parser.s "admin" </> Parser.s "add-user")

