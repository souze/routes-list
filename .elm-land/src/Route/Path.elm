module Route.Path exposing (Path(..), fromString, fromUrl, href, toString)

import Html
import Html.Attributes
import Url exposing (Url)
import Url.Parser exposing ((</>))


type Path
    = Home_
    | Admin
    | Admin_AddUser
    | Admin_ChangePassword
    | Admin_RemoveUser
    | Admin_ShowJson
    | ChangePassword
    | InputJson
    | MoreOptions
    | NewRoute
    | OutputJson
    | Routes_Filter_ { filter : String }
    | SignIn_SignInDest_ { signInDest : String }
    | Stats
    | NotFound_


fromUrl : Url -> Path
fromUrl url =
    fromString url.path
        |> Maybe.withDefault NotFound_


fromString : String -> Maybe Path
fromString urlPath =
    let
        urlPathSegments : List String
        urlPathSegments =
            urlPath
                |> String.split "/"
                |> List.filter (String.trim >> String.isEmpty >> Basics.not)
    in
    case urlPathSegments of
        [] ->
            Just Home_

        "admin" :: [] ->
            Just Admin

        "admin" :: "add-user" :: [] ->
            Just Admin_AddUser

        "admin" :: "change-password" :: [] ->
            Just Admin_ChangePassword

        "admin" :: "remove-user" :: [] ->
            Just Admin_RemoveUser

        "admin" :: "show-json" :: [] ->
            Just Admin_ShowJson

        "change-password" :: [] ->
            Just ChangePassword

        "input-json" :: [] ->
            Just InputJson

        "more-options" :: [] ->
            Just MoreOptions

        "new-route" :: [] ->
            Just NewRoute

        "output-json" :: [] ->
            Just OutputJson

        "routes" :: filter_ :: [] ->
            Routes_Filter_
                { filter = filter_
                }
                |> Just

        "sign-in" :: signInDest_ :: [] ->
            SignIn_SignInDest_
                { signInDest = signInDest_
                }
                |> Just

        "stats" :: [] ->
            Just Stats

        _ ->
            Nothing


href : Path -> Html.Attribute msg
href path =
    Html.Attributes.href (toString path)


toString : Path -> String
toString path =
    let
        pieces : List String
        pieces =
            case path of
                Home_ ->
                    []

                Admin ->
                    [ "admin" ]

                Admin_AddUser ->
                    [ "admin", "add-user" ]

                Admin_ChangePassword ->
                    [ "admin", "change-password" ]

                Admin_RemoveUser ->
                    [ "admin", "remove-user" ]

                Admin_ShowJson ->
                    [ "admin", "show-json" ]

                ChangePassword ->
                    [ "change-password" ]

                InputJson ->
                    [ "input-json" ]

                MoreOptions ->
                    [ "more-options" ]

                NewRoute ->
                    [ "new-route" ]

                OutputJson ->
                    [ "output-json" ]

                Routes_Filter_ params ->
                    [ "routes", params.filter ]

                SignIn_SignInDest_ params ->
                    [ "sign-in", params.signInDest ]

                Stats ->
                    [ "stats" ]

                NotFound_ ->
                    [ "404" ]
    in
    pieces
        |> String.join "/"
        |> String.append "/"
