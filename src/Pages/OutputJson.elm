module Pages.OutputJson exposing (Model, Msg(..), page)

import Auth
import ClimbRoute exposing (RouteData)
import CommonView
import Effect exposing (Effect)
import Element exposing (Element)
import Element.Input
import Json.Encode
import JsonRoute
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user shared route =
    Page.new
        { init = \_ -> init
        , update = update
        , view = view shared
        , subscriptions = \_ -> Sub.none
        }



-- INIT


type alias Model =
    {}


init : ( Model, Effect Msg )
init =
    ( {}, Effect.none )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Effect.none )



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
