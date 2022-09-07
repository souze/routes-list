module Pages.SignIn exposing (Model, Msg, page)

import Bridge
import Effect exposing (Effect)
import Element exposing (Element)
import Element.Background
import Element.Input
import Gen.Params.SignIn exposing (Params)
import Lamdera
import Page
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { username : String
    , password : String
    }


init : ( Model, Effect Msg )
init =
    ( { username = "", password = "" }, Effect.none )



-- UPDATE


type Msg
    = ClickedSignIn
    | FieldChanged String String


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ClickedSignIn ->
            ( model
            , Effect.fromCmd <|
                Lamdera.sendToBackend
                    (Bridge.ToBackendLogIn model.username model.password)
            )

        FieldChanged "username" newValue ->
            ( { model | username = newValue }
            , Effect.none
            )

        FieldChanged "password" newValue ->
            ( { model | password = newValue }
            , Effect.none
            )

        FieldChanged _ _ ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Sign in"
    , body = mainColumn <| viewLogin model
    }


mainColumn : List (Element Msg) -> Element Msg
mainColumn =
    Element.column [ Element.spacing 10, Element.padding 20, Element.width Element.fill ]


viewLogin : Model -> List (Element Msg)
viewLogin data =
    [ Element.Input.username []
        { onChange = FieldChanged "username"
        , text = data.username
        , placeholder = Nothing
        , label = Element.Input.labelLeft [] (Element.text "Username")
        }
    , Element.Input.currentPassword []
        { onChange = FieldChanged "password"
        , text = data.password
        , placeholder = Nothing
        , label = Element.Input.labelLeft [] (Element.text "Password")
        , show = False
        }
    , buttonToSendEvent "Login" ClickedSignIn
    ]


actionButtonLabel : String -> Element.Element msg
actionButtonLabel text =
    Element.el [ Element.Background.color (Element.rgb 0.6 0.6 0.6), Element.padding 8 ] (Element.text text)


buttonToSendEvent : String -> Msg -> Element Msg
buttonToSendEvent labelText event =
    Element.Input.button []
        { onPress = Just event
        , label = actionButtonLabel labelText
        }
