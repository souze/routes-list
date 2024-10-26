module Pages.Home_ exposing (Model, Msg(..), page)

import Gen.Params.Home_ exposing (Params)
import Gen.Route
import Page
import Request
import Shared
import View exposing (View)


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user model route =
    Page.new
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- INIT


type alias Model =
    {}


init : Request.With Params -> ( Model, Cmd Msg )
init req =
    ( {}
    , Request.pushRoute (Gen.Route.Routes__Filter_ { filter = "all" }) req
    )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    View.placeholder "Home_"
