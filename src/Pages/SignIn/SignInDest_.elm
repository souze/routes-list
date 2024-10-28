module Pages.SignIn.SignInDest_ exposing (FieldType(..), Model, Msg(..), page)

import Bridge
import CommonView
import Effect exposing (Effect)
import Element exposing (Element)
import Element.Background
import Element.Font
import Element.Input
import Html.Events
import Json.Decode
import Lamdera
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)
import Widget
import Widget.Material


page : Shared.Model -> Route { signInDest : String } -> Page Model Msg
page model route =
    Page.new
        { init = \_ -> init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- INIT


type alias Model =
    { username : String
    , password : String
    , showPassword : Bool
    , errorMsg : Maybe String
    }


init : ( Model, Effect Msg )
init =
    ( { username = ""
      , password = ""
      , showPassword = False
      , errorMsg = Nothing
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = ClickedSignIn
    | FieldChanged FieldType String
    | ToggleShowPassword
    | WrongUsernameOrPassword


type FieldType
    = UsernameField
    | PasswordField


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ClickedSignIn ->
            ( model
            , Effect.sendToBackend (Bridge.ToBackendLogIn model.username model.password)
            )

        FieldChanged UsernameField newValue ->
            ( { model | username = newValue }
            , Effect.none
            )

        FieldChanged PasswordField newValue ->
            ( { model | password = newValue }
            , Effect.none
            )

        ToggleShowPassword ->
            ( { model | showPassword = not model.showPassword }, Effect.none )

        WrongUsernameOrPassword ->
            ( { model | errorMsg = Just "Wrong username or password 😢" }
            , Effect.none
            )



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
    [ Element.Input.username [ CommonView.onEnter ClickedSignIn ]
        { onChange = FieldChanged UsernameField
        , text = data.username
        , placeholder = Nothing
        , label = Element.Input.labelLeft [] (Element.text "Username")
        }
    , Element.row [ Element.spacing 15, Element.width Element.fill ]
        [ Element.Input.currentPassword [ CommonView.onEnter ClickedSignIn, Element.width Element.fill ]
            { onChange = FieldChanged PasswordField
            , text = data.password
            , placeholder = Nothing
            , label = Element.Input.labelLeft [] (Element.text "Password")
            , show = data.showPassword
            }
        , Element.text
            (if data.showPassword then
                "Hide"

             else
                "Show"
            )
        , Widget.switch (Widget.Material.switch Widget.Material.defaultPalette)
            { description = "Show password"
            , onPress = Just ToggleShowPassword
            , active = data.showPassword
            }
        ]
    , case data.errorMsg of
        Just errorMsg ->
            Element.el [ Element.Font.color red ] (Element.text errorMsg)

        Nothing ->
            Element.none
    , buttonToSendEvent "Login" ClickedSignIn
    ]


red : Element.Color
red =
    Element.rgb255 200 30 30


actionButtonLabel : String -> Element.Element msg
actionButtonLabel text =
    Element.el [ Element.Background.color (Element.rgb 0.6 0.6 0.6), Element.padding 8 ] (Element.text text)


buttonToSendEvent : String -> Msg -> Element Msg
buttonToSendEvent labelText event =
    Element.Input.button []
        { onPress = Just event
        , label = actionButtonLabel labelText
        }
