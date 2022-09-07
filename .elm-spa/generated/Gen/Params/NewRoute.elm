module Gen.Params.NewRoute exposing (Params, parser)

import Url.Parser as Parser exposing ((</>), Parser)


type alias Params =
    ()


parser =
    (Parser.s "new-route")

