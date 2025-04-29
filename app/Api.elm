module Api exposing (manifest, routes)

import ApiRoute exposing (ApiRoute)
import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import Html exposing (Html)
import Pages.Manifest as Manifest
import Route exposing (Route)
import Settings
import Sitemap


routes :
    BackendTask FatalError (List Route)
    -> (Maybe { indent : Int, newLines : Bool } -> Html Never -> String)
    -> List (ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    [ ApiRoute.succeed
        (getStaticRoutes
            |> BackendTask.map
                (\allRoutes ->
                    allRoutes
                        |> List.map
                            (\route ->
                                { path = Route.routeToPath route |> String.join "/"
                                , lastMod = Nothing
                                }
                            )
                        |> Sitemap.build { siteUrl = "https://tranquera.co" }
                )
        )
        |> ApiRoute.literal "sitemap.xml"
        |> ApiRoute.single
        |> ApiRoute.withGlobalHeadTags (BackendTask.succeed [ Head.sitemapLink "/sitemap.xml" ])
    ]


manifest : Manifest.Config
manifest =
    Manifest.init
        { name = Settings.title
        , description = Settings.subtitle
        , startUrl = Route.Index |> Route.toPath
        , icons = []
        }
