module ImageGallery exposing (Model, Msg(..), init, update, view)

import Element exposing (Element)
import Element.Font
import Element.Input
import Element.Keyed
import Html
import Html.Events
import Json.Decode
import List.Extra
import Material.Icons
import Material.Icons.Types exposing (Coloring(..))
import Widget
import Widget.Icon
import Widget.Material


type Msg
    = PrevPressed
    | NextPressed
    | BackPressed
    | Swiped SwipeEvent


type SwipeEvent
    = SwipeStart Coords
    | SwipeEnd Coords
    | SwipeMove Coords


type alias Model =
    { images : List String
    , swipeState : Maybe SwipeState
    }


type alias SwipeState =
    { start : Coords, curr : Coords }


type alias Coords =
    { x : Float
    , y : Float
    }


init : List String -> Int -> Model
init images index =
    { images =
        images
            |> List.Extra.splitAt index
            |> (\( a, b ) -> b ++ a)
    , swipeState = Nothing
    }


update : Msg -> Model -> Maybe Model
update msg model =
    case msg of
        PrevPressed ->
            Just <| prevPressed model

        NextPressed ->
            Just <| nextPressed model

        BackPressed ->
            Nothing

        Swiped evt ->
            Just <| swipeUpdate evt model


prevPressed : Model -> Model
prevPressed model =
    { model | images = model.images |> rotateBackward }


nextPressed : Model -> Model
nextPressed model =
    { model | images = model.images |> rotateForward }


swipeUpdate : SwipeEvent -> Model -> Model
swipeUpdate evt model =
    case evt of
        SwipeStart coords ->
            { model | swipeState = Just { start = coords, curr = coords } }

        SwipeEnd coords ->
            swipeMovedTo coords model
                |> (\m ->
                        case model.swipeState |> Maybe.andThen swipeHoldState of
                            Just HoldingRight ->
                                prevPressed m

                            Just HoldingLeft ->
                                nextPressed m

                            Nothing ->
                                m
                   )
                |> (\m -> { m | swipeState = Nothing })

        SwipeMove coords ->
            swipeMovedTo coords model


swipeMovedTo : Coords -> Model -> Model
swipeMovedTo coords model =
    case model.swipeState of
        Just swipeState ->
            { model | swipeState = Just { start = swipeState.start, curr = coords } }

        Nothing ->
            { model | swipeState = Just { start = coords, curr = coords } }


rotateForward : List a -> List a
rotateForward list =
    case list of
        [] ->
            []

        head :: tail ->
            tail ++ [ head ]


rotateBackward : List a -> List a
rotateBackward list =
    case List.Extra.unconsLast list of
        Nothing ->
            []

        Just ( last, beginning ) ->
            last :: beginning



-- View


view : Model -> Element Msg
view model =
    Element.column ([ Element.width Element.fill ] ++ swipeEvents)
        [ viewBigPicture model
        , Element.row [ Element.width Element.fill, Element.spacing 12 ]
            [ viewPrevButton
            , viewBackButton
            , viewNextButton
            ]
        ]


viewBigPicture : Model -> Element Msg
viewBigPicture model =
    case List.head model.images of
        Just image ->
            case model.swipeState |> Maybe.andThen swipeHoldState of
                Just HoldingRight ->
                    Element.row []
                        [ Element.text "<-"
                        , mainPicture image
                        , Element.text ""
                        ]

                Just HoldingLeft ->
                    Element.row []
                        [ Element.text ""
                        , mainPicture image
                        , Element.text "->"
                        ]

                Nothing ->
                    Element.row []
                        [ Element.text ""
                        , mainPicture image
                        , Element.text ""
                        ]

        Nothing ->
            Element.none


mainPicture : String -> Element Msg
mainPicture image =
    Element.image [ Element.width Element.fill ]
        { src = image
        , description = "Picture associated with route"
        }


button text icon action =
    Widget.button
        (Widget.Material.containedButton Widget.Material.defaultPalette)
        { text = text
        , icon = icon
        , onPress = Just action
        }


viewPrevButton =
    button "Prev" (Material.Icons.favorite |> Widget.Icon.elmMaterialIcons Color) PrevPressed


viewNextButton =
    button "Next" (Material.Icons.favorite |> Widget.Icon.elmMaterialIcons Color) NextPressed


viewBackButton =
    button "Back" (Material.Icons.favorite |> Widget.Icon.elmMaterialIcons Color) BackPressed



-- Swiping


farSwipeThreshold : Float
farSwipeThreshold =
    100


type HoldState
    = HoldingRight
    | HoldingLeft


swipeHoldState : SwipeState -> Maybe HoldState
swipeHoldState swipeState =
    case swipeState of
        { start, curr } ->
            if curr.x > start.x + farSwipeThreshold then
                Just HoldingRight

            else if curr.x < start.x - farSwipeThreshold then
                Just HoldingLeft

            else
                Nothing


swipeEvents : List (Element.Attribute Msg)
swipeEvents =
    onSwipeEvents Swiped
        |> List.map Element.htmlAttribute


{-| Function that detects the touch events. A message wrapper is passed in to be handled in the application update handler.
It returns a list of Attributes (it must be a list because it can fire both "touchstart" and "touchend" states)
-}
onSwipeEvents : (SwipeEvent -> msg) -> List (Html.Attribute msg)
onSwipeEvents msg =
    [ onTouchStart msg
    , onTouchMove msg
    , onTouchEnd msg
    , onTouchCancel msg
    ]


{-| Touch start event handler
-}
onTouchStart : (SwipeEvent -> msg) -> Html.Attribute msg
onTouchStart msg =
    touchDecoder "targetTouches"
        |> Json.Decode.map SwipeStart
        |> Json.Decode.map msg
        |> Html.Events.on "touchstart"


{-| Touch end event handler
-}
onTouchEnd : (SwipeEvent -> msg) -> Html.Attribute msg
onTouchEnd msg =
    touchDecoder "changedTouches"
        |> Json.Decode.map SwipeEnd
        |> Json.Decode.map msg
        |> Html.Events.on "touchend"


{-| Touch end event handler
-}
onTouchCancel : (SwipeEvent -> msg) -> Html.Attribute msg
onTouchCancel msg =
    touchDecoder "changedTouches"
        |> Json.Decode.map SwipeEnd
        |> Json.Decode.map msg
        |> Html.Events.on "touchcancel"


{-| Touch move event handler
-}
onTouchMove : (SwipeEvent -> msg) -> Html.Attribute msg
onTouchMove msg =
    touchDecoder "changedTouches"
        |> Json.Decode.map SwipeMove
        |> Json.Decode.map msg
        |> Html.Events.on "touchmove"


{-| Decodes touch events
-}
touchDecoder : String -> Json.Decode.Decoder Coords
touchDecoder eventType =
    Json.Decode.at [ eventType, "0" ] coordDecoder


{-| Decodes the clientX/Y coordinates from touch events
-}
coordDecoder : Json.Decode.Decoder Coords
coordDecoder =
    Json.Decode.map2 Coords
        (Json.Decode.field "clientX" Json.Decode.float)
        (Json.Decode.field "clientY" Json.Decode.float)
