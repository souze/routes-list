module Gen.Route exposing
    ( Route(..)
    , fromUrl
    , toHref
    )

import Gen.Params.Home_
import Gen.Params.MoreOptions
import Gen.Params.RouteList
import Gen.Params.SignIn
import Gen.Params.NotFound
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = Home_
    | MoreOptions
    | RouteList
    | SignIn
    | NotFound


fromUrl : Url -> Route
fromUrl =
    Parser.parse (Parser.oneOf routes) >> Maybe.withDefault NotFound


routes : List (Parser (Route -> a) a)
routes =
    [ Parser.map Home_ Gen.Params.Home_.parser
    , Parser.map MoreOptions Gen.Params.MoreOptions.parser
    , Parser.map RouteList Gen.Params.RouteList.parser
    , Parser.map SignIn Gen.Params.SignIn.parser
    , Parser.map NotFound Gen.Params.NotFound.parser
    ]


toHref : Route -> String
toHref route =
    let
        joinAsHref : List String -> String
        joinAsHref segments =
            "/" ++ String.join "/" segments
    in
    case route of
        Home_ ->
            joinAsHref []
    
        MoreOptions ->
            joinAsHref [ "more-options" ]
    
        RouteList ->
            joinAsHref [ "route-list" ]
    
        SignIn ->
            joinAsHref [ "sign-in" ]
    
        NotFound ->
            joinAsHref [ "not-found" ]

