module Gen.Params.Admin.ChangePassword exposing (Params, parser)

import Url.Parser as Parser exposing ((</>), Parser)


type alias Params =
    ()


parser =
    (Parser.s "admin" </> Parser.s "change-password")

