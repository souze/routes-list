module ImageGallery exposing (Model, Msg, init, update, view)

import Element exposing (Element)
import Element.Font
import Element.Input
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


type alias Model =
    { images : List String
    }


init : List String -> Int -> Model
init images index =
    { images =
        images
            |> List.Extra.splitAt index
            |> (\( a, b ) -> b ++ a)
    }


update : Msg -> Model -> Maybe Model
update msg model =
    case msg of
        PrevPressed ->
            Just { model | images = model.images |> rotateBackward }

        NextPressed ->
            Just { model | images = model.images |> rotateForward }

        BackPressed ->
            Nothing


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


view : Model -> Element Msg
view model =
    Element.column [ Element.width Element.fill ]
        [ viewBigPicture model
        , Element.row [ Element.width Element.fill ]
            [ viewPrevButton
            , viewBackButton
            , viewNextButton
            ]
        ]


viewBigPicture : Model -> Element Msg
viewBigPicture model =
    case List.head model.images of
        Just image ->
            Element.image [ Element.width Element.fill ]
                { src = image
                , description = "Picture associated with route"
                }

        Nothing ->
            Element.none


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
