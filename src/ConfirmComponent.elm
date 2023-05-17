module ConfirmComponent exposing
    ( ButtonText(..)
    , Description(..)
    , Msg(..)
    , State(..)
    , TargetText(..)
    , initialState
    , update
    , view
    )

import CommonView
import Element exposing (Element)
import Element.Input
import Element.Region exposing (description)


type Msg
    = ConfirmCompTextChange String
    | FirstButtonPressed


type State
    = Waiting
    | Active String


update : Msg -> State -> State
update msg state =
    case msg of
        ConfirmCompTextChange newValue ->
            Active newValue

        FirstButtonPressed ->
            Active ""


type ButtonText
    = ButtonText String


type TargetText
    = TargetText String


type Description
    = Description String


initialState : State
initialState =
    Waiting


view : State -> ButtonText -> TargetText -> Description -> (Msg -> msg) -> msg -> Element msg
view state (ButtonText buttonText) (TargetText targetText) (Description description) eventFn confirmSuccessEvent =
    Element.column [ Element.spacing 10, Element.width Element.fill ]
        (case state of
            Active inputText ->
                [ Element.text <| description ++ "\nIf so, write \"" ++ targetText ++ "\" in the text box below"
                , Element.Input.text []
                    { onChange = \s -> eventFn (ConfirmCompTextChange s)
                    , text = inputText
                    , placeholder = Nothing
                    , label = Element.Input.labelHidden "input to confirm"
                    }
                , if inputText == targetText then
                    CommonView.buttonToSendEvent "Confirm" confirmSuccessEvent

                  else
                    Element.none
                ]

            Waiting ->
                [ CommonView.buttonToSendEvent buttonText (eventFn FirstButtonPressed) ]
        )
