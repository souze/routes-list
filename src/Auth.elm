module Auth exposing
    ( User
    , onPageLoad, viewCustomPage
    )

{-|

@docs User
@docs beforeProtectedInit

-}

import Auth.Action
import Dict
import ElmSpa.Page as ElmSpa
import Route exposing (Route)
import Route.Path
import Shared
import Shared.Model
import View exposing (View)


{-| Replace the "()" with your actual User type
-}
type alias User =
    Shared.Model.User


viewCustomPage : Shared.Model -> Route () -> View Never
viewCustomPage shared route =
    case shared.user of
        Just user ->
            case route.url.path of
                "profile" ->
                    View.fromString "Profile"

                _ ->
                    View.fromString "Not Found"

        Nothing ->
            View.fromString "Not Found"


{-| This function will run before any `protected` pages.

Here, you can provide logic on where to redirect if a user is not signed in. Here's an example:

    case shared.user of
        Just user ->
            ElmSpa.Provide user

        Nothing ->
            ElmSpa.RedirectTo Gen.Route.SignIn

-}
onPageLoad : Shared.Model -> Route () -> Auth.Action.Action User
onPageLoad shared route =
    case shared.user of
        Just token ->
            Auth.Action.loadPageWithUser Shared.Model.NormalUser

        Nothing ->
            Auth.Action.pushRoute
                { path = Route.Path.SignIn_SignInDest_ { signInDest = route.url.path }
                , query = Dict.fromList [ ( "from", route.url.path ) ]
                , hash = Nothing
                }



--     ElmSpa.RedirectTo
-- <|
--     Gen.Route.SignIn__SignInDest_ { signInDest = req.url.path |> String.replace "/" "_" }
