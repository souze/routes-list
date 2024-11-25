module Layouts.Header exposing (Model, Msg, Props, layout)

import CommonView
import Effect exposing (Effect)
import Element exposing (Element)
import Html exposing (Html)
import Html.Attributes exposing (class)
import Layout exposing (Layout)
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


type alias Props =
    {}


layout : Props -> Shared.Model -> Route () -> Layout () Model Msg contentMsg
layout props shared route =
    Layout.new
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init _ =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model
            , Effect.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view :
    { toContentMsg : Msg -> contentMsg
    , content : View contentMsg
    , model : Model
    }
    -> View contentMsg
view { toContentMsg, model, content } =
    { title = content.title
    , body =
        Element.column [ Element.spacing 10, Element.padding 20, Element.width Element.fill ]
            [ header
            , content.body
            ]
    }


header : Element msg
header =
    Element.row [ Element.spacing 10 ]
        [ CommonView.linkToRoute "Log" <| Route.Path.Routes_Filter_ { filter = "log" }
        , CommonView.linkToRoute "Wishlist" <| Route.Path.Routes_Filter_ { filter = "wishlist" }
        , CommonView.linkToRoute "+" <| Route.Path.NewRoute
        , CommonView.linkToRoute "..." <| Route.Path.MoreOptions
        ]
