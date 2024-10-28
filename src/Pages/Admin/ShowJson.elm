module Pages.Admin.ShowJson exposing (Model, Msg(..), page)

import Auth
import BackupModel
import Bridge
import ClimbRoute exposing (RouteData)
import CommonView
import Effect exposing (Effect)
import Element exposing (Element)
import Evergreen.V3.Types exposing (BackupModel)
import Json.Encode
import JsonRoute
import Lamdera
import Page exposing (Page)
import Route exposing (Route)
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
    { backup : Maybe String
    }


init : ( Model, Effect Msg )
init =
    ( { backup = Nothing }
    , Effect.sendToBackend (Bridge.ToBackendAdminMsg Bridge.RequestModel)
    )



-- UPDATE


type Msg
    = BackupModelFromBackend BackupModel.BackupModel


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        BackupModelFromBackend backupModel ->
            ( { model | backup = Just <| backupModelToJsonStr backupModel }
            , Effect.none
            )


backupModelToJsonStr : BackupModel.BackupModel -> String
backupModelToJsonStr model =
    Json.Encode.list jsonEncodeBackupUser model
        |> Json.Encode.encode 4


jsonEncodeBackupUser : { username : String, routes : List RouteData } -> Json.Encode.Value
jsonEncodeBackupUser { username, routes } =
    Json.Encode.object
        [ ( "username", Json.Encode.string username )
        , ( "routes", Json.Encode.list JsonRoute.encodeRoute routes )
        ]



-- VIEW


view : Model -> View Msg
view model =
    { title = "View backup Json"
    , body = viewBody model
    }


viewBody : Model -> Element Msg
viewBody model =
    CommonView.adminPageWithItems
        [ model.backup
            |> Maybe.map Element.text
            |> Maybe.withDefault (Element.text "No model received yet")
        ]
