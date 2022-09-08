module Pages.Admin.ShowJson exposing (Model, Msg(..), page)

import BackupModel
import Bridge
import CommonView
import Element exposing (Element)
import Evergreen.V3.Types exposing (BackupModel)
import Gen.Params.Admin.ShowJson exposing (Params)
import Json.Encode
import JsonRoute
import Lamdera
import Page
import Request
import Route exposing (RouteData)
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.element
        (\_ ->
            { init = init
            , update = update
            , view = view
            , subscriptions = \_ -> Sub.none
            }
        )



-- INIT


type alias Model =
    { backup : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( { backup = Nothing }
    , Lamdera.sendToBackend <| Bridge.ToBackendAdminMsg Bridge.RequestModel
    )



-- UPDATE


type Msg
    = BackupModelFromBackend BackupModel.BackupModel


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BackupModelFromBackend backupModel ->
            ( { model | backup = Just <| backupModelToJsonStr backupModel }
            , Cmd.none
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
