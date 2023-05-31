module Gen.Params.SignIn.SignInDest_ exposing (Params, parser)

import Url.Parser as Parser exposing ((</>), Parser)


type alias Params =
    { signInDest : String }


parser =
    Parser.map Params (Parser.s "sign-in" </> Parser.string)

