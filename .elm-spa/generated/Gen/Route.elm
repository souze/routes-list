module Gen.Route exposing
    ( Route(..)
    , fromUrl
    , toHref
    )

import Gen.Params.ChangePassword
import Gen.Params.Home_
import Gen.Params.InputJson
import Gen.Params.MoreOptions
import Gen.Params.NewRoute
import Gen.Params.OutputJson
import Gen.Params.SignIn
import Gen.Params.Routes.Filter_
import Gen.Params.NotFound
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = ChangePassword
    | Home_
    | InputJson
    | MoreOptions
    | NewRoute
    | OutputJson
    | SignIn
    | Routes__Filter_ { filter : String }
    | NotFound


fromUrl : Url -> Route
fromUrl =
    Parser.parse (Parser.oneOf routes) >> Maybe.withDefault NotFound


routes : List (Parser (Route -> a) a)
routes =
    [ Parser.map Home_ Gen.Params.Home_.parser
    , Parser.map ChangePassword Gen.Params.ChangePassword.parser
    , Parser.map InputJson Gen.Params.InputJson.parser
    , Parser.map MoreOptions Gen.Params.MoreOptions.parser
    , Parser.map NewRoute Gen.Params.NewRoute.parser
    , Parser.map OutputJson Gen.Params.OutputJson.parser
    , Parser.map SignIn Gen.Params.SignIn.parser
    , Parser.map NotFound Gen.Params.NotFound.parser
    , Parser.map Routes__Filter_ Gen.Params.Routes.Filter_.parser
    ]


toHref : Route -> String
toHref route =
    let
        joinAsHref : List String -> String
        joinAsHref segments =
            "/" ++ String.join "/" segments
    in
    case route of
        ChangePassword ->
            joinAsHref [ "change-password" ]
    
        Home_ ->
            joinAsHref []
    
        InputJson ->
            joinAsHref [ "input-json" ]
    
        MoreOptions ->
            joinAsHref [ "more-options" ]
    
        NewRoute ->
            joinAsHref [ "new-route" ]
    
        OutputJson ->
            joinAsHref [ "output-json" ]
    
        SignIn ->
            joinAsHref [ "sign-in" ]
    
        Routes__Filter_ params ->
            joinAsHref [ "routes", params.filter ]
    
        NotFound ->
            joinAsHref [ "not-found" ]

