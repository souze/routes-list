module Pages.Home_ exposing (Model, Msg(..), page)

import Auth
import Effect exposing (Effect)
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user model route =
    Page.new
        { init = \_ -> init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- INIT


type alias Model =
    {}


init : ( Model, Effect Msg )
init =
    ( {}
    , Effect.pushRoutePath <| Route.Path.SignIn_SignInDest_ { signInDest = "_" }
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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    View.placeholder "Home_"
