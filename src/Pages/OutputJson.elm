module Pages.OutputJson exposing (Model, Msg, page)

import CommonView
import Element exposing (Element)
import Element.Input
import Gen.Params.OutputJson exposing (Params)
import Json.Encode
import JsonRoute
import Page
import Request
import Route exposing (RouteData)
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = view shared
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared _ =
    { title = "View Json"
    , body =
        CommonView.mainColumnWithToprow [ viewJsonText shared.routes ]
    }


viewJsonText : List RouteData -> Element Msg
viewJsonText routes =
    Element.Input.multiline []
        { onChange = \_ -> NoOp
        , text = routeListJsonString routes
        , placeholder = Nothing
        , label = Element.Input.labelAbove [] (Element.text "Json")
        , spellcheck = False
        }


routeListJsonString : List RouteData -> String
routeListJsonString routes =
    Json.Encode.encode 4 (Json.Encode.list JsonRoute.encodeRoute routes)
