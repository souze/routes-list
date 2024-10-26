module Auth exposing
    ( User
    , onPageLoad, viewCustomPage
    )

{-|

@docs User
@docs beforeProtectedInit

-}

import Auth.Action
import ElmSpa.Page as ElmSpa
import Route
import Shared


{-| Replace the "()" with your actual User type
-}
type alias User =
    Shared.User


viewCustomPage : Shared.Model -> Route () -> View Never
viewCustomPage shared route =
    case shared.user of
        Just user ->
            case route.url.path of
                "profile" ->
                    Html.text "Profile"

                _ ->
                    Html.text "Not Found"

        Nothing ->
            Html.text "Not Found"


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
            Auth.Action.loadPageWithUser Shared.NormalUser

        Nothing ->
            Auth.Action.pushRoute
                { path = Route.Path.SignIn
                , query = Dict.fromList [ ( "from", route.url.path ) ]
                , hash = Nothing
                }



--     ElmSpa.RedirectTo
-- <|
--     Gen.Route.SignIn__SignInDest_ { signInDest = req.url.path |> String.replace "/" "_" }
