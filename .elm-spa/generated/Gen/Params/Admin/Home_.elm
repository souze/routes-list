module Gen.Params.Admin.Home_ exposing (Params, parser)

import Url.Parser as Parser exposing ((</>), Parser)


type alias Params =
    ()


parser =
    (Parser.s "admin" </> Parser.top)

