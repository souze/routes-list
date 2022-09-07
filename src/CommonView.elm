module CommonView exposing (..)

import Element exposing (Element)
import Element.Background
import Element.Input
import Gen.Route


header : Element msg
header =
    Element.row [ Element.spacing 10 ]
        [ linkToRoute "Wishlist" <| Gen.Route.Routes__Filter_ { filter = "wishlist" }
        , linkToRoute "Log" <| Gen.Route.Routes__Filter_ { filter = "log" }
        , linkToRoute "All" <| Gen.Route.Routes__Filter_ { filter = "all" }
        , linkToRoute "..." <| Gen.Route.MoreOptions
        ]


linkToRoute : String -> Gen.Route.Route -> Element msg
linkToRoute labelText route =
    Element.link []
        { url = Gen.Route.toHref route
        , label = actionButtonLabel labelText
        }


actionButtonLabel : String -> Element msg
actionButtonLabel text =
    Element.el [ Element.Background.color (Element.rgb 0.6 0.6 0.6), Element.padding 8 ] (Element.text text)


mainColumn : List (Element msg) -> Element msg
mainColumn =
    Element.column [ Element.spacing 10, Element.padding 20, Element.width Element.fill ]


mainColumnWithToprow : List (Element msg) -> Element msg
mainColumnWithToprow items =
    mainColumn (header :: items)


buttonToSendEvent : String -> msg -> Element msg
buttonToSendEvent labelText event =
    Element.Input.button []
        { onPress = Just event
        , label = actionButtonLabel labelText
        }
