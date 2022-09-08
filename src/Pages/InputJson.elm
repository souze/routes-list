module Pages.InputJson exposing (Model, Msg, page)

import Bridge
import CommonView
import ConfirmComponent
import Element exposing (Element)
import Element.Input
import Gen.Params.InputJson exposing (Params)
import Json.Decode
import JsonRoute
import Lamdera
import Maybe.Extra
import Page
import Request
import Route exposing (NewRouteData)
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = view (shared.routes |> List.length)
        , subscriptions = \_ -> Sub.none
        }



-- INIT


type alias Model =
    { text : String
    , statusText : Maybe String
    , parsedRoutes : Maybe (List Route.NewRouteData)
    , confirmState : ConfirmComponent.State
    }


init : ( Model, Cmd Msg )
init =
    ( { text = ""
      , statusText = Nothing
      , parsedRoutes = Nothing
      , confirmState = ConfirmComponent.initialState
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = TextChanged String
    | SubmitToBackend (List NewRouteData)
    | ConfirmComponentEvent ConfirmComponent.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ConfirmComponentEvent event ->
            ( { model | confirmState = model.confirmState |> ConfirmComponent.update event }
            , Cmd.none
            )

        TextChanged newValue ->
            ( case tryDecode newValue of
                Ok parsedRoutes ->
                    { text = newValue
                    , statusText = Nothing
                    , parsedRoutes = Just parsedRoutes
                    , confirmState = ConfirmComponent.initialState
                    }

                Err err ->
                    { text = newValue
                    , statusText = Just <| Json.Decode.errorToString err
                    , parsedRoutes = Nothing
                    , confirmState = ConfirmComponent.initialState
                    }
            , Cmd.none
            )

        SubmitToBackend newRoutes ->
            ( model
            , Lamdera.sendToBackend <| Bridge.ToBackendResetRouteList newRoutes
            )


tryDecode : String -> Result Json.Decode.Error (List NewRouteData)
tryDecode =
    Json.Decode.decodeString JsonRoute.decodeRouteList



-- VIEW


view : Int -> Model -> View Msg
view routeCount model =
    { title = "Input Json"
    , body = viewBody routeCount model
    }


viewBody : Int -> Model -> Element Msg
viewBody routeCount model =
    CommonView.mainColumnWithToprow
        [ viewJsonInput model.text
        , model.statusText
            |> Maybe.map viewJsonInputError
            |> Maybe.withDefault Element.none
        , viewJsonInputSubmitButton model.confirmState model.parsedRoutes routeCount
        ]


viewJsonInputSubmitButton : ConfirmComponent.State -> Maybe (List NewRouteData) -> Int -> Element Msg
viewJsonInputSubmitButton confirmState newRoutes routeCount =
    case newRoutes of
        Just newRoutes_ ->
            ConfirmComponent.view confirmState
                (ConfirmComponent.ButtonText "Reset climb log")
                (ConfirmComponent.TargetText "Confirm")
                (ConfirmComponent.Description <| "This will replace the current " ++ String.fromInt routeCount ++ " routes with the input " ++ String.fromInt (List.length newRoutes_) ++ " routes, Are you really sure?")
                ConfirmComponentEvent
                (SubmitToBackend newRoutes_)

        Nothing ->
            Element.none


viewJsonInputError : String -> Element msg
viewJsonInputError err =
    Element.text err


viewJsonInput : String -> Element Msg
viewJsonInput text =
    Element.Input.multiline []
        { onChange = TextChanged
        , text = text
        , placeholder = Nothing
        , label = Element.Input.labelAbove [] (Element.text "Json")
        , spellcheck = False
        }
