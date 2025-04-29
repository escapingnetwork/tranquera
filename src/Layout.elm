module Layout exposing (seoHeaders, view)

import Head exposing (Tag)
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Events as Events
import LanguageTag.Language as Language
import LanguageTag.Region as Region
import Pages.Url
import Route exposing (Route)
import Settings
import Svg
import Svg.Attributes as SvgAttrs
import UrlPath


seoHeaders : List Tag
seoHeaders =
    let
        imageUrl =
            [ "media", "banner.webp" ] |> UrlPath.join |> Pages.Url.fromPath
    in
    Seo.summaryLarge
    { canonicalUrlOverride = Nothing
    , siteName = Settings.title
    , image =
        { url = imageUrl
        , alt = "logo"
        , dimensions = Just { width = 500, height = 333 }
        , mimeType = Nothing
        }
    , locale = Nothing
    , description = "desc"
    , title = "Tranquera"
    }
    |> Seo.website


view : Bool -> msg -> List (Html msg) -> List (Html msg)
view showMenu onMenuToggle body =
    [ Html.header [ Attrs.class "fixed top-0 w-full z-50 bg-white dark:bg-black dark:text-white" ]
        [ Html.div [ Attrs.class "container mx-auto px-8 py-6 flex justify-between items-center" ]
            [ Html.a [ Attrs.href "/", Attrs.attribute "aria-label" "Tranquera Home", Attrs.class "text-4xl font-extrabold tracking-tighter" ]
                [ Html.text "Tranquera." ]
            , viewMenu showMenu onMenuToggle
            ]
        ]
    , Html.main_ [ Attrs.class "bg-white dark:bg-black dark:text-white mx-auto min-h-screen"] body
    , Html.footer [ Attrs.class " py-10 border-t bg-white dark:bg-black dark:text-white" ]
        [ Html.div [ Attrs.class "container mx-auto px-8 text-center" ]
            [ Html.p [ Attrs.class "text-base tracking-wide" ]
                [ Html.text "© 2025 Tranquera." ]
            ]
        ]
    ]


viewMenu :  Bool -> msg -> Html msg
viewMenu showMenu onMenuToggle =
    let
        mainMenuItems = 
                [ Html.ul [ Attrs.class "hidden sm:block space-x-10 text-base uppercase tracking-widest" ]
                    [  Html.a [ Attrs.href "http://localhost:1234/#projects", Attrs.class "nav-link" ] [ Html.text "Projects" ] 
                    ,  Html.a [ Attrs.href "http://localhost:1234/#news", Attrs.class "nav-link" ] [ Html.text "News" ] 
                    ,  Html.a [ Attrs.href "http://localhost:1234/#contact", Attrs.class "nav-link" ] [ Html.text "Contact" ] 
                    ]
                ]

        sideMenuItems = 
                [ Html.ul [ Attrs.class "flex flex-col space-y-4 text-base uppercase tracking-widest" ]
                    [  Html.a [ Attrs.href "http://localhost:1234/#projects", Attrs.class "nav-link" ] [ Html.text "Projects" ] 
                    ,  Html.a [ Attrs.href "http://localhost:1234/#news", Attrs.class "nav-link" ] [ Html.text "News" ] 
                    ,  Html.a [ Attrs.href "http://localhost:1234/#contact", Attrs.class "nav-link" ] [ Html.text "Contact" ] 
                    ]
                ]
    in
    Html.nav
        [ Attrs.class "flex items-center leading-5 space-x-4 sm:space-x-6"
        ]
        (mainMenuItems
            ++ [ Html.button
                    [ Attrs.attribute "aria-label" "Toggle Menu"
                    , Attrs.class "sm:hidden"
                    , Events.onClick onMenuToggle
                    ]
                    [ Svg.svg
                        [ SvgAttrs.viewBox "0 0 20 20"
                        , SvgAttrs.fill "currentColor"
                        , SvgAttrs.class "text-gray-900 dark:text-gray-100 h-8 w-8"
                        ]
                        [ Svg.path
                            [ SvgAttrs.fillRule "evenodd"
                            , SvgAttrs.d "M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z"
                            , SvgAttrs.clipRule "evenodd"
                            ]
                            []
                        ]
                    ]
               , Html.div
                    [ Attrs.class "fixed left-0 top-0 z-40 h-full w-full transform opacity-95 dark:opacity-[0.98] bg-white duration-300 ease-in-out dark:bg-gray-950"
                    , Attrs.classList
                        [ ( "translate-x-0", showMenu )
                        , ( "translate-x-full", not showMenu )
                        ]
                    ]
                    [ Html.div
                        [ Attrs.class "flex justify-end"
                        ]
                        [ Html.button
                            [ Attrs.class "mr-8 mt-11 h-8 w-8"
                            , Attrs.attribute "aria-label" "Toggle Menu"
                            , Events.onClick onMenuToggle
                            ]
                            [ Svg.svg
                                [ SvgAttrs.viewBox "0 0 20 20"
                                , SvgAttrs.fill "currentColor"
                                , SvgAttrs.class "text-gray-900 dark:text-gray-100"
                                ]
                                [ Svg.path
                                    [ SvgAttrs.fillRule "evenodd"
                                    , SvgAttrs.d "M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                                    , SvgAttrs.clipRule "evenodd"
                                    ]
                                    []
                                ]
                            ]
                        ]
                    , Html.div
                        [ Attrs.class "fixed mt-8 h-full"
                        ]
                        <| sideMenuItems
                    ]
               ]
        )