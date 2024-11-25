module CommonView exposing (..)

import ClimbRoute
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font
import Element.Input
import Html.Events
import Json.Decode
import List.Extra
import Route
import Route.Path
import Set exposing (Set)
import Widget
import Widget.Material as Material


linkToRoute : String -> Route.Path.Path -> Element msg
linkToRoute labelText route =
    Element.link []
        { url = Route.Path.toString route
        , label = actionButtonLabel labelText
        }


actionButtonLabel : String -> Element msg
actionButtonLabel text =
    Element.el
        [ Element.padding 10
        , Element.Border.width 3
        , Element.Border.rounded 6
        , Element.Border.color color.blue
        , Element.Background.color color.lightBlue
        , Element.Font.variant Element.Font.smallCaps

        -- The order of mouseDown/mouseOver can be significant when changing
        -- the same attribute in both
        , Element.mouseDown
            [ Element.Background.color color.blue
            , Element.Border.color color.blue
            , Element.Font.color color.white
            ]
        , Element.mouseOver
            [ Element.Background.color color.white
            , Element.Border.color color.lightGrey
            ]
        ]
        (Element.text text)


mainColumn : List (Element msg) -> Element msg
mainColumn =
    Element.column [ Element.spacing 10, Element.width Element.fill ]


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


color =
    { blue = Element.rgb255 0x72 0x9F 0xCF
    , darkCharcoal = Element.rgb255 0x2E 0x34 0x36
    , lightBlue = Element.rgb255 0xC5 0xE8 0xF7
    , lightGrey = Element.rgb255 0xE0 0xE0 0xE0
    , grey = Element.rgb255 0x93 0xA1 0xA1
    , white = Element.rgb255 0xFF 0xFF 0xFF
    }
