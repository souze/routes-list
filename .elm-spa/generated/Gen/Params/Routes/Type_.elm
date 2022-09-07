module Gen.Params.Routes.Type_ exposing (Params, parser)

import Url.Parser as Parser exposing ((</>), Parser)


type alias Params =
    { type : String }


parser =
    Parser.map Params (Parser.s "routes" </> Parser.string)

