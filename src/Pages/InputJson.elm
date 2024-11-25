module Pages.InputJson exposing (Model, Msg(..), page)

import Auth
import Bridge
import ClimbRoute exposing (NewRouteData)
import CommonView
import ConfirmComponent
import Effect exposing (Effect)
import Element exposing (Element)
import Element.Input
import Json.Decode
import JsonRoute
import Lamdera
import Layouts
import Maybe.Extra
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user shared route =
    Page.new
        { init = \_ -> init
        , update = update
        , view = view (shared.routes |> List.length)
        , subscriptions = \_ -> Sub.none
        }
        |> Page.withLayout (\_ -> Layouts.Header {})



-- INIT


type alias Model =
    { text : String
    , statusText : Maybe String
    , parsedRoutes : Maybe (List ClimbRoute.NewRouteData)
    , confirmState : ConfirmComponent.State
    }


init : ( Model, Effect Msg )
init =
    ( { text = ""
      , statusText = Nothing
      , parsedRoutes = Nothing
      , confirmState = ConfirmComponent.initialState
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = TextChanged String
    | SubmitToBackend (List NewRouteData)
    | ConfirmComponentEvent ConfirmComponent.Msg


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ConfirmComponentEvent event ->
            ( { model | confirmState = model.confirmState |> ConfirmComponent.update event }
            , Effect.none
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
            , Effect.none
            )

        SubmitToBackend newRoutes ->
            ( model
            , Effect.sendToBackend <| Bridge.ToBackendResetRouteList newRoutes
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
    CommonView.mainColumn
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
