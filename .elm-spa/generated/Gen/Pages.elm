module Gen.Pages exposing (Model, Msg, init, subscriptions, update, view)

import Browser.Navigation exposing (Key)
import Effect exposing (Effect)
import ElmSpa.Page
import Gen.Params.Home_
import Gen.Params.MoreOptions
import Gen.Params.SignIn
import Gen.Params.Routes.Filter_
import Gen.Params.NotFound
import Gen.Model as Model
import Gen.Msg as Msg
import Gen.Route as Route exposing (Route)
import Page exposing (Page)
import Pages.Home_
import Pages.MoreOptions
import Pages.SignIn
import Pages.Routes.Filter_
import Pages.NotFound
import Request exposing (Request)
import Shared
import Task
import Url exposing (Url)
import View exposing (View)


type alias Model =
    Model.Model


type alias Msg =
    Msg.Msg


init : Route -> Shared.Model -> Url -> Key -> ( Model, Effect Msg )
init route =
    case route of
        Route.Home_ ->
            pages.home_.init ()
    
        Route.MoreOptions ->
            pages.moreOptions.init ()
    
        Route.SignIn ->
            pages.signIn.init ()
    
        Route.Routes__Filter_ params ->
            pages.routes__filter_.init params
    
        Route.NotFound ->
            pages.notFound.init ()


update : Msg -> Model -> Shared.Model -> Url -> Key -> ( Model, Effect Msg )
update msg_ model_ =
    case ( msg_, model_ ) of
        ( Msg.MoreOptions msg, Model.MoreOptions params model ) ->
            pages.moreOptions.update params msg model
    
        ( Msg.SignIn msg, Model.SignIn params model ) ->
            pages.signIn.update params msg model
    
        ( Msg.Routes__Filter_ msg, Model.Routes__Filter_ params model ) ->
            pages.routes__filter_.update params msg model

        _ ->
            \_ _ _ -> ( model_, Effect.none )


view : Model -> Shared.Model -> Url -> Key -> View Msg
view model_ =
    case model_ of
        Model.Redirecting_ ->
            \_ _ _ -> View.none
    
        Model.Home_ params ->
            pages.home_.view params ()
    
        Model.MoreOptions params model ->
            pages.moreOptions.view params model
    
        Model.SignIn params model ->
            pages.signIn.view params model
    
        Model.Routes__Filter_ params model ->
            pages.routes__filter_.view params model
    
        Model.NotFound params ->
            pages.notFound.view params ()


subscriptions : Model -> Shared.Model -> Url -> Key -> Sub Msg
subscriptions model_ =
    case model_ of
        Model.Redirecting_ ->
            \_ _ _ -> Sub.none
    
        Model.Home_ params ->
            pages.home_.subscriptions params ()
    
        Model.MoreOptions params model ->
            pages.moreOptions.subscriptions params model
    
        Model.SignIn params model ->
            pages.signIn.subscriptions params model
    
        Model.Routes__Filter_ params model ->
            pages.routes__filter_.subscriptions params model
    
        Model.NotFound params ->
            pages.notFound.subscriptions params ()



-- INTERNALS


pages :
    { home_ : Static Gen.Params.Home_.Params
    , moreOptions : Bundle Gen.Params.MoreOptions.Params Pages.MoreOptions.Model Pages.MoreOptions.Msg
    , signIn : Bundle Gen.Params.SignIn.Params Pages.SignIn.Model Pages.SignIn.Msg
    , routes__filter_ : Bundle Gen.Params.Routes.Filter_.Params Pages.Routes.Filter_.Model Pages.Routes.Filter_.Msg
    , notFound : Static Gen.Params.NotFound.Params
    }
pages =
    { home_ = static Pages.Home_.view Model.Home_
    , moreOptions = bundle Pages.MoreOptions.page Model.MoreOptions Msg.MoreOptions
    , signIn = bundle Pages.SignIn.page Model.SignIn Msg.SignIn
    , routes__filter_ = bundle Pages.Routes.Filter_.page Model.Routes__Filter_ Msg.Routes__Filter_
    , notFound = static Pages.NotFound.view Model.NotFound
    }


type alias Bundle params model msg =
    ElmSpa.Page.Bundle params model msg Shared.Model (Effect Msg) Model Msg (View Msg)


bundle page toModel toMsg =
    ElmSpa.Page.bundle
        { redirecting =
            { model = Model.Redirecting_
            , view = View.none
            }
        , toRoute = Route.fromUrl
        , toUrl = Route.toHref
        , fromCmd = Effect.fromCmd
        , mapEffect = Effect.map toMsg
        , mapView = View.map toMsg
        , toModel = toModel
        , toMsg = toMsg
        , page = page
        }


type alias Static params =
    Bundle params () Never


static : View Never -> (params -> Model) -> Static params
static view_ toModel =
    { init = \params _ _ _ -> ( toModel params, Effect.none )
    , update = \params _ _ _ _ _ -> ( toModel params, Effect.none )
    , view = \_ _ _ _ _ -> View.map never view_
    , subscriptions = \_ _ _ _ _ -> Sub.none
    }
    
