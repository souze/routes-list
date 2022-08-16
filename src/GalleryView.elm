module GalleryView exposing (..)

import Element exposing (Element)
import Gallery
import Gallery.Image
import Html exposing (Html)
import Html.Attributes
import Route
import Types exposing (..)


viewGallery : Route.RouteId -> List String -> List String -> Gallery.State -> Element FrontendMsg
viewGallery rid pictures videos state =
    Element.html
        (Html.map (Types.FrontendGalleryMsg rid) <|
            Gallery.view config state [ Gallery.Arrows ] (createPictureSlides pictures ++ createVideoSlides videos)
        )


createPictureSlides : List String -> List ( String, Html msg )
createPictureSlides =
    List.map (\url -> ( url, Gallery.Image.slide url Gallery.Image.Contain ))


createVideoSlides : List String -> List ( String, Html msg )
createVideoSlides =
    List.map (\url -> ( url, videoSlide url ))


{-| Create an video slide that either fits or covers the gallery container
-}
videoSlide : String -> Html msg
videoSlide _ =
    Html.video
        [ Html.Attributes.width 300
        , Html.Attributes.height 400
        , Html.Attributes.controls True
        ]
        [ Html.source
            [ Html.Attributes.type_ "video/mp4"
            , Html.Attributes.src "https://filedn.com/looL0p0cbRa5gF0z3SS8rBb/route_list/20200408_175256.mp4"
            ]
            []
        ]


config : Gallery.Config
config =
    Gallery.config
        { id = "image-gallery"
        , transition = 500
        , width = Gallery.px 300
        , height = Gallery.px 400
        }
