module CommonView exposing (..)

import Element exposing (Element)
import Element.Background
import Element.Input
import Gen.Route
import List.Extra
import Set
import Widget
import Widget.Material as Material


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


adminPageWithItems : List (Element msg) -> Element msg
adminPageWithItems items =
    mainColumn
        (linkToRoute "Home" Gen.Route.Admin__Home_
            :: items
        )


selectOne : (Int -> msg) -> List String -> Int -> Element msg
selectOne msgFn options selected =
    selectOneCustom "🟢" msgFn options (Just selected)


selectOneCustom : String -> (Int -> msg) -> List String -> Maybe Int -> Element msg
selectOneCustom selectedIcon msgFn options maybeSelected =
    { selected = maybeSelected
    , options =
        options
            |> List.indexedMap
                (\i text ->
                    { text = text
                    , icon =
                        case maybeSelected of
                            Just selected ->
                                if i == selected then
                                    always (Element.text selectedIcon)

                                else
                                    always Element.none

                            Nothing ->
                                always Element.none
                    }
                )
    , onSelect = \i -> Just <| msgFn i
    }
        |> Widget.select
        |> Widget.wrappedButtonRow
            { elementRow = filledButtonRow
            , content = Material.containedButton Material.defaultPalette
            }


filledButtonRow : Widget.RowStyle msg
filledButtonRow =
    let
        br =
            Material.buttonRow
    in
    { br | elementRow = Element.width Element.fill :: br.elementRow }
