module CommonView exposing (..)

import ClimbRoute
import Element exposing (Element)
import Element.Background
import Element.Input
import Html.Events
import Json.Decode
import List.Extra
import Route
import Route.Path
import Set exposing (Set)
import Widget
import Widget.Material as Material


header : Element msg
header =
    Element.row [ Element.spacing 10 ]
        [ linkToRoute "Log" <| Route.Path.Routes_Filter_ { filter = "log" }
        , linkToRoute "Wishlist" <| Route.Path.Routes_Filter_ { filter = "wishlist" }
        , linkToRoute "+" <| Route.Path.NewRoute
        , linkToRoute "..." <| Route.Path.MoreOptions
        ]


linkToRoute : String -> Route.Path.Path -> Element msg
linkToRoute labelText route =
    Element.link []
        { url = "routeToString implemented not yet"
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
        (linkToRoute "Home" Route.Path.Admin
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


selectMany : Set String -> List String -> Element String
selectMany selected options =
    { selected =
        selected
            |> Set.map
                (\selectedItem ->
                    options
                        |> List.Extra.elemIndex selectedItem
                        |> Maybe.withDefault 0
                )
    , options =
        options
            |> List.map
                (\item ->
                    { text = item
                    , icon =
                        if Set.member item selected then
                            always (Element.text "🟢")

                        else
                            always Element.none
                    }
                )
    , onSelect = \i -> Just <| (List.Extra.getAt i options |> Maybe.withDefault "")
    }
        |> Widget.multiSelect
        |> Widget.wrappedButtonRow
            { elementRow = filledButtonRow
            , content = Material.containedButton Material.defaultPalette
            }


onEnter : msg -> Element.Attribute msg
onEnter msg =
    Element.htmlAttribute
        (Html.Events.on "keyup"
            (Json.Decode.field "key" Json.Decode.string
                |> Json.Decode.andThen
                    (\key ->
                        if key == "Enter" then
                            Json.Decode.succeed msg

                        else
                            Json.Decode.fail "Not the enter key"
                    )
            )
        )
