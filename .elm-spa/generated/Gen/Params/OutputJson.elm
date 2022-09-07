module Gen.Params.OutputJson exposing (Params, parser)

import Url.Parser as Parser exposing ((</>), Parser)


type alias Params =
    ()


parser =
    (Parser.s "output-json")

