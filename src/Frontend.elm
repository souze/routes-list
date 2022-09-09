module Frontend exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation as Nav exposing (Key)
import Date
import Effect
import Element
import Gen.Model
import Gen.Msg
import Gen.Pages as Pages
import Gen.Route
import Lamdera
import Pages.Admin.ShowJson
import Request
import Shared
import Task
import Time
import Types exposing (..)
import Url exposing (Url)
import View


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


init : Url -> Key -> ( Model, Cmd Msg )
init url key =
    let
        ( shared, sharedCmd ) =
            Shared.init (Request.create () url key) ()

        ( page, effect ) =
            Pages.init (Gen.Route.fromUrl url) shared url key
    in
    ( initialFrontendModel url key shared page
    , Cmd.batch
        [ Cmd.map Shared sharedCmd
        , Effect.toCmd ( Shared, Page ) effect
        ]
    )


initialFrontendModel : Url.Url -> Key -> Shared.Model -> Pages.Model -> Model
initialFrontendModel url key shared page =
    { url = url
    , key = key
    , shared = shared
    , page = page
    , message = "Welcome to Lamdera! You're looking at the auto-generated base implementation. Check out src/Frontend.elm to start coding!"
    , currentDate = Date.fromCalendarDate 2022 Time.Aug 1
    , rows = []
    }



-- UPDATE


scrollPageToTop =
    Task.perform (\_ -> NoOpFrontendMsg) (Browser.Dom.setViewport 0 0)


type alias Msg =
    FrontendMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedLink (Browser.Internal url) ->
            ( model
            , Nav.pushUrl model.key (Url.toString url)
            )

        ClickedLink (Browser.External url) ->
            ( model
            , Nav.load url
            )

        ChangedUrl url ->
            if url.path /= model.url.path then
                let
                    ( page, effect ) =
                        Pages.init (Gen.Route.fromUrl url) model.shared url model.key
                in
                ( { model | url = url, page = page }
                , Cmd.batch [ Effect.toCmd ( Shared, Page ) effect, scrollPageToTop ]
                )

            else
                ( { model | url = url }, Cmd.none )

        Shared sharedMsg ->
            sharedUpdate model sharedMsg

        Page pageMsg ->
            pageUpdate pageMsg model

        NoOpFrontendMsg ->
            ( model, Cmd.none )

        _ ->
            -- TODO, separate FrontendMsg for page routing and FrontendMsg from old frontend
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        AllRoutesAnnouncement routes ->
            sharedUpdate model (Shared.MsgFromBackend (Shared.AllRoutesAnnouncement routes))

        ToFrontendYourNotLoggedIn ->
            sharedUpdate model (Shared.MsgFromBackend Shared.LogOut)

        ToFrontendYouAreAdmin ->
            sharedUpdate model (Shared.MsgFromBackend Shared.YouAreAdmin)

        ToFrontendAdminWholeModel backupModel ->
            pageUpdate (Gen.Msg.Admin__ShowJson (Pages.Admin.ShowJson.BackupModelFromBackend backupModel)) model

        _ ->
            ( model, Cmd.none )


pageUpdate : Pages.Msg -> Model -> ( Model, Cmd Msg )
pageUpdate pageMsg model =
    let
        ( page, effect ) =
            Pages.update pageMsg model.page model.shared model.url model.key
    in
    ( { model | page = page }
    , Effect.toCmd ( Shared, Page ) effect
    )


sharedUpdate : Model -> Shared.Msg -> ( Model, Cmd Msg )
sharedUpdate model sharedMsg =
    let
        ( shared, sharedCmd ) =
            Shared.update (Request.create () model.url model.key) sharedMsg model.shared

        ( page, effect ) =
            Pages.init (Gen.Route.fromUrl model.url) shared model.url model.key
    in
    if page == Gen.Model.Redirecting_ then
        ( { model | shared = shared, page = page }
        , Cmd.batch
            [ Cmd.map Shared sharedCmd
            , Effect.toCmd ( Shared, Page ) effect
            ]
        )

    else
        ( { model | shared = shared }
        , Cmd.map Shared sharedCmd
        )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    model.shared
        |> Shared.view (Request.create () model.url model.key)
            { page = Pages.view model.page model.shared model.url model.key |> View.map Page
            , toMsg = Shared
            }
        |> (\{ title, body } ->
                { title = title
                , body = [ Element.layout [] body ]
                }
           )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Pages.subscriptions model.page model.shared model.url model.key |> Sub.map Page
        , Shared.subscriptions (Request.create () model.url model.key) model.shared |> Sub.map Shared
        ]
