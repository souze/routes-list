module Pages.Admin.RemoveUser exposing (Model, Msg(..), page)

import Bridge
import CommonView
import Element exposing (Element)
import Element.Input
import Gen.Params.Admin.RemoveUser exposing (Params)
import Lamdera
import Page
import Request
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
    { username : String }


init : ( Model, Cmd Msg )
init =
    ( { username = "" }, Cmd.none )



-- UPDATE


type Msg
    = FieldUpdate String
    | RemoveUser


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldUpdate newValue ->
            ( { model | username = newValue }, Cmd.none )

        RemoveUser ->
            ( model
            , Lamdera.sendToBackend <|
                Bridge.ToBackendAdminMsg (Bridge.RemoveUser model.username)
            )



-- VIEW


view : Model -> View Msg
view model =
    { title = "Remove user"
    , body = viewBody model
    }


viewBody : Model -> Element Msg
viewBody model =
    CommonView.adminPageWithItems
        [ Element.Input.text []
            { onChange = FieldUpdate
            , text = model.username
            , placeholder = Nothing
            , label = Element.Input.labelAbove [] (Element.text "Username")
            }
        , CommonView.buttonToSendEvent "Submit" RemoveUser
        ]
