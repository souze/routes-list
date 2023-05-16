module Sorter exposing (..)

import Element exposing (Element)
import Element.Input
import List
import List.Extra
import Widget
import Widget.Material as Material


type alias Model =
    List ( SortAttribute, SortOrder )


type SorterMsg
    = SorterMsg { row : Int, col : Int }
    | RemoveRow Int


type SortOrder
    = Ascending
    | Descending


type SortAttribute
    = Area
    | Grade
    | Tickdate
    | Name


initialModel : Model
initialModel =
    [ ( Tickdate, Descending ) ]


update : SorterMsg -> Model -> Model
update msg model =
    case msg of
        SorterMsg pos ->
            if pos.row == List.length model then
                clickedNewRow pos.col model

            else
                clickedExistingRow pos model

        RemoveRow row ->
            -- Temporarily disabled
            -- model |> List.Extra.removeAt row
            model


clickedNewRow : Int -> Model -> Model
clickedNewRow col model =
    model ++ [ ( indexToAttr col, Ascending ) ]


clickedExistingRow : { row : Int, col : Int } -> Model -> Model
clickedExistingRow pos model =
    model
        |> List.indexedMap
            (\i ( attr, order ) ->
                if i == pos.row then
                    clickedRow pos.col ( attr, order )

                else
                    ( attr, order )
            )


toggleOrder order =
    case order of
        Ascending ->
            Descending

        Descending ->
            Ascending


clickedRow : Int -> ( SortAttribute, SortOrder ) -> ( SortAttribute, SortOrder )
clickedRow col ( attr, order ) =
    if col == attrToIndex attr then
        -- Clicked on already used attr
        ( attr, toggleOrder order )

    else
        -- Clicked on new Attr
        ( indexToAttr col, Ascending )


sortOptions : (SorterMsg -> msg) -> Model -> Element msg
sortOptions msgFn model =
    Element.column [ Element.spacing 5 ]
        (Element.text "Sort by"
            :: List.indexedMap (viewSortMatrixRow msgFn) model
            ++ [--unselectedRow msgFn (List.length model)
               ]
        )


attrList : List ( SortAttribute, String )
attrList =
    [ ( Grade, "Grade" )
    , ( Name, "Name" )
    , ( Tickdate, "Tickdate" )
    , ( Area, "Area" )
    ]


attrListStr : List String
attrListStr =
    attrList |> List.map Tuple.second


attrToIndex : SortAttribute -> Int
attrToIndex attr =
    case attr of
        Grade ->
            0

        Name ->
            1

        Tickdate ->
            2

        Area ->
            3


indexToAttr : Int -> SortAttribute
indexToAttr i =
    case i of
        0 ->
            Grade

        1 ->
            Name

        2 ->
            Tickdate

        3 ->
            Area

        _ ->
            Grade


viewSortMatrixRow : (SorterMsg -> msg) -> Int -> ( SortAttribute, SortOrder ) -> Element msg
viewSortMatrixRow msgFn row ( attr, order ) =
    Element.row [ Element.spacing 10 ]
        [ selectedRow msgFn row attr order
        , Element.Input.button []
            { onPress = Just (msgFn (RemoveRow row))
            , label =
                Element.text "-"
            }
        ]


selectedRow : (SorterMsg -> msg) -> Int -> SortAttribute -> SortOrder -> Element msg
selectedRow msgFn row attr order =
    select msgFn row (Just ( attr, order ))


unselectedRow : (SorterMsg -> msg) -> Int -> Element msg
unselectedRow msgFn row =
    select msgFn row Nothing


select : (SorterMsg -> msg) -> Int -> Maybe ( SortAttribute, SortOrder ) -> Element msg
select msgFn row selected =
    { selected = selected |> Maybe.map (\( attr, _ ) -> attrToIndex attr)
    , options =
        attrListStr
            |> List.indexedMap
                (\i text ->
                    { text = text
                    , icon =
                        case selected of
                            Just ( attr, order ) ->
                                if i == attrToIndex attr then
                                    case order of
                                        Ascending ->
                                            always (Element.text "⬆️")

                                        Descending ->
                                            always (Element.text "⬇️")

                                else
                                    always Element.none

                            Nothing ->
                                always Element.none
                    }
                )
    , onSelect = \i -> Just <| (SorterMsg { row = row, col = i } |> msgFn)
    }
        |> Widget.select
        |> Widget.buttonRow
            { elementRow = Material.buttonRow
            , content = Material.containedButton Material.defaultPalette
            }
