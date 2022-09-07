module Gen.Params.Routes.Filter_ exposing (Params, parser)

import Url.Parser as Parser exposing ((</>), Parser)


type alias Params =
    { filter : String }


parser =
    Parser.map Params (Parser.s "routes" </> Parser.string)

