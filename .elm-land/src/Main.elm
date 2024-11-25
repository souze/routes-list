module Main exposing (..)

import Auth
import Auth.Action
import Browser
import Browser.Navigation
import Effect exposing (Effect)
import Html exposing (Html)
import Json.Decode
import Layout
import Layouts
import Layouts.Header
import Main.Layouts.Model
import Main.Layouts.Msg
import Main.Pages.Model
import Main.Pages.Msg
import Page
import Pages.Home_
import Pages.Admin
import Pages.Admin.AddUser
import Pages.Admin.ChangePassword
import Pages.Admin.RemoveUser
import Pages.Admin.ShowJson
import Pages.ChangePassword
import Pages.InputJson
import Pages.MoreOptions
import Pages.NewRoute
import Pages.OutputJson
import Pages.Routes.Filter_
import Pages.SignIn
import Pages.Stats
import Pages.NotFound_
import Pages.NotFound_
import Route exposing (Route)
import Route.Path
import Shared
import Task
import Url exposing (Url)
import View exposing (View)


main : Program Json.Decode.Value Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequested
        }



-- INIT


type alias Model =
    { key : Browser.Navigation.Key
    , url : Url
    , page : Main.Pages.Model.Model
    , layout : Maybe Main.Layouts.Model.Model
    , shared : Shared.Model
    }


init : Json.Decode.Value -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init json url key =
    let
        flagsResult : Result Json.Decode.Error Shared.Flags
        flagsResult =
            Json.Decode.decodeValue Shared.decoder json

        ( sharedModel, sharedEffect ) =
            Shared.init flagsResult (Route.fromUrl () url)

        { page, layout } =
            initPageAndLayout { key = key, url = url, shared = sharedModel, layout = Nothing }
    in
    ( { url = url
      , key = key
      , page = Tuple.first page
      , layout = layout |> Maybe.map Tuple.first
      , shared = sharedModel
      }
    , Cmd.batch
          [ Tuple.second page
          , layout |> Maybe.map Tuple.second |> Maybe.withDefault Cmd.none
          , fromSharedEffect { key = key, url = url, shared = sharedModel } sharedEffect
          ]
    )


initLayout : { key : Browser.Navigation.Key, url : Url, shared : Shared.Model, layout : Maybe Main.Layouts.Model.Model } -> Layouts.Layout Msg -> ( Main.Layouts.Model.Model, Cmd Msg )
initLayout model layout =
    case ( layout, model.layout ) of
        ( Layouts.Header props, Just (Main.Layouts.Model.Header existing) ) ->
            ( Main.Layouts.Model.Header existing
            , Cmd.none
            )

        ( Layouts.Header props, _ ) ->
            let
                route : Route ()
                route =
                    Route.fromUrl () model.url

                headerLayout =
                    Layouts.Header.layout props model.shared route

                ( headerLayoutModel, headerLayoutEffect ) =
                    Layout.init headerLayout ()
            in
            ( Main.Layouts.Model.Header { header = headerLayoutModel }
            , fromLayoutEffect model (Effect.map Main.Layouts.Msg.Header headerLayoutEffect)
            )


initPageAndLayout : { key : Browser.Navigation.Key, url : Url, shared : Shared.Model, layout : Maybe Main.Layouts.Model.Model } -> { page : ( Main.Pages.Model.Model, Cmd Msg ), layout : Maybe ( Main.Layouts.Model.Model, Cmd Msg ) }
initPageAndLayout model =
    case Route.Path.fromUrl model.url of
        Route.Path.Home_ ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Home_.Model Pages.Home_.Msg
                        page =
                            Pages.Home_.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.Home_
                            (Effect.map Main.Pages.Msg.Home_ >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Home_ >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.Admin ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Admin.Model Pages.Admin.Msg
                        page =
                            Pages.Admin.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.Admin
                            (Effect.map Main.Pages.Msg.Admin >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Admin >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.Admin_AddUser ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Admin.AddUser.Model Pages.Admin.AddUser.Msg
                        page =
                            Pages.Admin.AddUser.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.Admin_AddUser
                            (Effect.map Main.Pages.Msg.Admin_AddUser >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Admin_AddUser >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.Admin_ChangePassword ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Admin.ChangePassword.Model Pages.Admin.ChangePassword.Msg
                        page =
                            Pages.Admin.ChangePassword.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.Admin_ChangePassword
                            (Effect.map Main.Pages.Msg.Admin_ChangePassword >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Admin_ChangePassword >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.Admin_RemoveUser ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Admin.RemoveUser.Model Pages.Admin.RemoveUser.Msg
                        page =
                            Pages.Admin.RemoveUser.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.Admin_RemoveUser
                            (Effect.map Main.Pages.Msg.Admin_RemoveUser >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Admin_RemoveUser >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.Admin_ShowJson ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Admin.ShowJson.Model Pages.Admin.ShowJson.Msg
                        page =
                            Pages.Admin.ShowJson.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.Admin_ShowJson
                            (Effect.map Main.Pages.Msg.Admin_ShowJson >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Admin_ShowJson >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.ChangePassword ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.ChangePassword.Model Pages.ChangePassword.Msg
                        page =
                            Pages.ChangePassword.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.ChangePassword
                            (Effect.map Main.Pages.Msg.ChangePassword >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.ChangePassword >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.InputJson ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.InputJson.Model Pages.InputJson.Msg
                        page =
                            Pages.InputJson.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.InputJson
                            (Effect.map Main.Pages.Msg.InputJson >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.InputJson >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.MoreOptions ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.MoreOptions.Model Pages.MoreOptions.Msg
                        page =
                            Pages.MoreOptions.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.MoreOptions
                            (Effect.map Main.Pages.Msg.MoreOptions >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.MoreOptions >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.NewRoute ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.NewRoute.Model Pages.NewRoute.Msg
                        page =
                            Pages.NewRoute.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.NewRoute
                            (Effect.map Main.Pages.Msg.NewRoute >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.NewRoute >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.OutputJson ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.OutputJson.Model Pages.OutputJson.Msg
                        page =
                            Pages.OutputJson.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.OutputJson
                            (Effect.map Main.Pages.Msg.OutputJson >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.OutputJson >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.Routes_Filter_ params ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Routes.Filter_.Model Pages.Routes.Filter_.Msg
                        page =
                            Pages.Routes.Filter_.page user model.shared (Route.fromUrl params model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            (Main.Pages.Model.Routes_Filter_ params)
                            (Effect.map Main.Pages.Msg.Routes_Filter_ >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Routes_Filter_ >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.SignIn ->
            let
                page : Page.Page Pages.SignIn.Model Pages.SignIn.Msg
                page =
                    Pages.SignIn.page model.shared (Route.fromUrl () model.url)

                ( pageModel, pageEffect ) =
                    Page.init page ()
            in
            { page = 
                Tuple.mapBoth
                    Main.Pages.Model.SignIn
                    (Effect.map Main.Pages.Msg.SignIn >> fromPageEffect model)
                    ( pageModel, pageEffect )
            , layout = 
                Page.layout pageModel page
                    |> Maybe.map (Layouts.map (Main.Pages.Msg.SignIn >> Page))
                    |> Maybe.map (initLayout model)
            }

        Route.Path.Stats ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Stats.Model Pages.Stats.Msg
                        page =
                            Pages.Stats.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.Stats
                            (Effect.map Main.Pages.Msg.Stats >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Stats >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.NotFound_ ->
            let
                page : Page.Page Pages.NotFound_.Model Pages.NotFound_.Msg
                page =
                    Pages.NotFound_.page model.shared (Route.fromUrl () model.url)

                ( pageModel, pageEffect ) =
                    Page.init page ()
            in
            { page = 
                Tuple.mapBoth
                    Main.Pages.Model.NotFound_
                    (Effect.map Main.Pages.Msg.NotFound_ >> fromPageEffect model)
                    ( pageModel, pageEffect )
            , layout = 
                Page.layout pageModel page
                    |> Maybe.map (Layouts.map (Main.Pages.Msg.NotFound_ >> Page))
                    |> Maybe.map (initLayout model)
            }


runWhenAuthenticated : { model | shared : Shared.Model, url : Url, key : Browser.Navigation.Key } -> (Auth.User -> ( Main.Pages.Model.Model, Cmd Msg )) -> ( Main.Pages.Model.Model, Cmd Msg )
runWhenAuthenticated model toTuple =
    let
        record =
            runWhenAuthenticatedWithLayout model (\user -> { page = toTuple user, layout = Nothing })
    in
    record.page


runWhenAuthenticatedWithLayout : { model | shared : Shared.Model, url : Url, key : Browser.Navigation.Key } -> (Auth.User -> { page : ( Main.Pages.Model.Model, Cmd Msg ), layout : Maybe ( Main.Layouts.Model.Model, Cmd Msg ) }) -> { page : ( Main.Pages.Model.Model, Cmd Msg ), layout : Maybe ( Main.Layouts.Model.Model, Cmd Msg ) }
runWhenAuthenticatedWithLayout model toRecord =
    let
        authAction : Auth.Action.Action Auth.User
        authAction =
            Auth.onPageLoad model.shared (Route.fromUrl () model.url)

        toCmd : Effect Msg -> Cmd Msg
        toCmd =
            Effect.toCmd
                { key = model.key
                , url = model.url
                , shared = model.shared
                , fromSharedMsg = Shared
                , batch = Batch
                , toCmd = Task.succeed >> Task.perform identity
                }
    in
    case authAction of
        Auth.Action.LoadPageWithUser user ->
            toRecord user

        Auth.Action.LoadCustomPage ->
            { page = 
                ( Main.Pages.Model.Loading_
                , Cmd.none
                )
            , layout = Nothing
            }

        Auth.Action.ReplaceRoute options ->
            { page = 
                ( Main.Pages.Model.Redirecting_
                , toCmd (Effect.replaceRoute options)
                )
            , layout = Nothing
            }

        Auth.Action.PushRoute options ->
            { page = 
                ( Main.Pages.Model.Redirecting_
                , toCmd (Effect.pushRoute options)
                )
            , layout = Nothing
            }

        Auth.Action.LoadExternalUrl externalUrl ->
            { page = 
                ( Main.Pages.Model.Redirecting_
                , Browser.Navigation.load externalUrl
                )
            , layout = Nothing
            }



-- UPDATE


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url
    | Page Main.Pages.Msg.Msg
    | Layout Main.Layouts.Msg.Msg
    | Shared Shared.Msg
    | Batch (List Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequested (Browser.Internal url) ->
            ( model
            , Browser.Navigation.pushUrl model.key (Url.toString url)
            )

        UrlRequested (Browser.External url) ->
            if String.isEmpty (String.trim url) then
                ( model, Cmd.none )

            else
                ( model
                , Browser.Navigation.load url
                )

        UrlChanged url ->
            if Route.Path.fromUrl url == Route.Path.fromUrl model.url then
                let
                    newModel : Model
                    newModel =
                        { model | url = url }
                in
                ( newModel
                , Cmd.batch
                      [ toPageUrlHookCmd newModel
                            { from = Route.fromUrl () model.url
                            , to = Route.fromUrl () newModel.url
                            }
                      , toLayoutUrlHookCmd model newModel
                            { from = Route.fromUrl () model.url
                            , to = Route.fromUrl () newModel.url
                            }
                      ]
                )

            else
                let
                    { page, layout } =
                        initPageAndLayout { key = model.key, shared = model.shared, layout = model.layout, url = url }

                    ( pageModel, pageCmd ) =
                        page

                    ( layoutModel, layoutCmd ) =
                        case layout of
                            Just ( layoutModel_, layoutCmd_ ) ->
                                ( Just layoutModel_, layoutCmd_ )

                            Nothing ->
                                ( Nothing, Cmd.none )

                    newModel =
                        { model | url = url, page = pageModel, layout = layoutModel }
                in
                ( newModel
                , Cmd.batch
                      [ pageCmd
                      , layoutCmd
                      , toLayoutUrlHookCmd model newModel
                            { from = Route.fromUrl () model.url
                            , to = Route.fromUrl () newModel.url
                            }
                      ]
                )

        Page pageMsg ->
            let
                ( pageModel, pageCmd ) =
                    updateFromPage pageMsg model
            in
            ( { model | page = pageModel }
            , pageCmd
            )

        Layout layoutMsg ->
            let
                ( layoutModel, layoutCmd ) =
                    updateFromLayout layoutMsg model
            in
            ( { model | layout = layoutModel }
            , layoutCmd
            )

        Shared sharedMsg ->
            let
                ( sharedModel, sharedEffect ) =
                    Shared.update (Route.fromUrl () model.url) sharedMsg model.shared

                ( oldAction, newAction ) =
                    ( Auth.onPageLoad model.shared (Route.fromUrl () model.url)
                    , Auth.onPageLoad sharedModel (Route.fromUrl () model.url)
                    )
            in
            if isAuthProtected (Route.fromUrl () model.url).path && (hasActionTypeChanged oldAction newAction) then
                let
                    { layout, page } =
                        initPageAndLayout { key = model.key, shared = sharedModel, url = model.url, layout = model.layout }

                    ( pageModel, pageCmd ) =
                        page

                    ( layoutModel, layoutCmd ) =
                        ( layout |> Maybe.map Tuple.first
                        , layout |> Maybe.map Tuple.second |> Maybe.withDefault Cmd.none
                        )
                in
                ( { model | shared = sharedModel, page = pageModel, layout = layoutModel }
                , Cmd.batch
                      [ pageCmd
                      , layoutCmd
                      , fromSharedEffect { model | shared = sharedModel } sharedEffect
                      ]
                )

            else
                ( { model | shared = sharedModel }
                , fromSharedEffect { model | shared = sharedModel } sharedEffect
                )

        Batch messages ->
            ( model
            , messages
                  |> List.map (Task.succeed >> Task.perform identity)
                  |> Cmd.batch
            )


updateFromPage : Main.Pages.Msg.Msg -> Model -> ( Main.Pages.Model.Model, Cmd Msg )
updateFromPage msg model =
    case ( msg, model.page ) of
        ( Main.Pages.Msg.Home_ pageMsg, Main.Pages.Model.Home_ pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.Home_
                        (Effect.map Main.Pages.Msg.Home_ >> fromPageEffect model)
                        (Page.update (Pages.Home_.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Admin pageMsg, Main.Pages.Model.Admin pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.Admin
                        (Effect.map Main.Pages.Msg.Admin >> fromPageEffect model)
                        (Page.update (Pages.Admin.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Admin_AddUser pageMsg, Main.Pages.Model.Admin_AddUser pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.Admin_AddUser
                        (Effect.map Main.Pages.Msg.Admin_AddUser >> fromPageEffect model)
                        (Page.update (Pages.Admin.AddUser.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Admin_ChangePassword pageMsg, Main.Pages.Model.Admin_ChangePassword pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.Admin_ChangePassword
                        (Effect.map Main.Pages.Msg.Admin_ChangePassword >> fromPageEffect model)
                        (Page.update (Pages.Admin.ChangePassword.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Admin_RemoveUser pageMsg, Main.Pages.Model.Admin_RemoveUser pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.Admin_RemoveUser
                        (Effect.map Main.Pages.Msg.Admin_RemoveUser >> fromPageEffect model)
                        (Page.update (Pages.Admin.RemoveUser.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Admin_ShowJson pageMsg, Main.Pages.Model.Admin_ShowJson pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.Admin_ShowJson
                        (Effect.map Main.Pages.Msg.Admin_ShowJson >> fromPageEffect model)
                        (Page.update (Pages.Admin.ShowJson.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.ChangePassword pageMsg, Main.Pages.Model.ChangePassword pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.ChangePassword
                        (Effect.map Main.Pages.Msg.ChangePassword >> fromPageEffect model)
                        (Page.update (Pages.ChangePassword.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.InputJson pageMsg, Main.Pages.Model.InputJson pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.InputJson
                        (Effect.map Main.Pages.Msg.InputJson >> fromPageEffect model)
                        (Page.update (Pages.InputJson.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.MoreOptions pageMsg, Main.Pages.Model.MoreOptions pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.MoreOptions
                        (Effect.map Main.Pages.Msg.MoreOptions >> fromPageEffect model)
                        (Page.update (Pages.MoreOptions.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.NewRoute pageMsg, Main.Pages.Model.NewRoute pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.NewRoute
                        (Effect.map Main.Pages.Msg.NewRoute >> fromPageEffect model)
                        (Page.update (Pages.NewRoute.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.OutputJson pageMsg, Main.Pages.Model.OutputJson pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.OutputJson
                        (Effect.map Main.Pages.Msg.OutputJson >> fromPageEffect model)
                        (Page.update (Pages.OutputJson.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Routes_Filter_ pageMsg, Main.Pages.Model.Routes_Filter_ params pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        (Main.Pages.Model.Routes_Filter_ params)
                        (Effect.map Main.Pages.Msg.Routes_Filter_ >> fromPageEffect model)
                        (Page.update (Pages.Routes.Filter_.page user model.shared (Route.fromUrl params model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.SignIn pageMsg, Main.Pages.Model.SignIn pageModel ) ->
            Tuple.mapBoth
                Main.Pages.Model.SignIn
                (Effect.map Main.Pages.Msg.SignIn >> fromPageEffect model)
                (Page.update (Pages.SignIn.page model.shared (Route.fromUrl () model.url)) pageMsg pageModel)

        ( Main.Pages.Msg.Stats pageMsg, Main.Pages.Model.Stats pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.Stats
                        (Effect.map Main.Pages.Msg.Stats >> fromPageEffect model)
                        (Page.update (Pages.Stats.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.NotFound_ pageMsg, Main.Pages.Model.NotFound_ pageModel ) ->
            Tuple.mapBoth
                Main.Pages.Model.NotFound_
                (Effect.map Main.Pages.Msg.NotFound_ >> fromPageEffect model)
                (Page.update (Pages.NotFound_.page model.shared (Route.fromUrl () model.url)) pageMsg pageModel)

        _ ->
            ( model.page
            , Cmd.none
            )


updateFromLayout : Main.Layouts.Msg.Msg -> Model -> ( Maybe Main.Layouts.Model.Model, Cmd Msg )
updateFromLayout msg model =
    let
        route : Route ()
        route =
            Route.fromUrl () model.url
    in
    case ( toLayoutFromPage model, model.layout, msg ) of
        ( Just (Layouts.Header props), Just (Main.Layouts.Model.Header layoutModel), Main.Layouts.Msg.Header layoutMsg ) ->
            Tuple.mapBoth
                (\newModel -> Just (Main.Layouts.Model.Header { layoutModel | header = newModel }))
                (Effect.map Main.Layouts.Msg.Header >> fromLayoutEffect model)
                (Layout.update (Layouts.Header.layout props model.shared route) layoutMsg layoutModel.header)

        _ ->
            ( model.layout
            , Cmd.none
            )


toLayoutFromPage : Model -> Maybe (Layouts.Layout Msg)
toLayoutFromPage model =
    case model.page of
        Main.Pages.Model.Home_ pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Home_.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Home_ >> Page))

        Main.Pages.Model.Admin pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Admin.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Admin >> Page))

        Main.Pages.Model.Admin_AddUser pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Admin.AddUser.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Admin_AddUser >> Page))

        Main.Pages.Model.Admin_ChangePassword pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Admin.ChangePassword.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Admin_ChangePassword >> Page))

        Main.Pages.Model.Admin_RemoveUser pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Admin.RemoveUser.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Admin_RemoveUser >> Page))

        Main.Pages.Model.Admin_ShowJson pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Admin.ShowJson.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Admin_ShowJson >> Page))

        Main.Pages.Model.ChangePassword pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.ChangePassword.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.ChangePassword >> Page))

        Main.Pages.Model.InputJson pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.InputJson.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.InputJson >> Page))

        Main.Pages.Model.MoreOptions pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.MoreOptions.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.MoreOptions >> Page))

        Main.Pages.Model.NewRoute pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.NewRoute.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.NewRoute >> Page))

        Main.Pages.Model.OutputJson pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.OutputJson.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.OutputJson >> Page))

        Main.Pages.Model.Routes_Filter_ params pageModel ->
            Route.fromUrl params model.url
                |> toAuthProtectedPage model Pages.Routes.Filter_.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Routes_Filter_ >> Page))

        Main.Pages.Model.SignIn pageModel ->
            Route.fromUrl () model.url
                |> Pages.SignIn.page model.shared
                |> Page.layout pageModel
                |> Maybe.map (Layouts.map (Main.Pages.Msg.SignIn >> Page))

        Main.Pages.Model.Stats pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Stats.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Stats >> Page))

        Main.Pages.Model.NotFound_ pageModel ->
            Route.fromUrl () model.url
                |> Pages.NotFound_.page model.shared
                |> Page.layout pageModel
                |> Maybe.map (Layouts.map (Main.Pages.Msg.NotFound_ >> Page))

        Main.Pages.Model.Redirecting_ ->
            Nothing

        Main.Pages.Model.Loading_ ->
            Nothing


toAuthProtectedPage : Model -> (Auth.User -> Shared.Model -> Route params -> Page.Page model msg) -> Route params -> Maybe (Page.Page model msg)
toAuthProtectedPage model toPage route =
    case Auth.onPageLoad model.shared (Route.fromUrl () model.url) of
        Auth.Action.LoadPageWithUser user ->
            Just (toPage user model.shared route)

        _ ->
            Nothing


hasActionTypeChanged : Auth.Action.Action user -> Auth.Action.Action user -> Bool
hasActionTypeChanged oldAction newAction =
    case ( newAction, oldAction ) of
        ( Auth.Action.LoadPageWithUser _, Auth.Action.LoadPageWithUser _ ) ->
            False

        ( Auth.Action.LoadCustomPage, Auth.Action.LoadCustomPage ) ->
            False

        ( Auth.Action.ReplaceRoute _, Auth.Action.ReplaceRoute _ ) ->
            False

        ( Auth.Action.PushRoute _, Auth.Action.PushRoute _ ) ->
            False

        ( Auth.Action.LoadExternalUrl _, Auth.Action.LoadExternalUrl _ ) ->
            False

        ( _,  _ ) ->
            True


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        subscriptionsFromPage : Sub Msg
        subscriptionsFromPage =
            case model.page of
                Main.Pages.Model.Home_ pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Home_.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Home_
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Admin pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Admin.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Admin
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Admin_AddUser pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Admin.AddUser.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Admin_AddUser
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Admin_ChangePassword pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Admin.ChangePassword.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Admin_ChangePassword
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Admin_RemoveUser pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Admin.RemoveUser.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Admin_RemoveUser
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Admin_ShowJson pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Admin.ShowJson.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Admin_ShowJson
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.ChangePassword pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.ChangePassword.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.ChangePassword
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.InputJson pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.InputJson.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.InputJson
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.MoreOptions pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.MoreOptions.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.MoreOptions
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.NewRoute pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.NewRoute.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.NewRoute
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.OutputJson pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.OutputJson.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.OutputJson
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Routes_Filter_ params pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Routes.Filter_.page user model.shared (Route.fromUrl params model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Routes_Filter_
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.SignIn pageModel ->
                    Page.subscriptions (Pages.SignIn.page model.shared (Route.fromUrl () model.url)) pageModel
                        |> Sub.map Main.Pages.Msg.SignIn
                        |> Sub.map Page

                Main.Pages.Model.Stats pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Stats.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Stats
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.NotFound_ pageModel ->
                    Page.subscriptions (Pages.NotFound_.page model.shared (Route.fromUrl () model.url)) pageModel
                        |> Sub.map Main.Pages.Msg.NotFound_
                        |> Sub.map Page

                Main.Pages.Model.Redirecting_ ->
                    Sub.none

                Main.Pages.Model.Loading_ ->
                    Sub.none

        maybeLayout : Maybe (Layouts.Layout Msg)
        maybeLayout =
            toLayoutFromPage model

        route : Route ()
        route =
            Route.fromUrl () model.url

        subscriptionsFromLayout : Sub Msg
        subscriptionsFromLayout =
            case ( maybeLayout, model.layout ) of
                ( Just (Layouts.Header props), Just (Main.Layouts.Model.Header layoutModel) ) ->
                    Layout.subscriptions (Layouts.Header.layout props model.shared route) layoutModel.header
                        |> Sub.map Main.Layouts.Msg.Header
                        |> Sub.map Layout

                _ ->
                    Sub.none
    in
    Sub.batch
        [ Shared.subscriptions route model.shared
              |> Sub.map Shared
        , subscriptionsFromPage
        , subscriptionsFromLayout
        ]



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        view_ : View Msg
        view_ =
            toView model
    in
    View.toBrowserDocument
        { shared = model.shared
        , route = Route.fromUrl () model.url
        , view = view_
        }


toView : Model -> View Msg
toView model =
    let
        route : Route ()
        route =
            Route.fromUrl () model.url
    in
    case ( toLayoutFromPage model, model.layout ) of
        ( Just (Layouts.Header props), Just (Main.Layouts.Model.Header layoutModel) ) ->
            Layout.view
                (Layouts.Header.layout props model.shared route)
                { model = layoutModel.header
                , toContentMsg = Main.Layouts.Msg.Header >> Layout
                , content = viewPage model
                }

        _ ->
            viewPage model


viewPage : Model -> View Msg
viewPage model =
    case model.page of
        Main.Pages.Model.Home_ pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Home_.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.Home_
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Admin pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Admin.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.Admin
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Admin_AddUser pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Admin.AddUser.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.Admin_AddUser
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Admin_ChangePassword pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Admin.ChangePassword.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.Admin_ChangePassword
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Admin_RemoveUser pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Admin.RemoveUser.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.Admin_RemoveUser
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Admin_ShowJson pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Admin.ShowJson.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.Admin_ShowJson
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.ChangePassword pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.ChangePassword.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.ChangePassword
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.InputJson pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.InputJson.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.InputJson
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.MoreOptions pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.MoreOptions.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.MoreOptions
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.NewRoute pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.NewRoute.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.NewRoute
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.OutputJson pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.OutputJson.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.OutputJson
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Routes_Filter_ params pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Routes.Filter_.page user model.shared (Route.fromUrl params model.url)) pageModel
                        |> View.map Main.Pages.Msg.Routes_Filter_
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.SignIn pageModel ->
            Page.view (Pages.SignIn.page model.shared (Route.fromUrl () model.url)) pageModel
                |> View.map Main.Pages.Msg.SignIn
                |> View.map Page

        Main.Pages.Model.Stats pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Stats.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.Stats
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.NotFound_ pageModel ->
            Page.view (Pages.NotFound_.page model.shared (Route.fromUrl () model.url)) pageModel
                |> View.map Main.Pages.Msg.NotFound_
                |> View.map Page

        Main.Pages.Model.Redirecting_ ->
            View.none

        Main.Pages.Model.Loading_ ->
            Auth.viewCustomPage model.shared (Route.fromUrl () model.url)
                |> View.map never



-- INTERNALS


fromPageEffect : { model | key : Browser.Navigation.Key, url : Url, shared : Shared.Model } -> Effect Main.Pages.Msg.Msg -> Cmd Msg
fromPageEffect model effect =
    Effect.toCmd
        { key = model.key
        , url = model.url
        , shared = model.shared
        , fromSharedMsg = Shared
        , batch = Batch
        , toCmd = Task.succeed >> Task.perform identity
        }
        (Effect.map Page effect)


fromLayoutEffect : { model | key : Browser.Navigation.Key, url : Url, shared : Shared.Model } -> Effect Main.Layouts.Msg.Msg -> Cmd Msg
fromLayoutEffect model effect =
    Effect.toCmd
        { key = model.key
        , url = model.url
        , shared = model.shared
        , fromSharedMsg = Shared
        , batch = Batch
        , toCmd = Task.succeed >> Task.perform identity
        }
        (Effect.map Layout effect)


fromSharedEffect : { model | key : Browser.Navigation.Key, url : Url, shared : Shared.Model } -> Effect Shared.Msg -> Cmd Msg
fromSharedEffect model effect =
    Effect.toCmd
        { key = model.key
        , url = model.url
        , shared = model.shared
        , fromSharedMsg = Shared
        , batch = Batch
        , toCmd = Task.succeed >> Task.perform identity
        }
        (Effect.map Shared effect)



-- URL HOOKS FOR PAGES


toPageUrlHookCmd : Model -> { from : Route (), to : Route () } -> Cmd Msg
toPageUrlHookCmd model routes =
    let
        toCommands messages =
            messages
                |> List.map (Task.succeed >> Task.perform identity)
                |> Cmd.batch
    in
    case model.page of
        Main.Pages.Model.Home_ pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Home_.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.Home_
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Admin pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Admin.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.Admin
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Admin_AddUser pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Admin.AddUser.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.Admin_AddUser
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Admin_ChangePassword pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Admin.ChangePassword.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.Admin_ChangePassword
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Admin_RemoveUser pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Admin.RemoveUser.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.Admin_RemoveUser
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Admin_ShowJson pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Admin.ShowJson.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.Admin_ShowJson
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.ChangePassword pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.ChangePassword.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.ChangePassword
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.InputJson pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.InputJson.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.InputJson
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.MoreOptions pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.MoreOptions.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.MoreOptions
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.NewRoute pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.NewRoute.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.NewRoute
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.OutputJson pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.OutputJson.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.OutputJson
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Routes_Filter_ params pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Routes.Filter_.page user model.shared (Route.fromUrl params model.url)) 
                        |> List.map Main.Pages.Msg.Routes_Filter_
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.SignIn pageModel ->
            Page.toUrlMessages routes (Pages.SignIn.page model.shared (Route.fromUrl () model.url)) 
                |> List.map Main.Pages.Msg.SignIn
                |> List.map Page
                |> toCommands

        Main.Pages.Model.Stats pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Stats.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.Stats
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.NotFound_ pageModel ->
            Page.toUrlMessages routes (Pages.NotFound_.page model.shared (Route.fromUrl () model.url)) 
                |> List.map Main.Pages.Msg.NotFound_
                |> List.map Page
                |> toCommands

        Main.Pages.Model.Redirecting_ ->
            Cmd.none

        Main.Pages.Model.Loading_ ->
            Cmd.none


toLayoutUrlHookCmd : Model -> Model -> { from : Route (), to : Route () } -> Cmd Msg
toLayoutUrlHookCmd oldModel model routes =
    let
        toCommands messages =
            if shouldFireUrlChangedEvents then
                messages
                    |> List.map (Task.succeed >> Task.perform identity)
                    |> Cmd.batch

            else
                Cmd.none

        shouldFireUrlChangedEvents =
            hasNavigatedWithinNewLayout
                { from = toLayoutFromPage oldModel
                , to = toLayoutFromPage model
                }

        route =
            Route.fromUrl () model.url
    in
    case ( toLayoutFromPage model, model.layout ) of
        ( Just (Layouts.Header props), Just (Main.Layouts.Model.Header layoutModel) ) ->
            Layout.toUrlMessages routes (Layouts.Header.layout props model.shared route)
                |> List.map Main.Layouts.Msg.Header
                |> List.map Layout
                |> toCommands

        _ ->
            Cmd.none


hasNavigatedWithinNewLayout : { from : Maybe (Layouts.Layout msg), to : Maybe (Layouts.Layout msg) } -> Bool
hasNavigatedWithinNewLayout { from, to } =
    let
        isRelated maybePair =
            case maybePair of
                Just ( Layouts.Header _, Layouts.Header _ ) ->
                    True

                _ ->
                    False
    in
    List.any isRelated
        [ Maybe.map2 Tuple.pair from to
        , Maybe.map2 Tuple.pair to from
        ]


isAuthProtected : Route.Path.Path -> Bool
isAuthProtected routePath =
    case routePath of
        Route.Path.Home_ ->
            True

        Route.Path.Admin ->
            True

        Route.Path.Admin_AddUser ->
            True

        Route.Path.Admin_ChangePassword ->
            True

        Route.Path.Admin_RemoveUser ->
            True

        Route.Path.Admin_ShowJson ->
            True

        Route.Path.ChangePassword ->
            True

        Route.Path.InputJson ->
            True

        Route.Path.MoreOptions ->
            True

        Route.Path.NewRoute ->
            True

        Route.Path.OutputJson ->
            True

        Route.Path.Routes_Filter_ _ ->
            True

        Route.Path.SignIn ->
            False

        Route.Path.Stats ->
            True

        Route.Path.NotFound_ ->
            False
