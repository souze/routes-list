module JsonRoute exposing (decodeRouteList, encodeRoute)

import Date exposing (Date)
import Html exposing (b)
import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Route exposing (ClimbType(..), NewRouteData, RouteData)
import Types exposing (DatePickerData)


decodeRouteList : Json.Decode.Decoder (List NewRouteData)
decodeRouteList =
    Json.Decode.list routeObjectDecoder


type alias NewRouteData =
    { name : String
    , area : String
    , grade : String
    , notes : String
    , tickDate2 : Maybe Date
    , type_ : ClimbType
    }


routeObjectDecoder : Json.Decode.Decoder NewRouteData
routeObjectDecoder =
    Json.Decode.succeed NewRouteData
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.optional "area" Json.Decode.string "Unknown area"
        |> Json.Decode.Pipeline.required "grade" Json.Decode.string
        |> Json.Decode.Pipeline.optional "comments" Json.Decode.string ""
        |> Json.Decode.Pipeline.optional "tickdate" tickDateDecoder Nothing
        |> Json.Decode.Pipeline.required "type" climbTypeDecoder


tickDateDecoder : Json.Decode.Decoder (Maybe Date)
tickDateDecoder =
    Json.Decode.map
        decodeTickdateString
        Json.Decode.string


decodeTickdateString : String -> Maybe Date
decodeTickdateString =
    String.split "T"
        >> List.head
        >> Maybe.withDefault ""
        >> Date.fromIsoString
        >> resultToMaybe


climbTypeDecoder : Json.Decode.Decoder ClimbType
climbTypeDecoder =
    Json.Decode.map
        (\s ->
            case s of
                "trad" ->
                    Trad

                "sport" ->
                    Sport

                "mix" ->
                    Mix

                "boulder" ->
                    Boulder

                _ ->
                    Trad
        )
        Json.Decode.string


encodeRoute : RouteData -> Json.Encode.Value
encodeRoute route =
    Json.Encode.object
        ([ ( "name", Json.Encode.string route.name )
         , ( "area", Json.Encode.string route.area )
         , ( "grade", Json.Encode.string route.grade )
         , ( "comments", Json.Encode.string route.notes )
         , ( "type", Json.Encode.string (Route.climbTypeToString route.type_) )
         ]
            ++ (case route.tickDate2 of
                    Just date ->
                        [ ( "tickdate", Json.Encode.string (Date.toIsoString date) ) ]

                    Nothing ->
                        []
               )
        )


resultToMaybe : Result a b -> Maybe b
resultToMaybe res =
    case res of
        Ok val ->
            Just val

        Err err ->
            Nothing
